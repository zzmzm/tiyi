#!/usr/bin/env bash
#
# Tiyi installer.
#
#   curl -fsSL https://raw.githubusercontent.com/zzmzm/tiyi/main/install.sh | bash
#   curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh | TIYI_MIRROR=gitee bash
#   # or, from a clone:
#   ./install.sh
#
# Downloads the latest (or TIYI_VERSION) signed release for this platform,
# verifies its SHA-256 (required) and Ed25519 release signature when supported
# by local OpenSSL (best effort, needs pkeyutl -rawin + xxd), and installs the
# tiyi binary.
#
# Environment overrides:
#   TIYI_MIRROR      auto | github | gitee     (default: auto)
#   TIYI_REPO        GitHub owner/name         (default: zzmzm/tiyi)
#   TIYI_GITEE_REPO  Gitee owner/name          (default: tiyisec/tiyi)
#   TIYI_VERSION     pin a tag, e.g. v3.3.0    (default: latest stable)
#   TIYI_PREFIX      install directory         (default: /usr/local/bin)
set -euo pipefail

MIRROR="${TIYI_MIRROR:-auto}"
GITHUB_REPO="${TIYI_REPO:-zzmzm/tiyi}"
GITEE_REPO="${TIYI_GITEE_REPO:-tiyisec/tiyi}"
PREFIX="${TIYI_PREFIX:-/usr/local/bin}"

# The Ed25519 release public key (base64, std). Matches release-key.pub and the
# key embedded in the tiyi binary. Used for best-effort signature verification.
RELEASE_PUBKEY_B64="RIH4Xm2V8NjU4byn/xq+36xQG38dWQ9eQB39Bk+Aze4="

err() { echo "error: $*" >&2; exit 1; }

case "$MIRROR" in
	auto | github | gitee) ;;
	*) err "TIYI_MIRROR must be auto, github, or gitee (got '$MIRROR')" ;;
esac

# Run a command as root: directly when already root, otherwise via sudo.
as_root() {
	if [ "$(id -u)" -eq 0 ]; then
		"$@"
	else
		sudo "$@"
	fi
}

color_enabled() {
	[ -t 1 ] && [ -z "${NO_COLOR:-}" ] && [ "${TERM:-}" != "dumb" ]
}

if color_enabled; then
	C_RESET="$(printf '\033[0m')"
	C_OK="$(printf '\033[32m')"
	C_WARN="$(printf '\033[33m')"
	C_INFO="$(printf '\033[36m')"
	C_BOLD="$(printf '\033[1m')"
else
	C_RESET=""
	C_OK=""
	C_WARN=""
	C_INFO=""
	C_BOLD=""
fi

doctor_line() {
	local color="$1" status="$2" label="$3" message="$4"
	printf '  %s%-5s%s %-13s %s\n' "$color" "$status" "$C_RESET" "$label:" "$message"
}

doctor_detail() {
	printf '        %s\n' "$*"
}

path_has_dir() {
	local list="$1" dir="$2" old_ifs part
	old_ifs=$IFS
	IFS=:
	for part in $list; do
		if [ "$part" = "$dir" ]; then
			IFS=$old_ifs
			return 0
		fi
	done
	IFS=$old_ifs
	return 1
}

sudo_secure_path() {
	sudo -V 2>/dev/null | awk '
		/Secure Path:/ { sub(/^.*Secure Path:[[:space:]]*/, ""); print; exit }
		/secure_path=/ { sub(/^.*secure_path=/, ""); print; exit }
		/Value to override user.*PATH with:/ { sub(/^.*PATH with:[[:space:]]*/, ""); print; exit }
	'
}

