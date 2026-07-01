---
name: tiyi-operator
description: Operate Tiyi, the single-binary WAF platform. Use when Codex needs to install, build, run, configure, document, or troubleshoot Tiyi workflows including standalone/server/secondary/agent/dashboard modes, first-run admin bootstrap, local admin socket CLI, Web UI access, site/upstream/policy operations, signed releases, binary update, license import, and production operator guidance.
---

# Tiyi Operator

## Core Rules

- If working inside a Tiyi source checkout, read `AGENTS.md` when present plus `QUICKSTART.md` before changing operator-facing behavior.
- For maintainers with the full repo layout, edit website source under `website/`; sync the GitHub Pages mirror from it instead of hand-editing the mirror.
- Keep the website `install.sh` and public distribution `install.sh` aligned when installer behavior changes.
- Do not replace `tiyi.io/tiyi/...`; it is the Go module path. The product site is `https://www.tiyisec.com`.
- Prefer short working commands over long explanations, and keep EN/zh docs synchronized.

## Build And Run

Build from source:

```sh
make proto
make web
make build
```

Run a single-host instance:

```sh
./bin/tiyi standalone
```

Use explicit first-run admin credentials for automation:

```sh
mkdir -p /tmp/waf
TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD='choose-a-strong-password' \
  ./bin/tiyi standalone \
  --addr 0.0.0.0:8080 \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443 \
  --admin-socket /tmp/waf/admin.sock
```

First-run rules:

- `standalone` auto-creates `admin` with a random one-time password only when no users exist and no explicit credentials were supplied.
- `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` creates the configured admin in any login-serving mode and suppresses the random password banner.
- Later restarts do not regenerate users. Reset a lost password locally with `tiyi user list` and `tiyi user reset-password <user-id> --password <new-password>`.

## CLI And UI

- The Web UI is served by the same binary at the API root, usually `http://127.0.0.1:8080/`.
- Local CLI commands prefer the Unix admin socket and need no token when run on the same host as `tiyi standalone` or `tiyi server`.
- Remote CLI commands need `--api` and a JWT from `tiyi auth login`.
- For shared local CLI access, set `--admin-socket-mode 0660 --admin-socket-group <group>`.

Common smoke path:

```sh
./bin/tiyi upstream create --name demo-backend --target http://127.0.0.1:9000
./bin/tiyi site create --name demo --hostname demo.local --upstream demo-backend --policy "Built-in Standard" --tls none
./bin/tiyi site enable demo
curl -H 'Host: demo.local' 'http://127.0.0.1:8180/?id=1%27%20OR%20%271%27=%271'
```

## Modes

- `tiyi standalone`: control plane, embedded agent, proxy, and UI in one process.
- `tiyi server` or `tiyi primary`: primary control plane with embedded proxy.
- `tiyi secondary` or `tiyi standby`: warm replica with embedded proxy; promote manually.
- `tiyi agent`: data plane only; receives signed bundles from the primary.
- `tiyi dashboard`: UI-only split deployment.

Agent enrollment:

```sh
TOKEN="$(tiyi agents issue-token --tag edge-a | jq -r .token)"
tiyi agent --api http://primary:8080 --enrollment-token "$TOKEN" --state-dir /var/lib/tiyi/agent
```

## Releases And Licensing

- `make release` requires a clean worktree, verifies embedded vendor/release public keys through focused tests, rebuilds proto/web/binary outputs, then packages signed Linux artifacts.
- Release tarballs use `tiyi_<ver>_linux_<arch>.tar.gz` and include `tiyi`, `tiyi.sig`, `tiyi-release.json`, `VERSION`, `CHANGELOG.md`, `EULA.md`, and `NOTICE`.
- `tiyi update --check` reports availability; `tiyi update --yes` downloads, verifies SHA-256 plus Ed25519 signatures, and swaps the on-disk binary. Restart the service afterward. Use `--mirror gitee` to force the Gitee release mirror.
- Tiyi gates scale, not features. Community is full-featured on the local node with zero remote agents. A vendor-signed license raises the remote-agent budget.
- Import licenses from System -> About or use `license.key_path` / `TIYI_LICENSE_KEY_PATH` for headless deployments. Invalid or expired licenses degrade to Community without stopping the data plane or known agents.

## Troubleshooting

- No dashboard login: check whether users exist. For `standalone`, inspect the first-run password banner or reset over the local admin socket. For `server`, intentionally create credentials with `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` or `tiyi admin init`.
- CLI cannot connect locally: verify the admin socket path, mode, group, and that the command is run as a user with access to the socket.
- Proxy ports fail to bind: use unprivileged `--proxy-http-addr` / `--proxy-https-addr` for local QA, or grant `CAP_NET_BIND_SERVICE` under systemd for ports 80/443.
- WAF blocks produce empty replies: inspect `/debug/logsink/stats` on the local admin socket. A nonzero `panicked` counter means an observability boundary recovered from a panic and needs investigation.
- Release import or update fails: verify `SHA256SUMS`, `SHA256SUMS.sig`, `tiyi.sig`, and that the artifact was signed by the embedded release key.

## Verification

Run the smallest relevant check:

- Go/API/CLI: `go test ./...`
- Proto: `tmp/buf/bin/buf lint`
- Frontend: use the Vben app typecheck/build command
- Browser UI: use Playwright and capture evidence
- Docs-only: read back edited files and check EN/zh, public repo, website source, and deploy mirror consistency
