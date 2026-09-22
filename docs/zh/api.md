# API 接入与完整参考

适用版本：**v3.8.0**。要用脚本完成控制台操作，最容易的入口是 ConnectRPC 的 HTTP JSON 请求：
`POST /tiyi.v1.服务名/方法名`，不需要 SDK。应用自身的 OpenAPI 文件用于[API 请求防护](api-protection.md)，
本页讲的是**管理太一的 API**。

完整目录：[309 个 RPC / 26 个服务](../reference/rpc-index.md) · [请求/响应字段](../reference/README.md) ·
[权限目录](../reference/permissions.md)。每个 RPC 页给出准确路径、请求、响应、枚举和权限，英文协议字段保持原名。

<a id="authentication"></a>
## 1. 选择认证方式

| 场景 | 入口 | 凭据 |
|---|---|---|
| 在太一主机本地维护 | `/run/tiyi/admin.sock` | Unix 文件权限，通常使用 sudo；相当于本地管理员 |
| 自己的电脑、CI、其他服务 | 管理 URL，生产使用 HTTPS | `Authorization: Bearer JWT`，权限来自登录用户 |
| 远端 Agent | 生成的节点安装流程 | 有有效期和节点数上限的注册 token 与节点身份；不是管理员 JWT |

本机免登录读取示例：

```sh
sudo curl --fail-with-body -sS --unix-socket /run/tiyi/admin.sock \
  http://localhost/tiyi.v1.SiteService/ListSites \
  -H 'Content-Type: application/json' -d '{"page":{"page":1,"pageSize":20}}'
```

不要把整个管理 socket 转发到公开 TCP 端口。远程自动化应创建满足任务所需权限的用户和角色。

## 2. 登录并取得 token

下例使用 Bash、curl、Python 3、jq。将下面的 `SERVER_IP` 换成太一主机的实际 IP；已配置 HTTPS 管理域名时，使用对应 URL。
代码里的用户名默认 `admin`，需要时改成自动化账号。
密码在终端隐藏输入，不写到命令历史；登录材料放在临时私有目录。

```sh
export TIYI_API='http://SERVER_IP:8080'
umask 077
SESSION_DIR=$(mktemp -d)
python3 - "$SESSION_DIR/login.json" <<'PY'
import getpass, json, pathlib, sys
pathlib.Path(sys.argv[1]).write_text(json.dumps({
    "username": "admin", "password": getpass.getpass("Tiyi password: ")
}))
PY
curl --fail-with-body -sS -c "$SESSION_DIR/cookies" \
  -H 'Content-Type: application/json' \
  --data-binary @"$SESSION_DIR/login.json" \
  "$TIYI_API/tiyi.v1.AuthService/Login" -o "$SESSION_DIR/session.json"
rm "$SESSION_DIR/login.json"
while jq -e '.challengeRequired == true' "$SESSION_DIR/session.json" >/dev/null; do
  python3 - "$SESSION_DIR/challenge.json" <<'PY'
import getpass, json, pathlib, sys
pathlib.Path(sys.argv[1]).write_text(json.dumps({"code": getpass.getpass("MFA / RADIUS code: ")}))
PY
  curl --fail-with-body -sS -b "$SESSION_DIR/cookies" -c "$SESSION_DIR/cookies" \
    -H 'Content-Type: application/json' --data-binary @"$SESSION_DIR/challenge.json" \
    "$TIYI_API/tiyi.v1.AuthService/CompleteAuthenticationChallenge" \
    -o "$SESSION_DIR/session.json" || break
  rm -f "$SESSION_DIR/challenge.json"
done
TIYI_TOKEN=$(jq -er '.accessToken | select(length > 0)' "$SESSION_DIR/session.json")
export TIYI_TOKEN
tiyi auth user
```

`auth user` 成功返回当前用户，说明 token 可用。若登录失败，先处理错误再继续，不能把空 token 当成功。
启用 TOTP 或 RADIUS 挑战时，`challengeRequired` 为 true；需要携带登录返回的挑战 cookie 完成挑战。
OIDC/SAML 使用浏览器跳转流程，不是把身份提供商 token 当作太一 JWT。

CLI 不会自动把 `auth login` 输出存成登录会话。这里通过 `TIYI_API` 和 `TIYI_TOKEN` 为后续 CLI 调用提供身份。
默认 access token 有效期 8 小时，refresh 为 7 天，可由管理员调整。

## 3. 查询与创建站点

先定义一个可重复使用的调用函数，再查询第一页：