install_check_sudo_path() {
	local installed_bin="$1" bin_dir secure
	bin_dir=$(dirname "$installed_bin")
	if command -v tiyi >/dev/null 2>&1; then
		doctor_line "$C_OK" "OK" "shell PATH" "tiyi resolves to $(command -v tiyi)"
	else
		doctor_line "$C_WARN" "WARN" "shell PATH" "tiyi is not visible in this shell PATH"
		doctor_detail "Add $bin_dir to PATH, or run $installed_bin explicitly."
	fi

	if ! command -v sudo >/dev/null 2>&1; then
		if [ "$(id -u)" -eq 0 ]; then
			doctor_line "$C_INFO" "INFO" "sudo PATH" "sudo is unavailable, but you are root; run $installed_bin install --now directly."
		else
			doctor_line "$C_WARN" "WARN" "sudo PATH" "sudo is unavailable; sudo tiyi install --now cannot run."
		fi
		return
	fi
	if sudo -n sh -c 'command -v tiyi >/dev/null' >/dev/null 2>&1; then
		doctor_line "$C_OK" "OK" "sudo PATH" "sudo can resolve tiyi"
		return
	fi
	secure=$(sudo_secure_path || true)
	if [ -n "$secure" ] && ! path_has_dir "$secure" "$bin_dir"; then
		doctor_line "$C_WARN" "WARN" "sudo PATH" "sudo secure_path does not include $bin_dir"
		doctor_detail "If sudo tiyi install --now says command not found, run: sudo \"$installed_bin\" install --now"
		doctor_detail "Permanent fix: add $bin_dir to secure_path with sudo visudo."
	else
		doctor_line "$C_INFO" "INFO" "sudo PATH" "could not confirm sudo PATH without prompting"
		doctor_detail "If sudo cannot find tiyi, run: sudo \"$installed_bin\" install --now"
	fi
}

listener_for_port() {
	local port="$1"
	if command -v ss >/dev/null 2>&1; then
		ss -H -ltnp 2>/dev/null | awk -v p=":$port" '$4 ~ p "$" {print; exit}'
		return
	fi
	if command -v lsof >/dev/null 2>&1; then
		lsof -nP "-iTCP:$port" -sTCP:LISTEN 2>/dev/null | awk 'NR == 2 {print $1 " pid=" $2 " user=" $3; exit}'
		return
	fi
	return 0
}

process_name_from_listener() {
	printf '%s' "$1" | sed -n 's/.*users:((\"\([^\"]*\)\".*/\1/p'
}

install_check_port() {
	local label="$1" port="$2" key="$3" fallback="$4" line proc
	line=$(listener_for_port "$port" || true)
	if [ -z "$line" ]; then
		doctor_line "$C_OK" "OK" "$label" "port $port has no active TCP listener"
		return
	fi
	if printf '%s' "$line" | grep -qi '\"tiyi\"\|tiyi'; then
		doctor_line "$C_OK" "OK" "$label" "port $port is already held by tiyi"
		return
	fi
	doctor_line "$C_WARN" "WARN" "$label" "port $port is already in use"
	doctor_detail "$line"
	doctor_detail "Release it for Tiyi: stop or disable the service that owns the port."
	if ! printf '%s' "$line" | grep -q 'users:(('; then
		doctor_detail "Rerun sudo tiyi doctor for process details when available."
	fi
	proc=$(process_name_from_listener "$line")
	if [ -n "$proc" ]; then
		doctor_detail "Example when appropriate: sudo systemctl stop $proc"
	fi
	doctor_detail "Or move Tiyi: set $key to \"$fallback\" in /etc/tiyi/server.yaml."
}

run_install_environment_check() {
	local installed_bin="$1"
	echo
	printf '%sInstallation environment check%s\n' "$C_BOLD" "$C_RESET"
	if "$installed_bin" doctor --help >/dev/null 2>&1; then
		"$installed_bin" doctor --mode standalone || true
		return
	fi
	install_check_sudo_path "$installed_bin"
	install_check_port "API/dashboard" 8080 "server.addr" "0.0.0.0:8081"
	install_check_port "HTTP proxy" 80 "proxy.http_addr" ":8180"
	install_check_port "HTTPS proxy" 443 "proxy.https_addr" ":18443"
}

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

