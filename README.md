# Tiyi

**A complete web application firewall in a single binary.** Caddy + Coraza +
OWASP CRS 4 + SQLite + an admin UI, compiled into one self-hostable Go
executable. No Docker, no external database, no Redis — five minutes from
download to blocking real attacks.

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

## Install

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

<sub>GitHub mirror (same script): `curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash && sudo tiyi install --now`</sub>
<br>
<sub>China mirror: `curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh | TIYI_MIRROR=gitee bash && sudo tiyi install --now`</sub>

The installer detects your platform (Linux amd64/arm64), downloads the latest
signed release, verifies its SHA-256 (required) and — when local OpenSSL
supports `pkeyutl -rawin` — its Ed25519 release signature, then installs `tiyi` to
`/usr/local/bin`. By default it tries GitHub first and falls back to the Gitee
release mirror; override with `TIYI_MIRROR=github|gitee`, `TIYI_VERSION`,
`TIYI_PREFIX`, `TIYI_REPO`, or `TIYI_GITEE_REPO`. After installing the binary,
the script runs a colored environment check for sudo PATH and listeners on
ports 80/443/8080. If it warns about sudo `secure_path`, run the printed
full-path command or add `/usr/local/bin` with `visudo`. If it warns about a
port conflict, stop the owning service or move Tiyi with `server.addr`,
`proxy.http_addr`, or `proxy.https_addr`.

Installer environment variables:

| Variable | Default | Meaning |
|---|---|---|
| `TIYI_MIRROR` | `auto` | Download source: `auto` (GitHub primary, Gitee fallback), `github`, or `gitee`. |
| `TIYI_REPO` | `zzmzm/tiyi` | GitHub `owner/name` used by the installer. |
| `TIYI_GITEE_REPO` | `tiyisec/tiyi` | Gitee `owner/name` used by the installer. |
| `TIYI_VERSION` | latest stable | Pin a release tag, for example `v3.7.2`. |
| `TIYI_PREFIX` | `/usr/local/bin` | Install directory for the `tiyi` binary. |

The one-line command above installs the binary and starts the recommended
systemd service. For a manual foreground run instead, pick the option that
matches your privileges:

```sh
# Root / sudo — uses the default state dir (/var/lib/tiyi) and ports 80/443
sudo tiyi run

# Normal user (no sudo) — writable paths and high ports
mkdir -p /tmp/waf
tiyi run \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --admin-socket /tmp/waf/admin.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443
```

Tiyi prints a one-time `admin` password on first boot. Open the dashboard, sign
in, and add your first site. Full walkthrough:
[`docs/en/getting-started.md`](docs/en/getting-started.md) ·
[中文](docs/zh/getting-started.md).

> **Existing installation:** use the [upgrade and migration guide](docs/en/upgrade-migration.md)
> instead of the new-host installer. v3.7.0 cannot open state created by
> v3.6.0 or earlier releases and uses the documented backup and purge flow.

### Advanced: choose your own admin password

Set `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` before the first boot to skip the generated
password (ideal for automation, images, and CI) — combine it with either run
option above. Tiyi uses it verbatim and prints no banner:

```sh
mkdir -p /tmp/waf
TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD='admin123@xxxxxxm' \
  tiyi run \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --admin-socket /tmp/waf/admin.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443
```

The username defaults to `admin`. Auto-generation only fires when no users
exist, so restarts are no-ops.

### Runtime config via environment

Prefer `tiyi.yaml` for persistent service configuration. Use environment
variables only when your service manager, container runtime, or secret manager
injects config at runtime. Env names mirror config keys: prefix `TIYI_`,
uppercase the key, and replace dots with underscores. For example,
`auth.jwt_secret` becomes `TIYI_AUTH_JWT_SECRET`.

Common config env overrides:

