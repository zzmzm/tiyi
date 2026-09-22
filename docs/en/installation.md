# Installation and service management

Choose how to install, verify downloads, deploy offline, and manage the service. New users can continue through the [quickstart](getting-started.md) for login, site creation, and request checks.
Supported platforms are Linux amd64/arm64. The installer is for a fresh host; existing installations should use [upgrade and migration](upgrade-migration.md).

<a id="prebuilt"></a>
## 1. Default installation: system service and ports 80/443/8080

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

Have curl, tar, and sha256sum available. Installing to `/usr/local/bin` needs root or sudo; the service method needs systemd.
The script downloads the binary and checks the environment. `tiyi install --now` creates an unprivileged service account, starts the service, and enables it at boot.
The first administrator password appears in your installation terminal. Use the full executable path if sudo's PATH lacks `/usr/local/bin`.
Omit sudo when already root without sudo installed. See [foreground mode](#foreground) for hosts without systemd or root access.

| Default listener | Purpose | What to do next |
|---|---|---|
| `0.0.0.0:8080` | Console and management API | Open `http://SERVER_IP:8080`; allow port 8080 from your management network |
| `:80` | Website HTTP / ACME HTTP-01 | Add a site and origin; access it by hostname |
| `:443` | Website HTTPS | Configure a TLS site and a certificate covering its domains |

Installation does not change firewall rules, cloud security groups, or DNS, or take ports from an existing web server.
Port 443 need not listen before a TLS site exists. A working console does not yet mean your application is protected.

## 2. Manual steps and custom installation

```sh
curl -fsSL https://www.tiyisec.com/install.sh -o /tmp/tiyi-install.sh
less /tmp/tiyi-install.sh
bash /tmp/tiyi-install.sh
/usr/local/bin/tiyi --version
sudo /usr/local/bin/tiyi doctor
sudo /usr/local/bin/tiyi install --now
```

Press `q` to leave less, or read with `cat`. To change ports, stop before the final command and write the [custom-port configuration](getting-started.md#custom-ports) first.
`sudo tiyi install` without `--now` only creates the unit: it does not start or enable it. Use `install --now` for its first start so credentials appear in your terminal.

<a id="mirrors"></a>
### Mirrors, pinned versions, and installation directory

For the Gitee mirror:

```sh
curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh -o /tmp/tiyi-install.sh
TIYI_MIRROR=gitee bash /tmp/tiyi-install.sh
sudo /usr/local/bin/tiyi install --now
```

The default tries GitHub first and falls back to Gitee if downloads fail or are too slow. The script is also in the GitHub distribution repository as `install.sh`.
To pin a release or install to your own directory, download the script first and use this alternative command, replacing the tag with a published release:

```sh
mkdir -p "$HOME/.local/bin"
TIYI_VERSION=vX.Y.Z TIYI_PREFIX="$HOME/.local/bin" bash /tmp/tiyi-install.sh
export PATH="$HOME/.local/bin:$PATH"
```

A home-directory binary suits a foreground trial. The systemd service enables `ProtectHome`; use `/usr/local/bin/tiyi` for that service.

| Installer variable | Default | Purpose |
|---|---|---|
| `TIYI_MIRROR` | `auto` | `auto`, `github`, or `gitee` |
| `TIYI_VERSION` | Latest stable | Select a published release tag |
| `TIYI_PREFIX` | `/usr/local/bin` | Binary directory; create it first |
| `TIYI_REPO` | `zzmzm/tiyi` | GitHub distribution repository |
| `TIYI_GITEE_REPO` | `tiyisec/tiyi` | Gitee distribution repository |

The installer **requires SHA-256 verification**. It also verifies Ed25519 when OpenSSL supports `pkeyutl -rawin`, xxd is available, and the signature file was downloaded.
It prints a skip message if signature verification is unavailable; checksum success alone is not signature verification. Use the procedure below when full verification is required.

<a id="offline"></a>
## 3. Offline installation: download, verify, install, start

### Prepare files on a connected computer

Choose a published version from [GitHub Releases](https://github.com/zzmzm/tiyi/releases) or [Gitee Releases](https://gitee.com/tiyisec/tiyi/releases).
Run `uname -m` on the **offline target**: use amd64 for `x86_64` and arm64 for `aarch64`.
On the connected computer, replace `vX.Y.Z` and select the target architecture before downloading:

```sh
# Replace the version with a published tag; select the OFFLINE host's architecture
TIYI_RELEASE='vX.Y.Z'
TIYI_ARCH='amd64'  # x86_64: amd64; aarch64: arm64
TIYI_ARCHIVE="tiyi_${TIYI_RELEASE#v}_linux_${TIYI_ARCH}.tar.gz"
mkdir -p tiyi-offline
cd tiyi-offline
TIYI_RELEASE_URL="https://github.com/zzmzm/tiyi/releases/download/${TIYI_RELEASE}"
curl -fL "$TIYI_RELEASE_URL/$TIYI_ARCHIVE" -o "$TIYI_ARCHIVE"
curl -fL "$TIYI_RELEASE_URL/SHA256SUMS" -o SHA256SUMS
curl -fL "$TIYI_RELEASE_URL/SHA256SUMS.sig" -o SHA256SUMS.sig
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/release-key.pub -o release-key.pub
```

Alternatively, download these four files from the release and repository pages. The Gitee release prefix is
`https://gitee.com/tiyisec/tiyi/releases/download/SELECTED_TAG`; its repository root contains the public key.
Transfer the directory through trusted media. The archive, checksum manifest, and signature must belong to the same version.
Prepare tar, sha256sum, base64, xxd, and an OpenSSL build supporting Ed25519 / `pkeyutl -rawin` on the target, using your distribution's offline packages if necessary.

<a id="verify-download"></a>
### Verify and install on the offline host

Enter the copied directory. Replace the archive filename and run this entire block. It checks the official public key and manifest signature before the selected archive's SHA-256; any failure stops installation.
Use the same steps for manually downloaded files on a connected host.

```sh
# Set the exact archive name copied to this host
TIYI_ARCHIVE='tiyi_X.Y.Z_linux_amd64.tar.gz'
(
  set -eu
  # Expected official Ed25519 public key; do not trust a replacement key in a bundle
  test "$(tr -d '\r\n' < release-key.pub)" = 'RIH4Xm2V8NjU4byn/xq+36xQG38dWQ9eQB39Bk+Aze4='
  { printf '302a300506032b6570032100'; base64 -d release-key.pub | xxd -p -c 256; } \
    | xxd -r -p | base64 > release-key.der.b64
  { echo '-----BEGIN PUBLIC KEY-----'; cat release-key.der.b64; echo '-----END PUBLIC KEY-----'; } \
    > release-key.pem
  base64 -d SHA256SUMS.sig > SHA256SUMS.sig.bin
  openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
    -in SHA256SUMS -sigfile SHA256SUMS.sig.bin
  # Require exactly one checksum entry for the archive being installed
  awk -v file="$TIYI_ARCHIVE" '$2 == file || $2 == "*" file' SHA256SUMS > selected.sha256
  test "$(wc -l < selected.sha256)" -eq 1
  sha256sum --check selected.sha256
  mkdir -p tiyi-release
  tar -xzf "$TIYI_ARCHIVE" -C tiyi-release tiyi
  sudo install -m 0755 tiyi-release/tiyi /usr/local/bin/tiyi
)
```

Expect `Signature Verified Successfully`, the selected archive's `OK`, and a successful exit from the entire block.
If the key, signature, checksum, or files do not match, check the official files and release selection before continuing.

### Configure offline operation and start

After successful verification and binary installation, create the service on the fresh host without starting it:

```sh
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo tee /etc/tiyi/tiyi.yaml >/dev/null <<'YAML'
server:
  addr: "0.0.0.0:8080"
geo:
  auto_update: false
YAML
sudo chown root:tiyi /etc/tiyi/tiyi.yaml
sudo chmod 0640 /etc/tiyi/tiyi.yaml
sudo tiyi install --now
sudo tiyi system health
```

Add [custom proxy ports](configuration.md#ports) before startup if required. Open `http://SERVER_IP:8080` in your browser to sign in, using the offline host's reachable IP address.
Embedded CRS and reachable local origins work without Internet access. Upload certificates for HTTPS and MMDB files in system settings if country/ASN data is needed.
ACME, external IP subscriptions, notifications, and AI still require their respective connections; configure them for the network you have.
Continue with the [quickstart origin and site steps](getting-started.md), including normal and blocked request checks.

<a id="foreground"></a>
## 4. Foreground or non-root trial

Install the binary to your own writable directory first. Keep state on persistent disk; the console uses 8080 and local website tests use high ports:

```sh
mkdir -p "$HOME/.local/share/tiyi-demo"
"$HOME/.local/bin/tiyi" run --addr 0.0.0.0:8080 \
  --state-db "$HOME/.local/share/tiyi-demo/state.db" \
  --admin-socket "$HOME/.local/share/tiyi-demo/admin.sock" \
  --caddy-admin-socket "$HOME/.local/share/tiyi-demo/caddy.sock" \
  --proxy-http-addr 127.0.0.1:8180 \
  --proxy-https-addr 127.0.0.1:18443
```

Leave the terminal running; first-run credentials appear there. Ctrl+C stops the process and preserves state; run the same command to resume.
In another terminal, pass the actual socket to CLI calls:

```sh
"$HOME/.local/bin/tiyi" --admin-socket "$HOME/.local/share/tiyi-demo/admin.sock" system health
```

Open `http://SERVER_IP:8080` in your browser, using the Tiyi host's IP address. Run website probes on the Tiyi host against `http://127.0.0.1:8180/`.
For production without systemd, supervise `tiyi run` with your existing process manager and configure its user, boot startup, and restart policy.

<a id="service"></a>
## 5. Service lifecycle and files

| Task | Command |
|---|---|
| Check boot startup and process | `sudo systemctl is-enabled tiyi` · `sudo systemctl status tiyi --no-pager` |
| Read recent startup errors | `sudo journalctl -u tiyi -n 100 --no-pager` |
| Pause / resume an existing service | `sudo systemctl stop tiyi` · `sudo systemctl start tiyi` |
| Restart after changing startup configuration | `sudo systemctl restart tiyi` |
| Check application health | `sudo tiyi system health` |
| Remove the service, retain data | `sudo tiyi uninstall` |

Stopping a single-node service interrupts the websites it serves; plan traffic movement or a maintenance window. Site and policy changes through UI/CLI/API normally publish without a process restart.

| Path | Contents / backup requirement |
|---|---|
| `/usr/local/bin/tiyi` | Binary; record its version and retain a matching old binary with backups |
| `/etc/tiyi/tiyi.yaml` | Optional startup configuration; built-in defaults apply if absent |
| `/etc/tiyi/tiyi.env` | Optional systemd environment and secrets; restrict access and back it up |
| `/var/lib/tiyi/` | Complete persistent state, certificates, default KEK, and data; back up consistently |
| `/run/tiyi/` | Runtime sockets recreated at startup; not recovery data |

`tiyi update` only replaces the binary; it does not restart services or convert incompatible state. Follow [upgrade and migration](upgrade-migration.md) for backups and recovery.
`uninstall --purge` deletes state and configuration; use ordinary lifecycle commands for restart and the local reset command for lost credentials.

## 6. Runtime environment variables

Prefer `tiyi.yaml` for persistent service configuration. Use environment
variables only when your service manager, container runtime, or secret manager
injects config at runtime. Env names mirror config keys: prefix `TIYI_`,
uppercase the key, and replace dots with underscores. For example,
`auth.jwt_secret` becomes `TIYI_AUTH_JWT_SECRET`.

Use the [complete annotated `tiyi.yaml` template](templates/tiyi.yaml) for
file-based configuration. It includes every supported process key, secure-file
notes, and a matching [install/validate procedure](configuration.md).

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
