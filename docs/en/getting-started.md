# Getting started with Tiyi

Tiyi is a single-binary, self-hostable WAF-enabled reverse proxy with an
integrated management plane.

## 1. Install

```sh
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash
```

The installer detects your platform (Linux amd64/arm64), resolves the latest
signed release, verifies it, and installs `tiyi` to `/usr/local/bin`.

Pin a version or change the install prefix:

```sh
TIYI_VERSION=v3.0.0 TIYI_PREFIX="$HOME/.local/bin" \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh)"
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

A single-host install runs the server, agent, and dashboard in one process:

```sh
tiyi standalone
```

Open the dashboard, complete first-run admin setup, and add your first site.
For the full operator flow (config file, admin socket, sites, upstreams,
certificates, WAF policies), see the in-product documentation.

## 4. Keep it updated

```sh
tiyi self-update --check     # is a newer signed release available?
tiyi self-update --yes       # download, verify, and install it
```

`self-update` verifies the SHA-256 and the Ed25519 release signature against the
key embedded in the binary before replacing it on disk. **Restart the service**
after updating. Track pre-release builds with `--channel prerelease`.

## 5. Licensing

Tiyi runs free in single-node Community mode. Multi-node (remote agent) fleets
require a license. See [EULA.md](../../EULA.md).

## Support

Report security issues privately per [SECURITY.md](../../SECURITY.md). For other
questions, open an issue on the distribution repository.
