# Tiyi（体翼）

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
curl -fsSL https://www.tiyisec.com/install.sh | bash
```

<sub>GitHub 镜像（同一脚本）：`curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash`</sub>

安装脚本会识别平台（Linux amd64/arm64）、下载最新的已签名发行版、校验其
SHA-256（必需）并在有 OpenSSL 3.x 时校验其 Ed25519 发布签名，然后把 `tiyi`
安装到 `/usr/local/bin`。可用 `TIYI_VERSION`、`TIYI_PREFIX`、`TIYI_REPO` 覆盖。

然后拉起单机安装 —— 在一个进程里同时运行 server、agent 与 dashboard：

```sh
tiyi standalone
```

首次启动时会打印一次性的管理员密码。打开仪表盘登录，并添加第一个站点。完整
教程：[`docs/zh/getting-started.md`](docs/zh/getting-started.md) ·
[English](docs/en/getting-started.md)。

### 进阶：自定义管理员密码

跳过自动生成的密码，非交互式拉起 Tiyi —— 用一条命令设定管理员密码与监听/套接字
路径（非常适合自动化、镜像与 CI）：

```sh
mkdir -p /tmp/waf
TIYI_BOOTSTRAP_ADMIN_PASSWORD='admin123@xxxxxxm' \
  tiyi standalone \
  --addr 0.0.0.0:8080 \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443 \
  --admin-socket /tmp/waf/admin.sock
```

Tiyi 会原样采用所给凭据且不打印任何 banner。用户名默认 `admin`。仅当不存在任何
用户时才会自动生成密码，因此重启都是空操作。

## 单节点免费且功能完整

一个 Tiyi 节点给你**完整**的 WAF —— 而不是阉割版的免费档。下面的一切都已包含，
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

这是 Tiyi 的**分发渠道** —— 安装脚本、公开的发布签名公钥与文档。编译并签名的
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

运行中的 Tiyi 可以从本仓库的 releases 自更新：

```sh
tiyi self-update --check     # 是否有更新的已签名发行版？
tiyi self-update --yes       # 下载、校验并安装
```

`self-update` 会在替换磁盘上的二进制之前，针对内嵌的发布公钥校验完整的 Ed25519
签名链；更新后请重启服务。使用 `--channel prerelease` 可跟踪预发布版本。

## 文档

- 中文：[`docs/zh/getting-started.md`](docs/zh/getting-started.md)
- English：[`docs/en/getting-started.md`](docs/en/getting-started.md)
- 官网与完整文档：<https://www.tiyisec.com>

## Codex skill

使用 Codex 的运维人员可以安装 Tiyi operator skill，用于安装、standalone、Web UI、
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

“Tiyi”与 Tiyi logo 是 Tiyi Authors 的商标。
