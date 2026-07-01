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
| `TIYI_VERSION` | latest stable | Pin a release tag, for example `v3.0.3`. |
| `TIYI_PREFIX` | `/usr/local/bin` | Install directory for the `tiyi` binary. |

The one-line command above installs the binary and starts the recommended
systemd service. For a manual foreground run instead, pick the option that
matches your privileges:

```sh
# Root / sudo — uses the default state dir (/var/lib/tiyi) and ports 80/443
sudo tiyi standalone

# Normal user (no sudo) — writable paths and high ports
mkdir -p /tmp/waf
tiyi standalone \
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

### Advanced: choose your own admin password

Set `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` before the first boot to skip the generated
password (ideal for automation, images, and CI) — combine it with either run
option above. Tiyi uses it verbatim and prints no banner:

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

The username defaults to `admin`. Auto-generation only fires when no users
exist, so restarts are no-ops.

### Runtime config via environment

Prefer `server.yaml` for persistent service configuration. Use environment
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
  scoring, exclusion packages, and custom SecLang rules, all without forking the
  ruleset.
- **Reverse proxy + automatic TLS** — Caddy under the hood, ACME HTTP-01 and
  DNS-01 (Cloudflare), wildcard certs, and uploaded enterprise certs.
- **Path-based routing** — fan one host out to many upstream pools by path
  prefix, each with its own health probe.
- **Built-in observability** — a telemetry pipeline with Top-K, a per-site URL
  tree, and a Prometheus exporter — no external time-series database.
- **Security incidents, not a firehose** — related events fold into actionable
  incidents with a tracked lifecycle and optional, default-off automated
  response.
- **Tamper-evident audit chain**, **SIEM egress** (RFC 5424 / CEF / LEEF),
  **alert lifecycle** with Webhook / Slack / PagerDuty / Feishu / WeCom,
  **RBAC + OIDC**, and an optional, default-off **AI Copilot** that stays
  advisory and never sits in the request path.
- **One CLI, one API** — the same ConnectRPC schema drives the web UI, the
  `tiyi` CLI, and the agent stream; `tiyi apply -f site.yaml` is fully
  declarative.

Grow past one box whenever you want: a signed license lifts the remote-agent
budget so the multi-node topologies already built into the binary
(warm-secondary HA, N edge agents) light up. The single-node experience never
changes.

## What's in this repo

This is the **distribution channel** for Tiyi — the installer, the public
release-signing key, and the docs. Compiled, signed binaries are attached to
each [GitHub Release](../../releases) (they are not committed to the repo).

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

A running Tiyi can update itself from this repo's releases:

```sh
tiyi update --check          # is a newer signed release available?
tiyi update --yes            # download, verify, and install it
tiyi update --yes --mirror gitee
```

`update` verifies the full Ed25519 signature chain against the embedded release
key before swapping the on-disk binary; restart the service afterward. Track
pre-release builds with `--channel prerelease`.

Update environment variables:

| Variable | Default | Meaning |
|---|---|---|
| `TIYI_UPDATE_MIRROR` | `auto` | Update-check/download source: `auto`, `github`, or `gitee`. |
| `TIYI_UPDATE_REPO` | `zzmzm/tiyi` | GitHub `owner/name` for `github` and `auto`. |
| `TIYI_UPDATE_CHANNEL` | `stable` | `stable` or `prerelease`. |

## Documentation

- English: [`docs/en/getting-started.md`](docs/en/getting-started.md)
- 中文: [`docs/zh/getting-started.md`](docs/zh/getting-started.md)
- Website & full docs: <https://www.tiyisec.com>

## Codex skill

Operators using Codex can install the Tiyi operator skill for guided install,
standalone, Web UI, CLI, release, license, and troubleshooting workflows:

```sh
SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/tiyi-operator"
mkdir -p "$SKILL_DIR/agents"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/SKILL.md \
  -o "$SKILL_DIR/SKILL.md"
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/skills/tiyi-operator/agents/openai.yaml \
  -o "$SKILL_DIR/agents/openai.yaml"
```

The published source lives in [`skills/tiyi-operator/`](skills/tiyi-operator/).

## Legal

- License: [EULA.md](EULA.md).
- Third-party attributions: [NOTICE](NOTICE).
- Security policy & vulnerability reporting: [SECURITY.md](SECURITY.md).

"Tiyi" and the Tiyi logo are trademarks of the Tiyi Authors.
