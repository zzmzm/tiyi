# Tiyi

Single-binary, self-hostable WAF-enabled reverse proxy with an integrated
management plane — Caddy + Coraza + SQLite + an admin UI in one Go executable.

This repository is the **distribution channel** for Tiyi. Tiyi is commercial,
closed-source software: the source is not published here. This repo holds the
installer, documentation, and the public release-signing key; the compiled,
signed binaries are attached to each [GitHub Release](../../releases) (not
committed to the repo).

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash
```

The installer downloads the latest signed release for your platform, verifies
its SHA-256 (required) and — when OpenSSL 3.x is available — its Ed25519
release signature, then installs `tiyi` to `/usr/local/bin`. Override with
`TIYI_VERSION`, `TIYI_PREFIX`, or `TIYI_REPO`.

Then start a single-host install:

```sh
tiyi standalone
```

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

## Documentation

- English: [`docs/en/getting-started.md`](docs/en/getting-started.md)
- 中文: [`docs/zh/getting-started.md`](docs/zh/getting-started.md)

## Releases & channels

- **Stable** — full releases (`tiyi self-update` default).
- **Pre-release** — rc/beta builds (`tiyi self-update --channel prerelease`).

## Legal

- License: [EULA.md](EULA.md) (proprietary).
- Third-party attributions: [NOTICE](NOTICE).
- Security policy & vulnerability reporting: [SECURITY.md](SECURITY.md).

"Tiyi" and the Tiyi logo are trademarks of the Tiyi Authors.
