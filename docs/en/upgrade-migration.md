# Upgrade and migrate Tiyi

Use the workflow that matches the change:

| Goal | Workflow |
|---|---|
| Install a compatible signed release on the same host | Back up → `tiyi update --yes` → restart → verify |
| Move a Controller without changing its state format | Stop source → copy the complete state/config set → start the same version on the destination |
| Install a release that cannot open the current state | Back up → `uninstall --purge` → update the retained binary → `install --now` → reconfigure |

The updater validates release metadata, checksums, and signatures. It has no
hard-coded minimum version and does not decide whether stored data is
compatible. Read the target release notes and preserve a rollback copy first.

<a id="backup"></a>
## Prepare a backup you can restore

Use this section for routine backups without proceeding to upgrade or purge. These commands assume the default systemd installation.
Include actual custom database paths, external KEK, certificates, license, and other persistent directories when configured.
The backup briefly stops this node's traffic: schedule maintenance or move traffic first and check free disk space.

```sh
tiyi --version
sudo systemctl cat tiyi
TIYI_BACKUP_ID=$(date -u +%Y%m%dT%H%M%SZ)
sudo install -d -m 0700 /var/backups/tiyi
sudo systemctl stop tiyi
sudo tar --xattrs --acls -C / \
  -czf "/var/backups/tiyi/tiyi-${TIYI_BACKUP_ID}.tar.gz" \
  var/lib/tiyi etc/tiyi etc/systemd/system/tiyi.service usr/local/bin/tiyi
sudo tar -tzf "/var/backups/tiyi/tiyi-${TIYI_BACKUP_ID}.tar.gz" >/dev/null
sudo systemctl start tiyi
sudo tiyi system health
```

