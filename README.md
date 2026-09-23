# Tiyi

> **v3.8.0 · 2026-09-22:** review the [release notes](docs/en/release-3.8.0.md) before upgrading. This release requires fresh state.

[English](README.md) · [中文](README.zh-CN.md) · [Website](https://www.tiyisec.com/)

**One executable to protect your websites and APIs.** Tiyi includes a reverse proxy, automatic TLS, web application firewall, API request validation, and a management console.
Runs on Linux amd64/arm64. The built-in local node is free and fully featured, with no Docker, external database, or source build required.

## Tiyi in 76 seconds

Install one binary, route an upstream, publish a site, block SQL injection,
and inspect the evidence — one complete operator path.

https://github.com/user-attachments/assets/9d5b2eed-3956-41e6-bc39-b8c7048b7f44

<p align="center">
  <sub>Native GitHub player · 1 min 16 sec · no audio</sub>
  <br />
  <a href="https://www.tiyisec.com/">Guided web demo</a>
  ·
  <a href="https://www.tiyisec.com/assets/video/tiyi-demo.mp4">1080p MP4</a>
  ·
  <a href="https://www.tiyisec.com/assets/video/tiyi-demo-1440p.mp4">1440p MP4</a>
</p>

The original recording shows the getting-started workflow; see the [quickstart](docs/en/getting-started.md) for the current UI.

## Get running

On a fresh host, install and start the signed release. Save the one-time administrator password printed in the terminal.

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

Open `http://SERVER_IP:8080` in your browser, replacing `SERVER_IP` with the Tiyi host's IP address. Tiyi listens on `0.0.0.0:8080` by default.
Follow the [quickstart](docs/en/getting-started.md) from login to a normal 200 response and a SQL-injection 403.

For mainland China, download the script from `https://gitee.com/tiyisec/tiyi/raw/main/install.sh` and set `TIYI_MIRROR=gitee` when running it.
**Existing installation?** v3.8.0 cannot reuse v3.7.2-or-earlier state. Read [upgrade and migration](docs/en/upgrade-migration.md) before installing.

The default is a systemd service enabled at boot, with website ports **80/443** and management on **8080**. HTTPS needs a site and certificate.
Choose [manual steps](docs/en/getting-started.md#manual), [custom ports](docs/en/getting-started.md#custom-ports), or [offline installation](docs/en/installation.md#offline);
then follow [practice and advanced use](docs/en/practice.md). The default downloads the latest stable release; check `tiyi --version`.

## Continue with your task

| Goal | Guide |
|---|---|
| Copy startup config, change ports, manage resource files | [YAML templates and commands](docs/en/configuration.md) |
| Import or move sites | [Copyable JSON and export workflow](docs/en/site-import.md) |
| Import OpenAPI, learn traffic, validate requests | [Complete API protection example](docs/en/api-protection.md) |
| Configure HTTPS, routes, WAF, alerts | [Operations](docs/en/operations.md) |
| Automate and integrate | [CLI](docs/en/cli.md) · [API](docs/en/api.md) · [Complete fields](docs/reference/README.md) |
| Deploy, manage users/nodes, back up and restore | [Deployment](docs/en/deployment.md) · [Migration](docs/en/upgrade-migration.md) |
| Resolve errors | [Troubleshooting](docs/en/troubleshooting.md) |

[English documentation hub](docs/en/README.md) · [中文文档](docs/zh/README.md) · [v3.8.0 notes](docs/en/release-3.8.0.md).

## Capabilities

Protect against common SQL injection/XSS; tune CRS, precise exceptions, and virtual patches per site; manage request/upload limits,
rate controls, IP/country access, and Bot verification. Discover APIs, import OpenAPI/Swagger, learn JSON structure, and validate individual endpoints.
Operate multiple origins, path routes, certificates, and renewal. Investigate traffic/evidence and integrate alerts, SIEM, and Prometheus.
Manage access with RBAC, LDAP/AD, RADIUS, OIDC, SAML, and TOTP. Optional AI Copilot is off by default and remains advisory.

Remote Agents require signed licensed capacity; local features remain complete. There is one writable Controller; remote Agents keep serving their last accepted configuration during its outage.
This repository distributes the installer, public key, user docs, and skill. Signed binaries are attached to [GitHub Releases](https://github.com/zzmzm/tiyi/releases)
and [Gitee Releases](https://gitee.com/tiyisec/tiyi/releases). Tiyi uses Caddy, Coraza, OWASP CRS 4, and SQLite.

## AI Agent Skill

The public [tiyi-operator skill](skills/tiyi-operator/SKILL.md) helps an AI install, publish sites, configure API protection, and troubleshoot through supported UI/CLI/API interfaces.
It serves installed-product users and needs no private source tree or release tools.

Codex personal installation:

```sh
TIYI_SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/tiyi-operator"
mkdir -p "$TIYI_SKILL_DIR/agents"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/SKILL.md \
  -o "$TIYI_SKILL_DIR/SKILL.md"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/agents/openai.yaml \
  -o "$TIYI_SKILL_DIR/agents/openai.yaml"
```

For Claude Code use `$HOME/.claude/skills/tiyi-operator/` and download the same `SKILL.md`.
For mainland China, substitute `https://gitee.com/tiyisec/tiyi/raw/main` as the URL prefix.
Example request: “Use tiyi-operator to connect app.example.com to my existing origin; show the change preview first.”

## Support and license

[EULA](EULA.md) · [Third-party notices](NOTICE) · [Security reporting](SECURITY.md).
For other problems, open an issue with the version, symptoms, and sanitized logs.