```sh
tiyi_rpc() {
  curl --fail-with-body -sS "$TIYI_API/tiyi.v1.$1" \
    -H "Authorization: Bearer $TIYI_TOKEN" \
    -H 'Content-Type: application/json' -H 'Connect-Protocol-Version: 1' \
    --data-binary "$2"
}
tiyi_rpc SiteService/ListSites '{"page":{"page":1,"pageSize":20}}'
```

结果的 `items` 是当前页，`page.total` 是总数（64 位整数用字符串）。增加 `page.page` 继续获取，不能假设第一页就是全部资源。

以下会创建一个**立即启用**的演示站点。先准备快速开始的源站，替换已被使用的示例域名/名称后再执行：

```sh
cat > api-site.json <<'JSON'
{
  "site": {
    "name": "api-example",
    "primaryHost": "api.example.com",
    "upstreams": [{"inline": {"url": "http://127.0.0.1:9000", "weight": 100}}],
    "tls": {"mode": "TLS_MODE_NONE"},
    "waf": {"enabled": true, "mode": "WAF_MODE_BLOCKING"},
    "status": "RESOURCE_STATUS_ACTIVE"
  }
}
JSON
tiyi_rpc SiteService/CreateSite @api-site.json > created-site.json
SITE_ID=$(jq -er '.site.id' created-site.json)
curl -i -H 'Host: api.example.com' http://127.0.0.1/
```

应看到源站正常响应。WAF 已开启，没有指定策略时使用 Light。实际接入应再验证攻击请求及节点发布结果。

## 4. 只修改一个字段，并检测并发变更

读取最新站点，带上返回的 revision 和字段掩码只改名称：

```sh
jq -n --arg id "$SITE_ID" '{id:$id}' > get-site.json
tiyi_rpc SiteService/GetSite @get-site.json > current-site.json
jq '{site:{id:.site.id,name:"api-renamed"},
     revision:.site.revision,updateMask:"name"}' current-site.json > update-site.json
tiyi_rpc SiteService/UpdateSite @update-site.json
```

`updateMask` 是逗号分隔的 JSON 字段路径字符串，不是数组。保留 `revision` 原有十进制字符串，避免 JavaScript 精度损失。
遇到 `aborted` 或 revision 冲突，应重新读取、比较差异并重新决定变更，不能盲目覆盖。
每个服务的更新规则不同，以完整接口定义为准；策略层写入等接口可能是完整替换。

## 5. 续期、退出与脚本约定

refresh token 默认在 HttpOnly cookie 中，不在登录 JSON 里。以下使用最新 cookie 续期：

```sh
curl --fail-with-body -sS -b "$SESSION_DIR/cookies" -c "$SESSION_DIR/cookies" \
  -H 'Content-Type: application/json' -d '{}' \
  "$TIYI_API/tiyi.v1.AuthService/Refresh" -o "$SESSION_DIR/session.json"
TIYI_TOKEN=$(jq -er '.accessToken | select(length > 0)' "$SESSION_DIR/session.json")
export TIYI_TOKEN
```

Refresh 会轮换 token；不要并发用同一个旧 refresh cookie，也不要反复重放旧值。
完成任务后调用 Logout 并清理本次临时凭据：

```sh
curl --fail-with-body -sS -b "$SESSION_DIR/cookies" \
  -H 'Content-Type: application/json' -d '{}' "$TIYI_API/tiyi.v1.AuthService/Logout"
unset TIYI_TOKEN
rm -rf -- "$SESSION_DIR"
unset SESSION_DIR
```


| 约定 | 正确处理 |
|---|---|
| JSON 字段 | 用接口表中的 lowerCamelCase，如 `siteId`；不要沿用 apply YAML 的字段别名 |
| 64 位整数 | revision、计数、总数保留十进制字符串；只在确认范围后转换数值 |
| `bytes` | base64 字符串；例如 `source`、`reportJson`、证书 PEM 字段 |
| 枚举 | 使用完整符号名，如 `RESOURCE_STATUS_ACTIVE`；`TLS_MODE_MANAGED_ACME` |
| 时间 | RFC 3339，建议 UTC；例如 `2026-09-17T08:00:00Z` |
| 租户 | 来自调用身份；不要通过伪造 `tenantId` 跨租户 |
| 幂等 | 只有声明支持的接口才传 `idempotencyKey`；精确重试复用同 key/同请求，修改内容用新 key |

## 6. 错误与权限

Connect 错误通常为 `{"code":"permission_denied","message":"..."}`。保留响应体和 HTTP 状态，
不要只判断网络请求是否完成。

