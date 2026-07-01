# 太一

**单可执行文件即一套完整的 Web 应用防火墙。** Caddy + Coraza + OWASP CRS 4 +
SQLite + 管理 UI，编译进一个可自托管的 Go 可执行文件。无需 Docker、无需外部
数据库、无需 Redis —— 从下载到拦截真实攻击只要五分钟。

<p>
  <a href="README.md"><img src="https://img.shields.io/badge/Lang-English-blue?style=for-the-badge" alt="English"></a>
  <a href="README.zh-CN.md"><img src="https://img.shields.io/badge/Lang-中文-red?style=for-the-badge" alt="中文"></a>
</p>

<p>
  <img src="https://img.shields.io/badge/install-one%20line-success" alt="One-line install">
  <img src="https://img.shields.io/badge/platform-linux%20amd64%20%7C%20arm64-informational" alt="Platform">
  <img src="https://img.shields.io/badge/stack-Caddy%20·%20Coraza%20·%20CRS%204-success" alt="Stack">
  <img src="https://img.shields.io/badge/releases-signed%20(Ed25519)-blue" alt="Signed releases">
</p>

## 安装

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

<sub>GitHub 镜像（同一脚本）：`curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash && sudo tiyi install --now`</sub>
<br>
<sub>中国大陆镜像：`curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh | TIYI_MIRROR=gitee bash && sudo tiyi install --now`</sub>

安装脚本会识别平台（Linux amd64/arm64）、下载最新的已签名发行版、校验其
SHA-256（必需）并在本机 OpenSSL 支持 `pkeyutl -rawin` 时校验其 Ed25519 发布签名，然后把 `tiyi`
安装到 `/usr/local/bin`。默认先尝试 GitHub，失败或过慢时回退到 Gitee
Release 镜像；可用 `TIYI_MIRROR=github|gitee`、`TIYI_VERSION`、
`TIYI_PREFIX`、`TIYI_REPO` 或 `TIYI_GITEE_REPO` 覆盖。安装二进制后,脚本会用
彩色提示检查 sudo PATH 以及 80/443/8080 端口监听者。如果提示 sudo
`secure_path`,使用输出里的完整路径命令,或用 `visudo` 加入 `/usr/local/bin`。
如果提示端口冲突,停止占用端口的服务,或通过 `server.addr`、`proxy.http_addr`、
`proxy.https_addr` 调整太一端口。

安装器环境变量：

| 变量 | 默认值 | 含义 |
|---|---|---|
| `TIYI_MIRROR` | `auto` | 下载来源：`auto`（GitHub 优先，Gitee 回退）、`github` 或 `gitee`。 |
| `TIYI_REPO` | `zzmzm/tiyi` | 安装器使用的 GitHub `owner/name`。 |
| `TIYI_GITEE_REPO` | `tiyisec/tiyi` | 安装器使用的 Gitee `owner/name`。 |
| `TIYI_VERSION` | 最新稳定版 | 固定发行标签，例如 `v3.0.3`。 |
| `TIYI_PREFIX` | `/usr/local/bin` | `tiyi` 二进制安装目录。 |

上面的一行命令会安装二进制并启动推荐的 systemd 服务。若要改为前台手动运行，
按你的权限选择一种方式：

```sh
# root / sudo —— 使用默认状态目录（/var/lib/tiyi）与 80/443 端口
sudo tiyi standalone

# 普通用户（不用 sudo）—— 可写路径 + 高端口
mkdir -p /tmp/waf
tiyi standalone \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --admin-socket /tmp/waf/admin.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443
```

首次启动时会打印一次性的 `admin` 密码。打开仪表盘登录，并添加第一个站点。完整
教程：[`docs/zh/getting-started.md`](docs/zh/getting-started.md) ·
[English](docs/en/getting-started.md)。

### 进阶：自定义管理员密码

在首次启动前设置 `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD`，即可跳过自动生成的密码（非常
适合自动化、镜像与 CI）—— 可与上面任一种运行方式组合。太一会原样采用且不打印
任何 banner：

```sh
mkdir -p /tmp/waf
TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD='admin123@xxxxxxm' \
  tiyi standalone \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --admin-socket /tmp/waf/admin.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443
```

用户名默认 `admin`。仅当不存在任何用户时才会自动生成密码，因此重启都是空操作。

### 通过环境变量配置运行时

持久化服务配置优先写入 `server.yaml`。只有当 service manager、容器运行时或
密钥管理器需要在运行时注入配置时，才使用环境变量。环境变量名与配置键一一对应：
加 `TIYI_` 前缀，转为大写，并把点替换为下划线。例如 `auth.jwt_secret`
对应 `TIYI_AUTH_JWT_SECRET`。

常用配置覆盖：

| 变量 | 配置键 | 适用场景 |
|---|---|---|
| `TIYI_SERVER_ADDR` | `server.addr` | 把 API / 控制台绑定到不同地址。 |
| `TIYI_STORE_STATE_DB` | `store.state_db` | 移动 SQLite 状态数据库。 |
| `TIYI_LOG_LEVEL` | `log.level` | 临时调整进程日志级别。 |
| `TIYI_PROXY_HTTP_ADDR` | `proxy.http_addr` | 修改 HTTP 数据面监听地址。 |
| `TIYI_PROXY_HTTPS_ADDR` | `proxy.https_addr` | 修改 HTTPS 数据面监听地址。 |
| `TIYI_PROXY_CADDY_ADMIN_SOCKET` | `proxy.caddy_admin_socket` | 移动内嵌 Caddy admin socket。 |
| `TIYI_CRYPTO_KEK_FILE` | `crypto.kek_file` | 为生产环境固定静态加密 KEK 路径。 |
| `TIYI_AUTH_JWT_SECRET` | `auth.jwt_secret` | 为生产环境设置稳定 JWT 签名密钥。 |
| `TIYI_AUTH_BOOTSTRAP_ADMIN_USERNAME` | `auth.bootstrap_admin_username` | 指定首个管理员用户名。 |
| `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` | `auth.bootstrap_admin_password` | 为自动化指定首个管理员密码。 |
| `TIYI_LICENSE_KEY_PATH` | `license.key_path` | 启动时加载签名 license 文件。 |
| `TIYI_UPDATE_REPO` | `update.repo` | 覆盖更新检查使用的 GitHub release 仓库。 |
| `TIYI_UPDATE_CHANNEL` | `update.channel` | 为 `tiyi update` 使用 `stable` 或 `prerelease`。 |
| `TIYI_UPDATE_MIRROR` | `update.mirror` | 更新检查/下载使用 `auto`、`github` 或 `gitee`。 |

