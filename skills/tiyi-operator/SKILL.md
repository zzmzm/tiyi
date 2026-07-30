---
name: tiyi-operator
description: Operate Tiyi, the single-binary WAF platform. Use when Codex needs to install, build, run, configure, document, or troubleshoot Tiyi workflows including the Controller, remote Agent, dashboard, first-run admin bootstrap, local admin socket CLI, Web UI access, site/upstream/policy operations, signed releases, binary update, license import, and production operator guidance.
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
./bin/tiyi run
```

Use explicit first-run admin credentials for automation:

```sh
mkdir -p /tmp/waf
TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD='choose-a-strong-password' \
  ./bin/tiyi run \
  --addr 0.0.0.0:8080 \
  --state-db /tmp/waf/state.db \
  --caddy-admin-socket /tmp/waf/caddy.sock \
  --proxy-http-addr 0.0.0.0:8180 \
  --proxy-https-addr 0.0.0.0:18443 \
  --admin-socket /tmp/waf/admin.sock
```

First-run rules:

- `run` auto-creates `admin` with a random one-time password only when no users exist and no explicit credentials were supplied.
- `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` creates the configured admin in any login-serving mode and suppresses the random password banner.
- Later restarts do not regenerate users. Reset a lost password locally with `tiyi user list` and `tiyi user reset-password <user-id> --password <new-password>`.

## CLI And UI

- The Web UI is served by the same binary at the API root, usually `http://127.0.0.1:8080/`.
- Local CLI commands prefer the Unix admin socket and need no token when run on the same host as `tiyi run`.
- Remote CLI commands need `--api` and a JWT from `tiyi auth login`.
- For shared local CLI access, set `--admin-socket-mode 0660 --admin-socket-group <group>`.

Common smoke path:

```sh
python3 -m http.server 9000
./bin/tiyi site create --name demo --host demo.local --upstream-url http://127.0.0.1:9000 --tls none
curl -H 'Host: demo.local' 'http://127.0.0.1:8180/?id=1%27%20OR%20%271%27=%271'
```

New sites are active immediately. The one-step create path makes the upstream
pool and uses the built-in Standard policy.

## Runtime Commands

- `tiyi run`: the complete writable Controller, built-in local data plane, proxy, API, and UI.
- `tiyi agent`: a remote data plane that receives signed bundles from one Controller URL.
- `tiyi dashboard`: a UI-only process.
- Adding or removing remote Agents changes node count, not the Controller's mode or role.
- A remote Agent keeps serving its last accepted signed bundle while the Controller is unavailable; configuration and central management remain unavailable.

Agent enrollment:

```sh
sudo curl -fsSL -o /usr/local/bin/tiyi 'https://tiyi.example.com/download/tiyi'
sudo chmod 0755 /usr/local/bin/tiyi
sudo mkdir -p /etc/tiyi
printf 'TIYI_CONTROLLER_URL=https://tiyi.example.com\nTIYI_AGENT_ENROLLMENT_TOKEN=<one-use-token>\n' | sudo tee /etc/tiyi/tiyi-agent.env >/dev/null
sudo chmod 0600 /etc/tiyi/tiyi-agent.env
sudo tiyi install --mode agent --unit-name tiyi-agent --now
```

Generate the token under **Nodes → Install**. The page also shows the original
foreground command and complete download-and-start script.

## Releases And Licensing

- `make release` requires a clean worktree, verifies embedded vendor/release public keys through focused tests, rebuilds proto/web/binary outputs, then packages signed Linux artifacts.
- Release tarballs use `tiyi_<ver>_linux_<arch>.tar.gz` and include `tiyi`, `tiyi.sig`, `tiyi-release.json`, `VERSION`, `CHANGELOG.md`, `EULA.md`, and `NOTICE`.
- `tiyi update --check` reports availability; `tiyi update --yes` downloads, verifies SHA-256 plus Ed25519 signatures, and swaps the on-disk binary. Restart the service afterward. Use `--mirror gitee` to force the Gitee release mirror.
- Tiyi gates scale, not features. Community is full-featured on the local node with zero remote agents. A vendor-signed license raises the remote-agent budget.
- Import licenses from System -> About or use `license.key_path` / `TIYI_LICENSE_KEY_PATH` for headless deployments. Invalid or expired licenses degrade to Community without stopping the data plane or known agents.

## Troubleshooting

- v3.4.0 clean-state cutover: databases below schema 47, older Agent identity
  markers, and cached bundles are rejected by design. Preserve source
  manifests/secrets as needed, archive the old state, and re-enroll Agents;
  do not copy the legacy database forward.
- No dashboard login: check whether users exist. Inspect the `tiyi run` first-run password banner or reset over the local admin socket. For automation, set `TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD` before the first start.
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