| 错误 | 下一步 |
|---|---|
| `unauthenticated` / 401 | 核对 token、期限、时钟；需要时刷新或重新登录 |
| `permission_denied` / 403 | 检查用户角色与该 RPC 所需的全部权限 |
| `invalid_argument` / 400 | 按字段表检查名称、类型、枚举、上限、必填值 |
| `already_exists` / 409 | 查询同名/同域名资源；不要重复创建 |
| `aborted` / 409 | 版本或预览已变化；重新读取与预览 |
| `failed_precondition` | 检查证书、策略、依赖、节点能力与当前状态 |
| `resource_exhausted` / `unavailable` | 有界退避；写入先核对是否已成功，按接口幂等规则重试 |
| `unimplemented` / 501 | 当前入口不可执行，不能用重试或伪造参数绕过 |

`SystemService.Health` 需要 `system:read`；匿名存活探针用 `/healthz`。声明字段不是权限授权。

<a id="api-documents"></a>
## 7. API 文档与校验发布流程

先运行[可复制的上传与预览](api-protection.md#7-cli-与-api-自动化)。自动化按下面依赖顺序调用
[ApiSchemaService](../reference/services/api_schema.md)；资源 ID、哈希和 approval 都取自真实响应：

| 步骤 | 方法 / CLI | 需要交给下一步的结果 |
|---|---|---|
| 上传文件 | `StageSchemaSource` / `api-document upload` | `source.id`；`source` 输入是文件的 base64 |
| 审核地址与已有接口匹配 | `PreviewApiDeclaration` / `declaration-preview` | `reportSha256`、`catalogSha256`、解码后的报告与匹配结果 |
| 保存审核后的声明 | `StageApiDeclaration` / `declaration-stage` | `contract.id`；匹配冲突时明确填写 decisions；覆盖范围独立审核 |
| 编译可执行检查 | `StageSchemaProfile` / `profile-stage` | `profile.id`、能力/诊断报告；不支持项不能当作已执行 |
| 选择校验接口 | `StageSchemaBindings` / `bindings-stage` | `bindings.id`；`operationKeys` 选检查接口，`enforceOperationKeys` 是其中强制执行的子集 |
| 预览发布影响 | `PreviewSchemaControl` / `preview` | 完整 `approval`、变更/资源报告、`executionSupported` |
| 提交审核结果 | `ChangeSchemaControl` / `publish` | `intent` 和状态；提交原 approval、原因、幂等键及实际已审核的确认项 |
| 检查应用与请求 | `OperationControlService.GetOperationControlState`、`GetSchemaValidation`、`GetSchemaDetection` | 服务节点结果、配置状态、检测统计 |

只发布接口清单时可省略校验绑定；这不会启用请求校验。根地址映射为 `basePath: ""`。
学习、请求规范编辑、文档版本、停用与回滚同样有各自 RPC，见[字段参考](../reference/services/api_schema.md)。
API 资产行的隐藏/恢复不会开启拦截；清单成员变化使用 `StageApiCatalogChange` 并完成相同发布流程。


### 可复制流程：把演示订单接口发布为仅观察

以下接续 [API 防护教程](api-protection.md#7-cli-与-api-自动化)产生的 `source-result.json`、
`declaration-preview.json` 和 `preview-result.json`，在同一目录、同一终端运行，需要 jq。
只用于已经审核的单接口演示；真实文档出现歧义、接口冲突或不支持项时，先解决报告中的问题，不能自动全选确认。

**保存声明并编译检查。** 已审核映射和匹配结果后执行：

```sh
jq -s '.[0] + {reportSha256:.[1].reportSha256,
  catalogSha256:.[1].catalogSha256,idempotencyKey:"orders-declaration-v1"}' \
  declaration-preview.json preview-result.json > declaration-stage.json
sudo tiyi api-document declaration-stage -f declaration-stage.json > declaration-result.json
jq '. + {idempotencyKey:"orders-profile-v1"}' declaration-preview.json > profile-stage.json
sudo tiyi api-document profile-stage -f profile-stage.json > profile-result.json
jq '{siteId:.contract.siteId,contractId:.contract.id}' declaration-result.json > contract-request.json
sudo tiyi api-document declaration -f contract-request.json > contract-result.json
jq -r '.contractJson' contract-result.json | base64 -d > contract.json
jq '.operations' contract.json
```

应只看到演示的 `POST /api/orders`。核对 profile 的报告；这里的操作仍没有发布到在线流量。

**选择观察并预览影响。** 下面选择该演示文档里的全部接口；自己的文档请把 `operationKeys` 缩小到已审核接口：

```sh
jq -n --slurpfile c declaration-result.json --slurpfile p profile-result.json \
  --slurpfile d contract.json '{siteId:$c[0].contract.siteId,
    declarationId:$c[0].contract.id,profileId:$p[0].profile.id,
    operationKeys:[$d[0].operations[].key],idempotencyKey:"orders-bindings-observe-v1"}' \
  > bindings-stage.json
sudo tiyi api-document bindings-stage -f bindings-stage.json > bindings-result.json
jq -n --slurpfile c declaration-result.json --slurpfile b bindings-result.json \
  '{siteId:$c[0].contract.siteId,action:"activate",contractId:$c[0].contract.id,
    bindingId:$b[0].bindings.id,undeclaredAction:"allow"}' > control-preview.json
sudo tiyi api-document preview -f control-preview.json > control-preview-result.json
jq '{executionSupported,approval}' control-preview-result.json
jq -r '.changesJson' control-preview-result.json | base64 -d
jq -r '.resourcesJson' control-preview-result.json | base64 -d
```

确认 `executionSupported` 为 true，查看影响范围、能力及资源报告。若预览显示无法执行或需要接受部分能力，先解决原因，不添加跳过检查的参数。

**提交审核并检查节点。** 以下确认项表示你已完成上一段审核；提交后查询对应的实际 intent，而非只查最近一次发布：

```sh
jq -e 'select(.executionSupported == true) | {approval:.approval,
  idempotencyKey:"orders-publish-observe-v1",reason:"Reviewed demo orders API",
  impactAcknowledged:true,resourceAcknowledged:true,typeOnlyAcknowledged:true}' \
  control-preview-result.json > publish-request.json
sudo tiyi api-document publish -f publish-request.json > publication-result.json
jq '{siteId:.intent.siteId,intentId:.intent.id}' publication-result.json > state-request.json
sudo curl --fail-with-body -sS --unix-socket /run/tiyi/admin.sock \
  http://localhost/tiyi.v1.OperationControlService/GetOperationControlState \
  -H 'Content-Type: application/json' --data-binary @state-request.json
```

重复最后的只读查询直到目标节点应用完成，再发送教程中的合法/类型错误请求，观察模式应均为 200（其他独立规则除外）。
幂等键仅供这个演示的一次版本使用；内容改变要换新 key，精确重试保留相同 key 和请求。

### 从观察切换到强制校验

验证通过且愿意对该演示接口阻断类型错误时，新建强制绑定：

```sh
jq '.enforceOperationKeys = .operationKeys |
    .idempotencyKey = "orders-bindings-enforce-v1"' \
  bindings-stage.json > bindings-enforce.json
sudo tiyi api-document bindings-stage -f bindings-enforce.json > bindings-result.json
```

然后重新执行上面的 control-preview 构造、preview 与报告审核，使用新的 `bindings-result.json`。
提交时将幂等键改为 `orders-publish-enforce-v1`、原因改为这次变更的真实理由；**不能复用观察模式的 approval**。
检查该次 intent 的节点结果后重放两类请求：合法 200，类型错误 403。回退时可重新选择观察绑定并走同样预览/发布流程，
或在控制台历史中选择已审核版本恢复。不会因为本地 JSON 文件改了就自动改变线上。

<a id="http"></a>
## 8. HTTP 探针、遥测和指标

| 端点 | 方法与认证 | 用途 |
|---|---|---|
| `/healthz` | GET，管理地址或 socket，匿名 | 只表示进程响应，正常为 `{"status":"ok"}` |
| `/readyz` | GET，仅本地 socket | 存储与内置代理/配置就绪；不就绪返回 503，网络管理地址返回 404 |
| `/metrics` | GET，仅本地 socket | OpenMetrics；[Prometheus 接入](operations.md#prometheus) |
| `/download/tiyi` | GET，匿名 | 当前 Controller 二进制，供相同平台 Agent 安装 |
| `/api/v1/telemetry/qps` | GET，JWT + `telemetry:read` | `site` 可选，`window` 例如 `1m` |
| `/api/v1/telemetry/series`、`topk` | GET，JWT + `telemetry:read` | 时间区间、维度与聚合数据 |
| `/api/v1/telemetry/apitree` | GET，JWT + `telemetry:read` | 必填 `site`，可加 `base=/`、`depth=128`、起止时间 |
| `/api/v1/telemetry/apitree/action` | POST，`api_inventory:write` + `site:read` | `hide`、`restore`、`retire`；必须附当前 `expected_revision` 字符串 |
| `/debug/*` | GET，仅本地 socket | 诊断信息，字段可能随版本变化 |

telemetry HTTP JSON 使用该接口自己的 snake_case 字段，错误格式为 `{"error":{"code":...,"message":...}}`。
资产动作的 `block` / `apply_body_suggestion` 是保留入口，返回 501；旧 `confirm` 动作不再支持。
未知管理 URL 可能返回控制台 HTML 和 200，检查 `Content-Type`，不能把它当作 API 成功。