Both archive commands should succeed. After the service is healthy, copy the archive to separate restricted storage and record the actual binary version, configuration paths, and time.
It contains private keys and account data; keep it out of ordinary support attachments. If archiving fails, resume the original service, fix disk/path problems, and stop the upgrade.
Rehearse [restoration on another host](#restore) with the matching binary and complete state; verify login, sites, certificates, and requests.
Do not run two independently restored Controllers on the same application ingress. A site JSON export or a live copy of `state.db` alone is not this backup.

## Routine signed update

Complete the [backup](#backup) first and review target state/Agent compatibility. Run one update command; replace the default with `sudo tiyi update --yes --mirror gitee` to force Gitee.

For a release whose state and Agent protocol are compatible:

```sh
tiyi --version
sudo tiyi update --check
sudo tiyi update --yes  # GitHub, with Gitee fallback
sudo systemctl restart tiyi
tiyi --version
sudo tiyi system health
sudo journalctl -u tiyi -b -n 200 --no-pager
```

`update` atomically replaces `/usr/local/bin/tiyi` after verification. It does
not restart the running process.

## Incompatible-state update

Run `sudo tiyi update --check` first to inspect the target. `update` selects
the latest release in the current channel; it has no `--version` option.
Use the update below only when that target is the version you reviewed. To pin
v3.8.0 after a newer release exists, first follow the [offline download and
signature verification steps](installation.md) for the correct architecture.
After backup/purge, replace `update --yes` below with
`sudo install -m 0755 tiyi-release/tiyi /usr/local/bin/tiyi`, verify the version,
then install the service.

v3.8.0 cannot open state created by v3.7.2 or earlier releases. For this
transition, keep the old installation as an offline rollback archive and start
with empty state and configuration. Do not import the old archive into the new
live paths, and re-enroll every remote Agent after rebuilding the Controller.

### 1. Stop and archive

```sh
tiyi --version
systemctl cat tiyi
sudo systemctl stop tiyi

stamp=$(date -u +%Y%m%dT%H%M%SZ)
sudo install -d -m 0700 /var/backups/tiyi
sudo tar --xattrs --acls -C / \
  -czf "/var/backups/tiyi/tiyi-before-update-${stamp}.tar.gz" \
  var/lib/tiyi \
  etc/tiyi \
  etc/systemd/system/tiyi.service \
  usr/local/bin/tiyi
sudo sha256sum "/var/backups/tiyi/tiyi-before-update-${stamp}.tar.gz"
sudo tar -tzf "/var/backups/tiyi/tiyi-before-update-${stamp}.tar.gz" | head
```

Add customized binary, state, config, license, certificate, and secret paths.
Store the archive and checksum outside the live Tiyi directories. Treat the
archive as a secret: it may contain private keys, passwords, tokens, request
evidence, and personal data.

### 2. Purge, update, and install

`uninstall --purge` removes the service unit, `/var/lib/tiyi`, `/etc/tiyi`, and
service identities. It intentionally keeps `/usr/local/bin/tiyi`, so the old
binary can replace that same file with a verified release:

```sh
sudo /usr/local/bin/tiyi uninstall --purge
sudo /usr/local/bin/tiyi update --yes --mirror gitee
/usr/local/bin/tiyi --version
sudo /usr/local/bin/tiyi doctor --mode run
sudo /usr/local/bin/tiyi install --now
sudo systemctl status tiyi --no-pager
sudo journalctl -u tiyi -b -n 200 --no-pager
sudo /usr/local/bin/tiyi system health
```

If the retained binary has no `update` command, verify the archive, remove only
that exact binary path, then run the public installer. Save the new one-time
administrator password and recreate reviewed sites, policies, certificates,
authentication, trust, SIEM, and alert settings. Re-enroll every remote Agent;
do not restore its previous identity, spool, or bundle cache into v3.8.0.

<a id="restore"></a>
## Move a Controller to another host

Use the exact same Tiyi version on both hosts where possible. A newer version
is safe only when its release notes explicitly state that the stored state is
compatible. Test a copy in isolation before a one-way schema change.

Copy the **whole state directory**, not only `state.db`. `/var/lib/tiyi` may
also contain SQLite WAL files, the default KEK, log/detail partitions, request
evidence, CRS data, release artifacts, generated bundles, and embedded-Agent
identity. Copy `/etc/tiyi` and every externally referenced KEK, license,
certificate, or secret file as well.

### 1. Capture a consistent source

```sh
tiyi --version
systemctl cat tiyi
sudo systemctl stop tiyi
stamp=$(date -u +%Y%m%dT%H%M%SZ)
sudo install -d -m 0700 /var/backups/tiyi
sudo tar --xattrs --acls -C / \
  -czf "/var/backups/tiyi/tiyi-migrate-${stamp}.tar.gz" \
  var/lib/tiyi etc/tiyi
sudo sha256sum "/var/backups/tiyi/tiyi-migrate-${stamp}.tar.gz"
```

Do not restart the source after taking the final archive. Record custom unit
options, drop-ins, and injected environment, then transfer the archive and
checksum over an authenticated channel.

### 2. Restore on a clean destination

Install the same signed binary and create the service identities without
starting the service. Replace `vX.Y.Z` and the archive name with the exact
source values:

```sh
source_tag=vX.Y.Z
archive=/secure/path/tiyi-migrate-YYYYMMDDTHHMMSSZ.tar.gz
curl -fsSL https://www.tiyisec.com/install.sh \
  | TIYI_VERSION="$source_tag" bash
sudo /usr/local/bin/tiyi install

sudo sha256sum "$archive"
sudo tar --xattrs --acls -C / -xzf "$archive"
sudo chown -R tiyi:tiyi /var/lib/tiyi
sudo chgrp -R tiyi /etc/tiyi
sudo chmod -R g+rX /etc/tiyi

sudo /usr/local/bin/tiyi doctor --mode run --fix-state-ownership
sudo /usr/local/bin/tiyi install --now
sudo systemctl status tiyi --no-pager
sudo journalctl -u tiyi -b -n 200 --no-pager
sudo /usr/local/bin/tiyi system health
```

Compare the destination checksum with the recorded source value before
extracting. Recreate reviewed unit customizations and restore external files
before `doctor`; ensure the `tiyi` service user can read them. Then verify
sites, certificates, remote-Agent status, active bundle
revision, `tiyi audit verify`, and the local `/metrics` endpoint.

Never run the source and cloned Controller at the same time: they share the
deployment identity, signing keys, and Agent trust. To roll back, stop the
destination before restarting the unchanged source. Never merge two state
trees after both have accepted writes.

## Diagnose failures

```sh
sudo /usr/local/bin/tiyi doctor --mode run
systemctl status tiyi --no-pager
journalctl -u tiyi -b -n 200 --no-pager
journalctl -u tiyi -f
ss -ltnp
```

- An installer refusal means the new-host installer found an existing binary,
  state, config, or unit. Use an upgrade or migration workflow instead.
- An incompatible-schema error means the target binary cannot open that state.
  Stop it; use the matching binary or restore/reset the intended state.
- `command not found` under `sudo` usually means `secure_path` omits the install
  directory. Use `/usr/local/bin/tiyi` explicitly.
- A failed update leaves the existing binary untouched. Fix mirror, network,
  disk-space, or permissions errors and retry.

For Prometheus setup, see [Operations: Connect Prometheus](operations.md#7-connect-prometheus).
For general diagnostics, see [Troubleshooting](troubleshooting.md).