| Variable | Config key | When to use |
|---|---|---|
| `TIYI_SERVER_ADDR` | `server.addr` | Bind the API/dashboard to a different address. |
| `TIYI_STORE_STATE_DB` | `store.state_db` | Move the SQLite state database. |
| `TIYI_LOG_LEVEL` | `log.level` | Temporarily raise or lower process logging. |
| `TIYI_PROXY_HTTP_ADDR` | `proxy.http_addr` | Change the HTTP data-plane listen address. |
| `TIYI_PROXY_HTTPS_ADDR` | `proxy.https_addr` | Change the HTTPS data-plane listen address. |
| `TIYI_PROXY_CADDY_ADMIN_SOCKET` | `proxy.caddy_admin_socket` | Move the embedded Caddy admin socket. |
| `TIYI_CRYPTO_KEK_FILE` | `crypto.kek_file` | Pin the at-rest encryption KEK path for production. |
| `TIYI_AUTH_JWT_SECRET` | `auth.jwt_secret` | Set a stable JWT signing secret for production. |
| `TIYI_AUTH_BOOTSTRAP_ADMIN_USERNAME` | `auth.bootstrap_admin_username` | Choose the first admin username. |
| `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` | `auth.bootstrap_admin_password` | Choose the first admin password for automation. |
| `TIYI_LICENSE_KEY_PATH` | `license.key_path` | Load a signed license file on boot. |
| `TIYI_UPDATE_REPO` | `update.repo` | Override the GitHub release repo used by update checks. |
| `TIYI_UPDATE_CHANNEL` | `update.channel` | Use `stable` or `prerelease` for `tiyi update`. |
| `TIYI_UPDATE_MIRROR` | `update.mirror` | Use `auto`, `github`, or `gitee` for update checks/downloads. |

Less common config keys follow the same rule. Prefer YAML for LDAP/RADIUS,
token TTLs, cookie settings, and provider-specific auth settings unless your
deployment platform requires env injection.

## Free and full-featured on a single node

One Tiyi node gives you the **whole** WAF — not a stripped-down free tier.
Everything below is included and runs locally with no license:

- **OWASP CRS 4 out of the box** — per-site overrides, paranoia levels, anomaly
  scoring, exclusion packages, custom SecLang rules, a complete embedded-file
  integrity manifest, and causal CPU-pressure degradation, all without forking
  the ruleset.
- **Bot protection** — HTTPS-only sites can require silent browser proof-of-work
  or private WebAuthn confirmation, with bounded clearance, path and trusted-IP
  exemptions, and exact **Logs → Bot Analytics** admission outcomes. The gate
  verifies visitors; it does not identify bots or invent a pass rate.
- **Adaptive traffic controls** — rolling-window rate limits support temporary
  site/global bans and a separate challenge response.
- **IP Lists v2 + Country Access** — manual and subscribed provider/file feeds
  publish atomic snapshots with last-good protection, while country policy is
  backed by the explicitly active Country database.
- **Reverse proxy + automatic TLS** — Caddy under the hood, ACME HTTP-01 and
  DNS-01 (Cloudflare), wildcard certs, and uploaded enterprise certs.
- **Path-based routing** — fan one host out to many upstream pools by path
  prefix, each with its own health probe.
- **Built-in observability** — exact counters, normalized URL/UA Top, a per-site
  API Inventory, bounded client-fair SecurityFact samples, optional bounded
  request-header/body evidence, and a Prometheus exporter — no external
  time-series database.
- **Direct investigation, not a firehose** — Security Events pivots immutable
  facts by attacker/type/target, Attack Logs preserves request-level rule
  evidence, and optional default-off AI remains advisory.
- **Tamper-evident audit chain**, producer-direct **SIEM egress** (native
  Caddy/Coraza or RFC 5424 / CEF / LEEF / OCSF over UDP/TCP/TLS),
  **alert lifecycle** with Webhook / Slack / PagerDuty / Feishu / WeCom,
  **RBAC + OIDC**, and an optional, default-off **AI Copilot** that stays
  advisory and never sits in the request path.
- **One CLI, one API** — the same ConnectRPC schema drives the web UI, the
  `tiyi` CLI, and the agent stream; `tiyi apply -f site.yaml` is fully
  declarative.

Grow past one box whenever you want: a signed license lifts the remote-Agent
budget. One writable Controller always includes its built-in local node; add
remote data planes without changing Controller modes or roles. During a
Controller outage, remote Agents continue serving their last accepted signed
bundle.

Use **Nodes → Install** to download the binary, issue a one-use token, and
choose the systemd or foreground instructions. The recommended service path is:

```sh
sudo curl -fsSL -o /usr/local/bin/tiyi 'https://tiyi.example.com/download/tiyi'
sudo chmod 0755 /usr/local/bin/tiyi
sudo mkdir -p /etc/tiyi
printf 'TIYI_CONTROLLER_URL=https://tiyi.example.com\nTIYI_AGENT_ENROLLMENT_TOKEN=<one-use-token>\n' | sudo tee /etc/tiyi/tiyi-agent.env >/dev/null
sudo chmod 0600 /etc/tiyi/tiyi-agent.env
sudo tiyi install --mode agent --unit-name tiyi-agent --now
```