# --- already installed? update in place, then install + start the service --
# Re-running the installer on a host that already has tiyi stays cheap: use the
# signed in-place update (which downloads only when a newer release exists)
# instead of pulling the full tarball again, then (re)install the systemd unit
# and start it on the new binary. Falls back to a fresh download when the
# in-place update can't run (e.g. a build with no embedded release key).
existing=""
if command -v tiyi >/dev/null 2>&1; then
	existing=$(command -v tiyi)
elif [ -x "$PREFIX/tiyi" ]; then
	existing="$PREFIX/tiyi"
fi
if [ -n "$existing" ]; then
	echo "tiyi already installed: $("$existing" --version 2>/dev/null | head -1 || echo unknown)"
	echo "  Updating in place via signed update …"
	if as_root "$existing" update --yes --mirror "$MIRROR" --repo "$GITHUB_REPO"; then
		# Stop any running instance so the updated binary re-opens the state DB
		# exclusively during install; install --now then enables + starts it.
		as_root systemctl stop tiyi.service >/dev/null 2>&1 || true
		run_install_environment_check "$existing"
		echo "  Installing/refreshing the systemd service and starting it …"
		as_root "$existing" install --now
		echo
		echo "tiyi is up to date and running. Check it with: systemctl status tiyi"
		exit 0
	fi
	echo "  in-place update unavailable; falling back to a fresh download." >&2
	echo
fi

resolve_github_latest() {
	curl -fsSLI --connect-timeout 5 --max-time 10 -o /dev/null -w '%{url_effective}' "https://github.com/$GITHUB_REPO/releases/latest" |
		sed -n 's#.*/releases/tag/##p'
}

resolve_gitee_latest() {
	curl -fsSL --connect-timeout 5 --max-time 10 "https://gitee.com/api/v5/repos/$GITEE_REPO/releases/latest" |
		sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
}

asset_base_for() {
	case "$1" in
		github) printf 'https://github.com/%s/releases/download/%s\n' "$GITHUB_REPO" "$tag" ;;
		gitee) printf 'https://gitee.com/%s/releases/download/%s\n' "$GITEE_REPO" "$tag" ;;
		*) return 1 ;;
	esac
}

# --- resolve the release tag ----------------------------------------------
tag="${TIYI_VERSION:-}"
selected_mirror="$MIRROR"
if [ -z "$tag" ]; then
	case "$MIRROR" in
		github)
			tag=$(resolve_github_latest)
			selected_mirror=github
			;;
		gitee)
			tag=$(resolve_gitee_latest)
			selected_mirror=gitee
			;;
		auto)
			if tag=$(resolve_github_latest) && [ -n "$tag" ]; then
				selected_mirror=github
			else
				echo "  GitHub latest lookup failed or timed out; trying Gitee mirror …" >&2
				tag=$(resolve_gitee_latest)
				selected_mirror=gitee
			fi
			;;
	esac
elif [ "$selected_mirror" = "auto" ]; then
	selected_mirror=github
fi
[ -n "$tag" ] || err "could not resolve the latest release tag"
ver="${tag#v}"
tarball="tiyi_${ver}_${os}_${arch}.tar.gz"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Installing tiyi $tag ($os/$arch) …"

# The release tarball is the large, slow download. Show a live progress bar on
# an interactive terminal so it never looks frozen; stay quiet (silent, but
# still surface errors) in pipelines / CI logs where a redrawing bar is noise.
dl_opts=(-fsSL --connect-timeout 10 --speed-limit 20480 --speed-time 30)
if [ -t 2 ]; then
	dl_opts=(-fL --progress-bar --connect-timeout 10 --speed-limit 20480 --speed-time 30)
fi
meta_opts=(-fsSL --connect-timeout 10 --max-time 60)

download_release_assets() {
	local source="$1" base="$2"
	rm -f "$tmp/$tarball" "$tmp/SHA256SUMS" "$tmp/SHA256SUMS.sig"
	echo "  Download source: $source"
	echo "  Downloading $tarball …"
	curl "${dl_opts[@]}" -o "$tmp/$tarball" "$base/$tarball" || return 1
	curl "${meta_opts[@]}" -o "$tmp/SHA256SUMS" "$base/SHA256SUMS" || return 1
	curl "${meta_opts[@]}" -o "$tmp/SHA256SUMS.sig" "$base/SHA256SUMS.sig" 2>/dev/null || true
}

