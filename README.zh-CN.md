# 太一 Tiyi

> **v3.8.0 · 2026-09-22：**本版本要求全新状态，升级前请先阅读[发行说明](docs/zh/release-3.8.0.md)。

[English](README.md) · [中文](README.zh-CN.md) · [官网](https://www.tiyisec.com/zh/)

**一个可执行文件，保护你的网站与 API。** 太一提供反向代理、自动 TLS、Web 应用防火墙、API 请求校验和管理控制台。
支持 Linux amd64/arm64；本机单节点免费且功能完整，无需 Docker、外部数据库或源码构建。

## 76 秒看懂太一

安装一个二进制、配置上游、发布站点、拦截 SQL 注入并检查证据——一条完整的
运维路径。

https://github.com/user-attachments/assets/9d5b2eed-3956-41e6-bc39-b8c7048b7f44

<p align="center">
  <sub>GitHub 原生播放器 · 1 分 16 秒 · 无音频</sub>
  <br />
  <a href="https://www.tiyisec.com/zh/">网页引导演示</a>
  ·
  <a href="https://www.tiyisec.com/assets/video/tiyi-demo.mp4">1080p MP4</a>
  ·
  <a href="https://www.tiyisec.com/assets/video/tiyi-demo-1440p.mp4">1440p MP4</a>
</p>

原版录屏展示完整上手流程；当前界面操作请参阅[快速开始](docs/zh/getting-started.md)。

## 先跑起来

新主机：安装并启动签名发行版，记下终端打印的一次性管理员密码。

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

浏览器打开 `http://服务器IP:8080`，将“服务器IP”换成太一主机的实际 IP。太一默认监听 `0.0.0.0:8080`。
继续[快速开始](docs/zh/getting-started.md)：从登录到正常访问 200，再验证 SQL 注入 403。

中国大陆下载：把安装脚本地址换成 `https://gitee.com/tiyisec/tiyi/raw/main/install.sh`，执行时加 `TIYI_MIRROR=gitee`。
**已有安装不要直接执行新装命令**：v3.8.0 不能复用 v3.7.2 或更早的状态，先看[升级与迁移](docs/zh/upgrade-migration.md)。

默认使用开机自启的 systemd 服务，网站端口 **80/443**、管理端口 **8080**。HTTPS 需要后续配置站点和证书。
选择[手动分步](docs/zh/getting-started.md#manual)、[DIY 端口](docs/zh/getting-started.md#custom-ports)或[离线安装](docs/zh/installation.md#offline)；
安装后按[实战与进阶](docs/zh/practice.md)逐步练习。默认下载当前最新稳定版，先用 `tiyi --version` 核对。

## 按你的任务继续

| 目标 | 文档 |
|---|---|
| 复制启动配置、改端口、写声明式资源 | [完整 YAML 模板与命令](docs/zh/configuration.md) |
| 导入或迁移站点 | [可复制 JSON 与导出流程](docs/zh/site-import.md) |
| OpenAPI 导入、流量学习、接口校验 | [完整 API 防护示例](docs/zh/api-protection.md) |
| HTTPS、路径路由、WAF、告警 | [日常运维](docs/zh/operations.md) |
| 脚本自动化与系统集成 | [CLI](docs/zh/cli.md) · [API](docs/zh/api.md) · [完整字段](docs/reference/README.md) |
| 部署、账号、节点、备份、恢复 | [生产部署](docs/zh/deployment.md) · [升级与迁移](docs/zh/upgrade-migration.md) |
| 解决错误 | [排障](docs/zh/troubleshooting.md) |

[中文文档中心](docs/zh/README.md) · [English docs](docs/en/README.md) · [v3.8.0 版本说明](docs/zh/release-3.8.0.md)。

## 能做什么

保护常见 SQL 注入/XSS；按站点配置 CRS、规则例外与虚拟补丁；管理请求/上传限制、限速、IP/国家访问和 Bot 验证；
发现并管理 API、导入 OpenAPI/Swagger、学习 JSON 结构、逐接口校验；管理多源站、路径路由、证书与续期；
查看流量/请求证据，通过告警、SIEM、Prometheus 运维；使用 RBAC、LDAP/AD、RADIUS、OIDC、SAML 和 TOTP 管理访问。
可选 AI Copilot 默认关闭，始终只提供建议。

远端 Agent 需要签名许可配额；本机功能不受影响。只有一个可写 Controller；远端 Agent 在其离线时继续使用最后接受的配置。
本仓库分发安装器、公钥、用户文档和 skill；签名二进制位于 [GitHub Release](https://github.com/zzmzm/tiyi/releases) 和
[Gitee Release](https://gitee.com/tiyisec/tiyi/releases)。底层使用 Caddy、Coraza、OWASP CRS 4 和 SQLite。

## AI Agent Skill

公开的 [tiyi-operator](skills/tiyi-operator/SKILL.md) 让 AI 通过官方 UI/CLI/API 帮你安装、建站、配置 API 防护和排障。
它只面向已安装产品的用户，不需要私有源码或发布工具。

Codex 个人安装：

```sh
TIYI_SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/tiyi-operator"
mkdir -p "$TIYI_SKILL_DIR/agents"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/SKILL.md \
  -o "$TIYI_SKILL_DIR/SKILL.md"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/agents/openai.yaml \
  -o "$TIYI_SKILL_DIR/agents/openai.yaml"
```

Claude Code 使用 `$HOME/.claude/skills/tiyi-operator/`，下载相同 `SKILL.md`。
中国大陆可把下载 URL 前缀换为 `https://gitee.com/tiyisec/tiyi/raw/main`。
例如对 AI 说：“用 tiyi-operator 帮我把 app.example.com 接到现有源站，先给出变更预览。”

## 支持与许可

[EULA](EULA.md) · [第三方声明](NOTICE) · [安全问题报告](SECURITY.md)。普通问题请在分发仓库提交 issue，附版本、现象和脱敏日志。