The page also exposes the raw token, foreground command, and complete
download-and-start script.

## What's in this repo

This is the **distribution channel** for Tiyi — the installer, the public
release-signing key, and the docs. Compiled, signed binaries are attached to
each [GitHub Release](https://github.com/zzmzm/tiyi/releases) (they are not committed to the repo).

Current release notes: [v3.7.2](docs/en/release-3.7.2.md) ·
[中文](docs/zh/release-3.7.2.md).

## Verify a download manually

Every release attaches `SHA256SUMS`, `SHA256SUMS.sig`, and
`release-manifest.json`. The signing key is published here as
[`release-key.pub`](release-key.pub) and is embedded in the `tiyi` binary.

```sh
# checksums (required):
sha256sum --check --ignore-missing SHA256SUMS

# Ed25519 signature of the checksums (OpenSSL with pkeyutl -rawin):
openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
    -in SHA256SUMS -sigfile <(base64 -d SHA256SUMS.sig)
```

(See [`docs/en/getting-started.md`](docs/en/getting-started.md) for building
`release-key.pem` from `release-key.pub`.)

## Updating

A running Tiyi binary with the `update` command can install a signed release:

```sh
tiyi update --check          # is a newer signed release available?
sudo tiyi update --yes       # download, verify, and install it
sudo tiyi update --yes --mirror gitee
```

`update` validates release metadata and the full Ed25519 signature chain
against the embedded release key, without a hard-coded version floor. It does
not decide state/protocol compatibility and does not restart the service. Read
the target release notes first. Track pre-release builds with
`--channel prerelease`; omit `sudo` only for a user-writable prefix.

Update environment variables:

| Variable | Default | Meaning |
|---|---|---|
| `TIYI_UPDATE_MIRROR` | `auto` | Update-check/download source: `auto`, `github`, or `gitee`. |
| `TIYI_UPDATE_REPO` | `zzmzm/tiyi` | GitHub `owner/name` for `github` and `auto`. |
| `TIYI_UPDATE_CHANNEL` | `stable` | `stable` or `prerelease`. |

## Documentation

- English hub: [`docs/en/README.md`](docs/en/README.md)
- 中文文档中心: [`docs/zh/README.md`](docs/zh/README.md)
- First run: [getting started](docs/en/getting-started.md) · [快速开始](docs/zh/getting-started.md)
- Daily work: [operations](docs/en/operations.md) · [日常运维](docs/zh/operations.md)
- Problems: [troubleshooting](docs/en/troubleshooting.md) · [排障](docs/zh/troubleshooting.md)
- Upgrade and migration: [English](docs/en/upgrade-migration.md) · [中文](docs/zh/upgrade-migration.md)
- Website & full docs: <https://www.tiyisec.com>

## AI agent skill (Codex and Claude Code)

Install the `tiyi-operator` skill to let Codex, Claude Code, and compatible
agents safely inspect, configure, maintain, and troubleshoot an installed Tiyi
WAF. The skill uses signed binaries and supported operator interfaces only; it
does not contain source-build or release-publishing workflows.

Codex personal install:

```sh
SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/tiyi-operator"
mkdir -p "$SKILL_DIR/agents"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/SKILL.md \
  -o "$SKILL_DIR/SKILL.md"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/agents/openai.yaml \
  -o "$SKILL_DIR/agents/openai.yaml"
```

Claude Code personal install:

```sh
SKILL_DIR="$HOME/.claude/skills/tiyi-operator"
mkdir -p "$SKILL_DIR"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/SKILL.md \
  -o "$SKILL_DIR/SKILL.md"
```

For a project-scoped Claude Code install, use
`.claude/skills/tiyi-operator/` instead. In mainland China, replace the URL
prefix with `https://gitee.com/tiyisec/tiyi/raw/main`.

The published source lives in [`skills/tiyi-operator/`](skills/tiyi-operator/).

## Legal

- License: [EULA.md](EULA.md).
- Third-party attributions: [NOTICE](NOTICE).
- Security policy & vulnerability reporting: [SECURITY.md](SECURITY.md).

"Tiyi" and the Tiyi logo are trademarks of the Tiyi Authors.
