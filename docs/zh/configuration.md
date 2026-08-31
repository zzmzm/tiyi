# 配置模板

太一有两套用途不同的 YAML：`tiyi.yaml` 控制进程如何启动；声明式 manifest 管理
持久化的应用资源。两者不能互相粘贴使用。

| 文件 | 管理内容 | 生效方式 |
|---|---|---|
| [`templates/tiyi.yaml`](templates/tiyi.yaml) | API/代理监听、状态路径、认证、更新与 Geo 设置 | 启动/重启 `tiyi run --config ...` |
| [`templates/apply.yaml`](templates/apply.yaml) | 站点、上游池、基础 WAF 策略与 IP 列表地址 | 先 `tiyi diff -f ...`，再 `tiyi apply -f ...` |

控制台系统设置、证书、策略层、规则、IP 列表绑定、Country Access、告警/SIEM、
用户与角色也是持久资源，但当前不是 apply kind。请使用各自的 UI、CLI 或 API。

## 安装并校验 `tiyi.yaml`

模板包含当前全部进程配置键；省略的键继续使用内置默认值。

```sh
# 先创建服务账号和 unit，但暂不启动。
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo install -m 0640 -o root -g tiyi \
  docs/zh/templates/tiyi.yaml /etc/tiyi/tiyi.yaml
sudo editor /etc/tiyi/tiyi.yaml

# 只读检查配置与启动前提。
sudo tiyi --config /etc/tiyi/tiyi.yaml doctor --mode run

# 预创建管理员、在当前终端打印一次性密码并启动。
sudo tiyi install --now
```

不在仓库检出目录中阅读时，请先下载上方链接的模板，或复制完整 YAML。
打包的 unit 固定读取 `/etc/tiyi/tiyi.yaml`；前台进程可用
`tiyi --config /path/to/tiyi.yaml run` 指定其他路径。

优先级是内置默认值、YAML、二进制支持的 `TIYI_*` 配置环境变量、显式 CLI 参数。
重要安全事项：

- 生产环境为 `auth.jwt_secret` 设置至少 32 字节的私密随机值。留空会导致每次
  重启后已有会话失效。
- `crypto.kek_file` 留空时使用持久化的 `<state-db 所在目录>/kek.bin`，太一只在
  首次创建。必须与 `state.db` 一起备份。外部 KEK 路径是可选项，必须指向已有且
  服务可读的 32 字节文件（或服务有权创建的位置）。
- 四个 bootstrap 字段全留空时，会生成一次性随机管理员密码。不要在可读配置中
  长期保留真实 bootstrap 密码。
- HTTPS 控制台应设置 `auth.refresh_cookie_secure: true`。

## 预览并 apply 持久资源

```sh
cp docs/zh/templates/apply.yaml desired.yaml
editor desired.yaml
tiyi crs list                   # 核对 crsRulesetRef
tiyi diff -f desired.yaml       # 只读预览
tiyi apply -f desired.yaml --dry-run
tiyi apply -f desired.yaml
tiyi system health
```

远程执行时增加 `--api URL --token JWT`；`-f -` 表示从 stdin 读取。

每个文档都必须包含 `apiVersion: tiyi.io/v1`、受支持的 `kind`、
`metadata.name` 和 `spec`。当前 kind 只有 `Upstream`、`Site`、`Policy`、
`IpList`；多个文档用 `---` 分隔。

避免意外的 apply 规则：

- 按大小写不敏感的 `(kind, metadata.name)` 匹配。改名会创建另一个资源，不会重命名
  或删除旧资源。
- `metadata.id` 是仅在创建时使用的可选 UUID。租户由已认证调用方决定，因此
  `metadata.tenant` 会被拒绝。
- `upstreamRef`、`policyRef`、`certRef`、`crsRulesetRef` 在写入前按资源名、CRS ID
  或 CRS 版本解析；同一文件支持向前引用。
- `spec` 会完整替换 apply 管理的字段；省略的可选字段会回到默认值或空值。
  apply 不是 merge patch。
- 未知字段与 API/数据库别名会被拒绝。文件中缺少某个资源不会触发删除。
- 一份 manifest 的数据库写入共用一个 SQLite 事务；解析、引用或写入失败会整体回滚。
- 代理发布发生在提交之后。因此 `proxy apply failed` 表示资源行已经持久化，但代理
  保留 last-good 运行配置。修复原因后用同一 manifest 重试。

## 支持的 spec 字段

| Kind | 当前 apply 字段 |
|---|---|
| `Upstream` | 必填 `backends[]`（`url`、`weight`、`healthCheckPath`）；`loadBalance`（`round_robin`）；`healthCheck`（`path`、`method`、`expectedStatus`、`intervalSeconds`、`timeoutSeconds`、`unhealthyThreshold`、`healthyThreshold`、`followRedirects`、`expectedBody`、`host`）；`status`（`active`、`disabled`）。健康检查 path 为空即关闭主动探测。 |
| `Site` | `primaryHost`；`aliases[]`；`upstreamRef` 与 `upstreamsInline[]` 至多选一个；`tls`（`mode`、`certRef`、`minVersion`、`httpBehavior`）；`waf`（`enabled`、`policyRef`、`mode`）；`botProtection`（`mode`、挑战/clearance TTL、工作量难度、网络绑定、豁免路径、可信 IP 列表引用；启用模式要求仅 HTTPS）；`status`。 |
| `Policy` | `engineState`（`on`、`detection_only`、`off`）；`blockingMode`（`anomaly`、`self_contained`）；`crsRulesetRef`；`status`（`draft`、`active`、`archived`）。active 必须有 ruleset；策略层、规则和绑定需单独管理。 |
| `IpList` | `description`；`entries[]`（`cidr`、`description`、RFC 3339 `expireAt`）。单个 IP 会规范成 `/32` 或 `/128`；拒绝 `geo:*`。apply 列表后还需创建绑定才会产生防护行为。 |

证书不是 apply kind。先通过证书 UI 或 CLI 上传/签发，再在
`Site.spec.tls.certRef` 中引用证书名称。
