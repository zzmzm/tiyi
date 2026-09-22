# 配置文件与模板

适用版本：**v3.8.0**。先选择你要完成的任务；这几类文件有不同的入口和字段。

| 我要做什么 | 文件 / 下载 | 怎样使用 |
|---|---|---|
| 改管理地址、代理端口、数据库路径、启动认证 | [完整 tiyi.yaml](templates/tiyi.yaml) | `/etc/tiyi/tiyi.yaml`，重启进程 |
| 首次建站，或重复部署同名资源 | [最小 first-site.yaml](templates/first-site.yaml) | `tiyi diff` → `tiyi apply` |
| 自定义基础策略、IP 列表、站点和上游 | [四类资源 apply.yaml](templates/apply.yaml) | 编辑后 `tiyi diff` → `tiyi apply` |
| 从文件导入一个新站点及其依赖 | [site-import.json](templates/site-import.json) | [站点导入指南](site-import.md)；`tiyi site import` 或站点页导入 |
| 描述应用接口的请求字段 | [orders-openapi.yaml](templates/orders-openapi.yaml) | [API 资产导入](api-protection.md)；不用于站点导入 |

下载不是必需步骤，下面直接给出可复制的起点。完整模板的用途是查选项，不要求新用户填写所有键。

<a id="startup"></a>
## 1. 新安装的启动配置

此模板使用默认管理监听 `0.0.0.0:8080`，网站监听 80/443。浏览器直接访问 `http://服务器IP:8080`，将“服务器IP”替换为太一主机的实际 IP。
在**新主机安装完二进制、尚未启动服务时**运行。已有配置请先备份并编辑，不要直接覆盖。

```sh
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo tee /etc/tiyi/tiyi.yaml >/dev/null <<'YAML'
server:
  addr: "0.0.0.0:8080"
store:
  state_db: "/var/lib/tiyi/state.db"
proxy:
  http_addr: ":80"
  https_addr: ":443"
  caddy_admin_socket: "/var/lib/tiyi/caddy-admin.sock"
log:
  level: "info"
auth:
  refresh_cookie_secure: false
geo:
  auto_update: true
update:
  repo: "zzmzm/tiyi"
  channel: "stable"
  mirror: "auto"
YAML
sudo chown root:tiyi /etc/tiyi/tiyi.yaml
sudo chmod 0640 /etc/tiyi/tiyi.yaml
sudo tiyi --config /etc/tiyi/tiyi.yaml doctor --mode run
sudo tiyi install --now
```

`doctor` 检查启动前提，不代表网站已经能访问；最后还应执行 `sudo tiyi system health` 和真实站点请求。
前台运行同一文件：`sudo tiyi --config /etc/tiyi/tiyi.yaml run`。已有服务改 YAML 后执行
`sudo systemctl restart tiyi`。站点、策略等资源通过 UI/CLI/API 保存，通常直接发布，无需改 YAML 或重启。

<a id="ports"></a>
## 2. 已有 Web 服务：改用其他端口

把上面模板的相应字段改为：

```yaml
server:
  addr: "0.0.0.0:8081"
proxy:
  http_addr: ":8180"
  https_addr: ":18443"
  caddy_admin_socket: "/var/lib/tiyi/caddy-admin.sock"
```

已有服务：先备份启动文件，编辑上面列出的字段并保留其余配置，然后重启：

```sh
sudo cp -a /etc/tiyi/tiyi.yaml /etc/tiyi/tiyi.yaml.before-ports
sudoedit /etc/tiyi/tiyi.yaml
sudo systemctl restart tiyi
sudo systemctl status tiyi --no-pager
sudo tiyi system health
curl -i -H 'Host: quickstart.test' http://127.0.0.1:8180/
```

备份名如已存在请换一个；默认安装可能尚无 YAML，此时先按上节创建文件。新安装的首次启动使用 `sudo tiyi install --now`。
上面的请求需要已有 `quickstart.test` 站点和运行中的源站；没有站点时先完成[快速开始](getting-started.md)。

浏览器直接访问 `http://服务器IP:8081`。管理端口已改为 8081，网站 HTTP 请求使用 8180，源站端口不随它改变。
TLS 站点可用 `curl --resolve app.example.com:18443:服务器IP https://app.example.com:18443/` 验证；替换实际域名/IP，并使用覆盖该域名的证书。

失败时查看 journal；若需撤销且备份对应这次变更，恢复 `tiyi.yaml.before-ports` 到 `tiyi.yaml` 后重启。
公网 ACME HTTP-01 仍验证公网 80；自定义本地端口不会改变 CA 的目标。已有 Web 服务器占用端口时，先明确谁作为公网入口，再决定迁移端口或转发。

## 3. 固定密钥与配置优先级

默认值 → YAML → 支持的 `TIYI_*` 环境变量 → 显式 CLI 参数，后者优先。
例如 `TIYI_SERVER_ADDR` 对应 `server.addr`。完整键、默认值与 LDAP/RADIUS 选项见
[带注释的启动模板](templates/tiyi.yaml)。管理 socket 的路径、权限和组使用
`--admin-socket`、`--admin-socket-mode`、`--admin-socket-group`；它们不是该 YAML 的键。

