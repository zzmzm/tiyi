# Getting started with Tiyi

Tiyi is a single-binary, self-hostable WAF-enabled reverse proxy with an
integrated management plane.

## 1. Install

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash
```

The installer detects your platform (Linux amd64/arm64), resolves the latest
signed release, verifies it, and installs `tiyi` to `/usr/local/bin`. The same
script is mirrored at
`https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh`.

Pin a version or change the install prefix:

```sh
TIYI_VERSION=v3.0.2 TIYI_PREFIX="$HOME/.local/bin" \
  bash -c "$(curl -fsSL https://www.tiyisec.com/install.sh)"
```

## 2. Verify a download manually (optional)

Every release attaches `SHA256SUMS`, `SHA256SUMS.sig`, and a per-platform
tarball. First check the checksum:

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

To verify the Ed25519 signature of the checksums with OpenSSL 3.x, build a PEM
from the published raw public key (`release-key.pub`):

```sh
{ printf '302a300506032b6570032100'; base64 -d release-key.pub | xxd -p -c 256; } \
  | xxd -r -p | base64 > /tmp/k.b64
{ echo "-----BEGIN PUBLIC KEY-----"; cat /tmp/k.b64; echo "-----END PUBLIC KEY-----"; } \
  > release-key.pem

openssl pkeyutl -verify -pubin -inkey release-key.pem -rawin \
  -in SHA256SUMS -sigfile <(base64 -d SHA256SUMS.sig)
```

The `302a300506032b6570032100` prefix is the fixed Ed25519
SubjectPublicKeyInfo header; the published key is the 32 raw key bytes in
base64.

## 3. Run

A single-host install runs the server, agent, and dashboard in one process. By
default Tiyi stores its state under `/var/lib/tiyi` and binds ports 80/443, so
the default invocation needs root:

```sh
sudo tiyi standalone
```

On first boot Tiyi auto-creates an `admin` account and prints a one-time random
password to the console — copy it before it scrolls away (it is stored only as a
hash). Open `http://127.0.0.1:8080`, sign in as `admin`, and add your first
site. For the full operator flow (config file, admin socket, sites, upstreams,
certificates, WAF policies), see <https://www.tiyisec.com/docs/>.

To run as a normal user without `sudo`, point Tiyi at writable paths and high
ports — the advanced command below does exactly that.

### Advanced: run as a normal user / pick your own admin password

For automation, container images, CI, or simply running without `sudo`, point
Tiyi at writable paths and high ports (and, optionally, set the admin password)
— all in one command. Nothing here touches `/var/lib/tiyi` or ports 80/443, so
no root is needed:

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
defaults to `admin`. Auto-generation only fires when no users exist yet, so
restarts are no-ops. Lost the password? Reset it on the same host over the local
admin socket — no login required:

```sh
tiyi user list
tiyi user reset-password <user-id> --password <new-password>
```

## 4. Keep it updated

```sh
tiyi self-update --check     # is a newer signed release available?
tiyi self-update --yes       # download, verify, and install it
```

`self-update` verifies the SHA-256 and the Ed25519 release signature against the
key embedded in the binary before replacing it on disk. **Restart the service**
after updating. Track pre-release builds with `--channel prerelease`.

## 5. Licensing

Tiyi is free and full-featured on a single node. Growing to multiple nodes
(remote agents) uses a signed license — the single-node experience is
unchanged. See [EULA.md](../../EULA.md).

## Support

Report security issues privately per [SECURITY.md](../../SECURITY.md). For other
questions, open an issue on the distribution repository.