base=$(asset_base_for "$selected_mirror") || err "invalid selected mirror '$selected_mirror'"
if ! download_release_assets "$selected_mirror" "$base"; then
	if [ "$MIRROR" = "auto" ] && [ "$selected_mirror" = "github" ]; then
		echo "  GitHub download failed or was too slow; trying Gitee mirror …" >&2
		selected_mirror=gitee
		base=$(asset_base_for "$selected_mirror") || err "invalid selected mirror '$selected_mirror'"
		download_release_assets "$selected_mirror" "$base" || err "download release assets failed from GitHub and Gitee"
	else
		err "download release assets failed from $selected_mirror"
	fi
fi

# --- 1. SHA-256 (required) -------------------------------------------------
( cd "$tmp" && grep " ${tarball}\$" SHA256SUMS | sha256sum -c - >/dev/null ) ||
	err "SHA-256 verification FAILED for $tarball"
echo "  ✓ SHA-256 verified"

# --- 2. Ed25519 signature (best effort) ------------------------------------
verify_ed25519() {
	# Needs an OpenSSL build with pkeyutl -rawin plus xxd to build the SPKI PEM
	# from the raw key. CentOS 7/8 OpenSSL builds commonly lack -rawin.
	command -v openssl >/dev/null || return 2
	command -v xxd >/dev/null || return 2
	[ -s "$tmp/SHA256SUMS.sig" ] || return 2
	if ! openssl pkeyutl -help 2>&1 | grep -q -- '-rawin'; then
		return 2
	fi
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
	echo "  ! skipping Ed25519 verification (needs OpenSSL pkeyutl -rawin + xxd and SHA256SUMS.sig);"
	echo "    SHA-256 over HTTPS still applied. 'tiyi update' fully verifies signatures."
fi

# --- install ---------------------------------------------------------------
tar -C "$tmp" -xzf "$tmp/$tarball" tiyi
if [ -w "$PREFIX" ]; then
	install -m 0755 "$tmp/tiyi" "$PREFIX/tiyi"
else
	echo "  (sudo required to write $PREFIX)"
	sudo install -m 0755 "$tmp/tiyi" "$PREFIX/tiyi"
fi

installed_bin="$PREFIX/tiyi"
echo "Installed tiyi $tag to $installed_bin"
"$installed_bin" --version 2>/dev/null || true
run_install_environment_check "$installed_bin"

cat <<EOF

Next — start Tiyi as a hardened systemd service (the recommended default):

      sudo tiyi install --now

  This creates the tiyi service user, installs a unit that runs unprivileged
  and binds 80/443 via CAP_NET_BIND_SERVICE, enables it on boot, and prints the
  one-time admin login (URL + username + password) once the service is up.

  If the environment check warned that sudo cannot find tiyi, run:

      sudo "$installed_bin" install --now

  Preview the unit first with tiyi install --print; remove it later with
  sudo tiyi uninstall.

  Prefer the foreground? It stores state under /var/lib/tiyi and binds ports
  80/443, so it needs root, and prints the admin password to the console:

      sudo tiyi standalone

  If sudo cannot find tiyi, run:

      sudo "$installed_bin" standalone

  To run as a normal user (no sudo), point it at writable paths and high ports:

      mkdir -p /tmp/waf
      tiyi standalone \\
        --state-db /tmp/waf/state.db \\
        --caddy-admin-socket /tmp/waf/caddy.sock \\
        --admin-socket /tmp/waf/admin.sock \\
        --proxy-http-addr 0.0.0.0:8180 \\
        --proxy-https-addr 0.0.0.0:18443

EOF
if [ "$selected_mirror" = "gitee" ]; then
	echo "Docs: https://gitee.com/$GITEE_REPO/tree/main/docs"
else
	echo "Docs: https://github.com/$GITHUB_REPO/tree/main/docs"
fi