在生产环境首次启动前固定 JWT 密钥，使重启不会使已有会话失效。下面为**尚无该文件的新安装**创建
root 可读的 systemd 环境文件；已有 `tiyi.env` 时只添加缺少的键，保留原有密钥与配置。

```sh
sudo sh -c 'umask 077; printf "TIYI_AUTH_JWT_SECRET=%s\n" "$(openssl rand -hex 32)" > /etc/tiyi/tiyi.env'
sudo systemctl restart tiyi
```

默认 KEK 持久存储于状态数据库目录的 `kek.bin`；它用于解密证书和其他秘密，必须与状态一起备份。
HTTPS 控制台使用 `auth.refresh_cookie_secure: true`；仅通过 HTTP 演示时保持 false。
首次管理员可用 `auth.bootstrap_admin_*` 或对应环境变量预置；已有用户时这些字段不会重置密码。

<a id="apply"></a>
## 4. 从文件创建受保护站点

先使源站 `http://127.0.0.1:9000` 可访问（可复用[演示源站](getting-started.md)）。
复制以下整段；正式使用只需先改域名、上游 URL 和两个资源名称。省略 `policyRef` 时，开启 WAF 的站点使用内置 Light 策略。

```sh
cat > first-site.yaml <<'YAML'
apiVersion: tiyi.io/v1
kind: Upstream
metadata:
  name: example-origin
spec:
  backends:
    - url: http://127.0.0.1:9000
      weight: 100
  loadBalance: round_robin
  status: active
---
apiVersion: tiyi.io/v1
kind: Site
metadata:
  name: example-site
spec:
  primaryHost: app.example.com
  upstreamRef: example-origin
  tls:
    mode: none
  waf:
    enabled: true
    mode: blocking
  status: active
YAML
sudo tiyi diff -f first-site.yaml
sudo tiyi apply -f first-site.yaml --dry-run
sudo tiyi apply -f first-site.yaml
curl -i -H 'Host: app.example.com' http://127.0.0.1/
```

正常响应应与直接访问源站一致。文件包含两个文档，`---` 分隔。
所有本机服务管理命令使用 `sudo`；自定义前台实例请追加其 `--admin-socket`。

配置[通配站点](operations.md#wildcard-hosts)时，在上面的 Site 文档中使用 `primaryHost: "*.example.com"`；YAML 中的通配值要加引号。`aliases` 也支持一级通配域名；根域名 `example.com` 和 OpenAPI/Schema 映射使用的具体 API 域名需分别添加。启用 HTTPS 前先准备覆盖全部域名的证书。

## 5. apply 会如何处理已有资源

- 按大小写不敏感的 `(kind, metadata.name)` 找资源；改名会新建，不会重命名旧资源。
- `spec` 完整替换 apply 管理的字段，省略的可选字段可能恢复默认或清空。先看 diff；它不是 merge patch。
- 从文件中删掉一个资源不会删除在线资源。未知键会被拒绝。
- `upstreamRef`、`policyRef`、`certRef` 按名称解析，CRS 可按 ID/版本解析；同文件支持向前引用。
- `metadata.id` 可在创建时指定 UUID；租户来自登录身份，不能传 `metadata.tenant`。
- 一份 manifest 的数据库写入使用同一事务；提交后的代理发布若失败，资源已保存，运行流量保留最后有效配置。修复后重试并检查节点结果。

## 6. 四种 kind 与边界

| Kind | 核心字段 | 另需注意 |
|---|---|---|
| `Upstream` | `backends[].url/weight/healthCheckPath`、`loadBalance`、`healthCheck`、`status` | 负载算法为 `round_robin`；健康检查 `path` 为空时关闭主动探测 |
| `Site` | `primaryHost`、`aliases`、`upstreamRef` 或 `upstreamsInline`、`tls`、`waf`、`botProtection`、`status` | 两种上游选择互斥；Bot 开启要求仅 HTTPS；TLS 证书先单独创建 |
| `Policy` | `engineState`、`blockingMode`、`crsRulesetRef`、`status` | active 策略须引用现有 CRS；高级策略层、规则、绑定另用 UI/CLI/API |
| `IpList` | `description`、`entries[].cidr/description/expireAt` | 只建地址表，需再绑定才产生防护；`expireAt` 用 RFC 3339；不支持 `geo:*` |

完整字段和注释见[四类资源模板](templates/apply.yaml)。证书、路径路由、限速、API 规范、用户、告警、SIEM
不属于 apply kind；使用[任务指南](operations.md)、[CLI](cli.md)或[API](api.md)管理。
不要把 apply 字段名照搬到 API JSON：例如 apply 的 `backends` 对应 API 上游对象的 `endpoints`。

当前 `trustedIpListRefs` 的非空名称引用会被 apply 拒绝；模板保持空列表，建表后在站点 Bot 设置绑定。
