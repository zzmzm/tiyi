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
curl -fsSL https://www.tiyisec.com/install.sh | bash
```

<sub>GitHub mirror (same script): `curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash`</sub>

The installer detects your platform (Linux amd64/arm64), downloads the latest
signed release, verifies its SHA-256 (required) and — when OpenSSL 3.x is
available — its Ed25519 release signature, then installs `tiyi` to
`/usr/local/bin`. Override with `TIYI_VERSION`, `TIYI_PREFIX`, or `TIYI_REPO`.

Then bring up a single-host install — server, agent, and dashboard in one
process:

```sh
tiyi standalone
```

It prints a one-time admin password on first boot. Open the dashboard, sign in,
and add your first site. Full walkthrough:
[`docs/en/getting-started.md`](docs/en/getting-started.md) ·
[中文](docs/zh/getting-started.md).

### Advanced: pick your own admin password

Skip the generated password and bring Tiyi up non-interactively — set the admin
password and the listen/socket paths in one command (ideal for automation,
images, and CI):

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

Tiyi uses the supplied credentials verbatim and prints no banner. The username
defaults to `admin`. Auto-generation only fires when no users exist, so restarts
are no-ops.

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

# Ed25519 signature of the checksums (OpenSSL 3.x):
openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
    -in SHA256SUMS -sigfile <(base64 -d SHA256SUMS.sig)
```

(See [`docs/en/getting-started.md`](docs/en/getting-started.md) for building
`release-key.pem` from `release-key.pub`.)

## Updating

A running Tiyi can update itself from this repo's releases:

```sh
tiyi self-update --check     # is a newer signed release available?
tiyi self-update --yes       # download, verify, and install it
```

`self-update` verifies the full Ed25519 signature chain against the embedded
release key before swapping the on-disk binary; restart the service afterward.
Track pre-release builds with `--channel prerelease`.

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