较少使用的配置键也遵循同一规则。LDAP/RADIUS、token 生命周期、cookie 设置与
认证后端细项优先写 YAML，除非部署平台必须通过环境变量注入。

## 单节点免费且功能完整

一个太一节点给你**完整**的 WAF —— 而不是阉割版的免费档。下面的一切都已包含，
无需任何授权即可本地运行：

- **开箱即用的 OWASP CRS 4** —— 按站点覆盖、偏执级别、异常评分、排除包，以及自
  定义 SecLang 规则，全部无需 fork 规则集。
- **反向代理 + 自动 TLS** —— 底层是 Caddy：ACME HTTP-01 与 DNS-01（Cloudflare）、
  通配符证书与上传的企业证书。
- **路径路由** —— 把一个主机按路径前缀分发到多个上游池，每个都有独立健康探测。
- **内置可观测性** —— 带 Top-K 的遥测流水线、按站点的 URL 树，以及 Prometheus
  导出器 —— 无需外部时序数据库。
- **是安全事件，而不是告警洪流** —— 相关事件聚合成可操作的 incident，带完整生命
  周期与可选的、默认关闭的自动响应。
- **防篡改审计链**、**SIEM 转发**（RFC 5424 / CEF / LEEF）、带 Webhook / Slack /
  PagerDuty / 飞书 / 企业微信的**告警生命周期**、**RBAC + OIDC**，以及一个可选的、
  默认关闭、始终只做顾问、绝不进入请求路径的 **AI Copilot**。
- **一套 CLI、一套 API** —— 同一份 ConnectRPC schema 同时驱动 Web UI、`tiyi`
  CLI 与 agent 流；`tiyi apply -f site.yaml` 完全声明式。

想扩展到多台机器随时可以：签名授权许可会提升远程 agent 配额，从而点亮二进制中
已内建的多节点拓扑（热备 HA、N 个边缘 agent）。单节点体验始终不变。

## 这个仓库里有什么

这是太一的**分发渠道** —— 安装脚本、公开的发布签名公钥与文档。编译并签名的
二进制作为资产附在每个 [GitHub Release](../../releases) 上（不提交进仓库）。

## 手动校验下载

每个发行版都附带 `SHA256SUMS`、`SHA256SUMS.sig` 与 `release-manifest.json`。
签名公钥在此发布为 [`release-key.pub`](release-key.pub)，并已内嵌进 `tiyi`
二进制。

```sh
# 校验和（必需）：
sha256sum --check --ignore-missing SHA256SUMS

# 校验和文件的 Ed25519 签名（OpenSSL 3.x）：
openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
    -in SHA256SUMS -sigfile <(base64 -d SHA256SUMS.sig)
```

（如何从 `release-key.pub` 构建 `release-key.pem`，见
[`docs/zh/getting-started.md`](docs/zh/getting-started.md)。）

## 更新

运行中的太一可以从本仓库的 releases 原地更新：

```sh
tiyi update --check          # 是否有更新的已签名发行版？
tiyi update --yes            # 下载、校验并安装
tiyi update --yes --mirror gitee
```

`update` 会在替换磁盘上的二进制之前，针对内嵌的发布公钥校验完整的 Ed25519
签名链；更新后请重启服务。使用 `--channel prerelease` 可跟踪预发布版本。

更新环境变量：

| 变量 | 默认值 | 含义 |
|---|---|---|
| `TIYI_UPDATE_MIRROR` | `auto` | 更新检查/下载来源：`auto`、`github` 或 `gitee`。 |
| `TIYI_UPDATE_REPO` | `zzmzm/tiyi` | `github` 与 `auto` 使用的 GitHub `owner/name`。 |
| `TIYI_UPDATE_CHANNEL` | `stable` | `stable` 或 `prerelease`。 |

## 文档

- 中文：[`docs/zh/getting-started.md`](docs/zh/getting-started.md)
- English：[`docs/en/getting-started.md`](docs/en/getting-started.md)
- 官网与完整文档：<https://www.tiyisec.com>

## Codex skill

使用 Codex 的运维人员可以安装太一 operator skill，用于安装、standalone、Web UI、
CLI、发布、授权与排障流程：

```sh
SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/tiyi-operator"
mkdir -p "$SKILL_DIR/agents"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/SKILL.md \
  -o "$SKILL_DIR/SKILL.md"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/agents/openai.yaml \
  -o "$SKILL_DIR/agents/openai.yaml"
```

发布源码位于 [`skills/tiyi-operator/`](skills/tiyi-operator/)。

## 法律

- 授权许可：[EULA.md](EULA.md)。
- 第三方归属声明：[NOTICE](NOTICE)。
- 安全策略与漏洞报告：[SECURITY.md](SECURITY.md)。

“太一”与太一 logo 是 Tiyi Authors 的商标。
