# Security Policy

## Reporting a vulnerability

If you believe you have found a security vulnerability in Tiyi, please report it
privately. **Do not open a public issue for security reports.**

- Preferred: open a private advisory via GitHub Security Advisories on the
  distribution repository (Security → "Report a vulnerability").
- Or email: **[security@your-domain.example]** (replace with your real security
  contact before publishing).

Please include: affected version (`tiyi --version`), a description of the issue,
reproduction steps or a proof of concept, and the impact you observed. If you
can, encrypt sensitive details.

We aim to acknowledge reports within 3 business days and to provide a remediation
plan or timeline within 10 business days. Please give us a reasonable opportunity
to remediate before any public disclosure (coordinated disclosure).

## Supported versions

Security fixes are provided for the latest stable release. Pre-release (rc/beta)
builds receive fixes only in the next release. Run a current version to stay
protected; Tiyi can check for updates against the configured release channel.

## Release integrity (verify before you run)

Tiyi releases are distributed as signed artifacts. Every published release
includes per-platform tarballs, a `SHA256SUMS` checksum file, a detached
signature `SHA256SUMS.sig`, and `release-manifest.json`. Each tarball also
contains the binary's own detached signature `tiyi.sig`.

Signatures are **Ed25519** over the raw bytes of the file they protect. The
public verification key is published as `release-key.pub` in the distribution
repository and is embedded in the `tiyi` binary itself.

- Release signing key id: `ed25519:7e61a8ca1696288d`

The private signing key is held offline by the vendor and never ships in the
product, never appears in the source tree, and is never transmitted.

### Verifying a download manually

```sh
# 1. Verify the checksums file is authentic (signed by the release key):
go run ./tools/release verify \
    --pub release-key.pub --in SHA256SUMS --sig SHA256SUMS.sig

# 2. Verify your downloaded tarball matches the (now-trusted) checksums:
sha256sum --check --ignore-missing SHA256SUMS

# 3. (Optional) verify the binary signature inside the extracted tarball:
tar -xzf tiyi_*_linux_amd64.tar.gz
go run ./tools/release verify --pub release-key.pub --in tiyi --sig tiyi.sig
```

### Automated verification

- **Operator import** (`ImportBinaryRelease` / `tiyi release import`): the server
  extracts the tarball, recomputes the SHA-256, and verifies the Ed25519
  signature against the embedded release key before the artifact is stored. A
  tampered or wrong-key artifact is rejected.
- **Agent self-update** (`apply-binary`): before swapping its executable, an
  agent verifies both the advertised SHA-256 and the Ed25519 release signature.
  The update fails closed — an unsigned or unverifiable binary is never applied.

If signature verification fails, do not run the artifact and report it through
the channel above.

## Hardening notes

- The local admin socket is passwordless by design and protected by filesystem
  permissions; restrict access to its Unix socket path accordingly.
- Update checks make outbound HTTPS requests to the configured release API
  (`update.repo` / `TIYI_UPDATE_REPO`). Set `update.repo` to empty to disable
  update checks entirely in air-gapped deployments.
