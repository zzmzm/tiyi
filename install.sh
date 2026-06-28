#!/usr/bin/env bash
#
# Tiyi installer.
#
#   curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash
#   # or, from a clone:
#   ./install.sh
#
# Downloads the latest (or TIYI_VERSION) signed release for this platform,
# verifies its SHA-256 (required) and Ed25519 release signature (best effort,
# needs OpenSSL 3.x + xxd), and installs the tiyi binary.
#
# Environment overrides:
#   TIYI_REPO     GitHub owner/name        (default: zzmzm/tiyi)
#   TIYI_VERSION  pin a tag, e.g. v3.0.1   (default: latest stable)
#   TIYI_PREFIX   install directory        (default: /usr/local/bin)
set -euo pipefail

REPO="${TIYI_REPO:-zzmzm/tiyi}"
PREFIX="${TIYI_PREFIX:-/usr/local/bin}"

# The Ed25519 release public key (base64, std). Matches release-key.pub and the
# key embedded in the tiyi binary. Used for best-effort signature verification.
RELEASE_PUBKEY_B64="RIH4Xm2V8NjU4byn/xq+36xQG38dWQ9eQB39Bk+Aze4="

err() { echo "error: $*" >&2; exit 1; }

# --- platform detection ----------------------------------------------------
os=$(uname -s | tr '[:upper:]' '[:lower:]')
[ "$os" = "linux" ] || err "unsupported OS '$os' (linux only)"
case "$(uname -m)" in
	x86_64 | amd64) arch=amd64 ;;
	aarch64 | arm64) arch=arm64 ;;
	*) err "unsupported architecture '$(uname -m)'" ;;
esac

command -v curl >/dev/null || err "curl is required"
command -v sha256sum >/dev/null || err "sha256sum is required"
command -v tar >/dev/null || err "tar is required"

# --- resolve the release tag ----------------------------------------------
tag="${TIYI_VERSION:-}"
if [ -z "$tag" ]; then
	# Follow the /releases/latest redirect to the tag URL — no API rate limit.
	tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest" |
		sed -n 's#.*/releases/tag/##p')
fi
[ -n "$tag" ] || err "could not resolve the latest release tag for $REPO"
ver="${tag#v}"
tarball="tiyi_${ver}_${os}_${arch}.tar.gz"
base="https://github.com/$REPO/releases/download/$tag"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Installing tiyi $tag ($os/$arch) from $REPO …"

# The release tarball is the large, slow download. Show a live progress bar on
# an interactive terminal so it never looks frozen; stay quiet (silent, but
# still surface errors) in pipelines / CI logs where a redrawing bar is noise.
dl_opts=(-fsSL)
if [ -t 2 ]; then
	dl_opts=(-fL --progress-bar)
fi

echo "  Downloading $tarball …"
curl "${dl_opts[@]}" -o "$tmp/$tarball" "$base/$tarball" || err "download $tarball failed"
curl -fsSL -o "$tmp/SHA256SUMS" "$base/SHA256SUMS" || err "download SHA256SUMS failed"
curl -fsSL -o "$tmp/SHA256SUMS.sig" "$base/SHA256SUMS.sig" 2>/dev/null || true

# --- 1. SHA-256 (required) -------------------------------------------------
( cd "$tmp" && grep " ${tarball}\$" SHA256SUMS | sha256sum -c - >/dev/null ) ||
	err "SHA-256 verification FAILED for $tarball"
echo "  ✓ SHA-256 verified"

# --- 2. Ed25519 signature (best effort) ------------------------------------
verify_ed25519() {
	# Needs OpenSSL 3.x (-rawin) + xxd to build the SPKI PEM from the raw key.
	command -v openssl >/dev/null || return 2
	command -v xxd >/dev/null || return 2
	[ -s "$tmp/SHA256SUMS.sig" ] || return 2
	local keyhex der pem
	keyhex=$(printf '%s' "$RELEASE_PUBKEY_B64" | base64 -d 2>/dev/null | xxd -p -c 256 | tr -d '\n')
	[ -n "$keyhex" ] || return 2
	# 12-byte Ed25519 SubjectPublicKeyInfo prefix + 32-byte raw key.
	der="302a300506032b6570032100${keyhex}"
	pem="$tmp/release-key.pem"
	{
		echo "-----BEGIN PUBLIC KEY-----"
		printf '%s' "$der" | xxd -r -p | base64
		echo "-----END PUBLIC KEY-----"
	} >"$pem"
	base64 -d "$tmp/SHA256SUMS.sig" >"$tmp/SHA256SUMS.sig.raw" 2>/dev/null || return 1
	openssl pkeyutl -verify -pubin -inkey "$pem" -rawin \
		-in "$tmp/SHA256SUMS" -sigfile "$tmp/SHA256SUMS.sig.raw" >/dev/null 2>&1
}
if verify_ed25519; then
	echo "  ✓ Ed25519 release signature verified"
else
	rc=$?
	if [ "$rc" = "1" ]; then
		err "Ed25519 signature verification FAILED — refusing to install"
	fi
	echo "  ! skipping Ed25519 verification (needs OpenSSL 3.x + xxd and SHA256SUMS.sig);"
	echo "    SHA-256 over HTTPS still applied. 'tiyi self-update' fully verifies signatures."
fi

# --- install ---------------------------------------------------------------
tar -C "$tmp" -xzf "$tmp/$tarball" tiyi
if [ -w "$PREFIX" ]; then
	install -m 0755 "$tmp/tiyi" "$PREFIX/tiyi"
else
	echo "  (sudo required to write $PREFIX)"
	sudo install -m 0755 "$tmp/tiyi" "$PREFIX/tiyi"
fi

echo "Installed tiyi $tag to $PREFIX/tiyi"
"$PREFIX/tiyi" --version 2>/dev/null || true

cat <<'EOF'

Next — start a single-host install.

  Recommended (systemd): install a hardened service that runs unprivileged,
  binds 80/443 via CAP_NET_BIND_SERVICE, and starts on boot:

      sudo tiyi install --now

  The one-time admin password is printed once to the journal:

      journalctl -u tiyi -b | grep -i password

  (Preview the unit first with `tiyi install --print`; remove it later with
  `sudo tiyi uninstall`.)

  Or run it in the foreground. The default stores state under /var/lib/tiyi
  and binds ports 80/443, so it needs root:

      sudo tiyi standalone

  To run as a normal user (no sudo), point it at writable paths and high ports:

      mkdir -p /tmp/waf
      tiyi standalone \
        --state-db /tmp/waf/state.db \
        --caddy-admin-socket /tmp/waf/caddy.sock \
        --admin-socket /tmp/waf/admin.sock \
        --proxy-http-addr 0.0.0.0:8180 \
        --proxy-https-addr 0.0.0.0:18443

EOF
echo "Docs: https://github.com/$REPO/tree/main/docs"
