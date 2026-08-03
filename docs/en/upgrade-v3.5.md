# Upgrade an existing Tiyi installation to v3.5.0

Tiyi v3.5.0 requires a **complete uninstall and clean installation** when the
host already ran v3.4.0 or any earlier release. This is not an in-place state
migration. The procedure intentionally deletes the old Controller database,
logs, KEK, certificates, configuration, service unit, and service identities.

> **Destructive and irreversible:** `sudo tiyi uninstall --purge` removes all
> Tiyi history and configuration under `/var/lib/tiyi` and `/etc/tiyi`. It also
> removes the systemd unit and the `tiyi`/`tiyi-admin` service identities. If
> anything must be kept, record or export it and complete the backup below
> before continuing. This guide does not provide a rollback procedure.

## Why `update` followed by restart fails

`sudo tiyi update --yes --mirror gitee` correctly downloads, verifies, and replaces
the on-disk binary, but it does not restart the running service or make old
state compatible.

The published v3.4.0 state is rejected by v3.5.0 at restart with an error such
as:

```text
store: migration 0016_telemetry_rollups.sql sha256 drift ...
```

Earlier state can instead fail with:

```text
store: clean-break state reset required (schema=..., minimum=47) ...
```

Do not retry the restart loop and do not copy the old database back. Fully
remove the old installation, then create new v3.5.0 state.

## 1. Record anything that must be recreated

Before the purge, record only the configuration you intend to recreate:

```sh
tiyi version
sudo systemctl status tiyi --no-pager
sudo systemctl cat tiyi
sudo tiyi site list
sudo tiyi upstream list
sudo tiyi policy list
sudo tiyi cert list
sudo tiyi agents list
sudo tiyi user list
```

Also record custom listener addresses, DNS, upstream endpoints, WAF tuning,
certificate source files, license location, identity-provider settings, SIEM
destinations, and remote-Agent names. Do not paste passwords, private keys,
tokens, KEKs, license contents, or captured request data into tickets or chat.

All old events, traffic history, audit history, users, policies, uploaded
certificates, Agent enrollment, and locally stored secrets are deleted by the
purge in step 3.

## 2. Back up the complete old installation

Stop the service before copying the SQLite state and its related files. The
following default-path example keeps state, configuration, and the unit
definition together:

```sh
TIYI_BACKUP_DIR="/var/backups/tiyi-pre-v3.5-$(date +%Y%m%d-%H%M%S)"

sudo systemctl stop tiyi
sudo install -d -m 0700 \
  "$TIYI_BACKUP_DIR/state" "$TIYI_BACKUP_DIR/config"
sudo cp -a /var/lib/tiyi/. "$TIYI_BACKUP_DIR/state/"
sudo cp -a /etc/tiyi/. "$TIYI_BACKUP_DIR/config/"
sudo systemctl cat tiyi | sudo tee "$TIYI_BACKUP_DIR/tiyi.service" >/dev/null

sudo test -f "$TIYI_BACKUP_DIR/state/state.db"
sudo ls -ld "$TIYI_BACKUP_DIR"
```

If `store.state_db`, `crypto.kek_file`, certificate sources, license, log
partitions, configuration, or service environment files use custom paths, add
those exact paths to the backup and verify them before continuing.

This backup contains credentials and unredacted operational history. Restrict
it to root, encrypt it at rest, and move it to operator-controlled storage. It
is for historical retention and manual reconstruction; never copy its old
`state.db` or log partitions into the v3.5.0 state directory.

## 3. Completely uninstall the old version

Run the interactive purge with the currently installed binary:

```sh
sudo tiyi uninstall --purge
```

Read the warning and type `yes` only after accepting total data loss. Do not add
`--yes` to automation: this upgrade requires an explicit destructive decision.

After completion, these items are gone:

- `tiyi.service` and its systemd enablement;
- `/var/lib/tiyi`, including `state.db`, logs, KEK material, uploaded assets,
  and generated runtime state;
- `/etc/tiyi`, including YAML configuration and protected environment files;
- the `tiyi` service user/group and `tiyi-admin` socket group.

The binary itself remains installed. Because the unit has been removed,
`sudo systemctl restart tiyi` is **not** the next command.

## 4. Install the signed v3.5.0 binary

Use the Gitee mirror:

```sh
curl -fsSL https://gitee.com/tiyisec/tiyi/raw/main/install.sh \
  | TIYI_MIRROR=gitee TIYI_VERSION=v3.5.0 bash
tiyi version
```

Or use the canonical site/GitHub path:

```sh
curl -fsSL https://www.tiyisec.com/install.sh \
  | TIYI_VERSION=v3.5.0 bash
tiyi version
```

The version output must report `v3.5.0`. If `tiyi update` already replaced the
binary and `tiyi version` already reports `v3.5.0`, the download may be skipped;
the purge and clean service installation are still required.

## 5. Create and start a fresh service

Preview the new unit, then install and start it:

```sh
tiyi doctor --no-color
tiyi install --print
sudo tiyi install --now
sudo systemctl status tiyi --no-pager
sudo tiyi system health
```

`tiyi install --now` recreates the service identities, configuration/state
directories, hardened systemd unit, and fresh Controller database. It also
prints the new one-time administrator password. Store that password securely;
the old users and passwords no longer exist.

If custom ports or a custom config are required, recreate them before exposing
production traffic and run `tiyi doctor` again.

## 6. Recreate configuration and re-enroll Agents

Recreate sites, upstream pools, certificates, WAF policies, users/RBAC, alert
channels, SIEM targets, identity providers, and license configuration through
the supported Web UI or CLI. Do not restore the old `state.db` or old log
partitions.

The fresh Controller has a new identity and signing state. Every remote Agent
must be enrolled again:

1. Open **Agent Fleet → Nodes → Install**.
2. Issue a new one-use token.
3. Completely remove the old Agent service/state on its host if it still uses
   the old release.
4. Follow the newly generated v3.5.0 Agent install command.
5. Confirm the Agent is online and has applied the current revision/hash.

Never reuse an old enrollment token, identity marker, or cached bundle.

## 7. Acceptance checks

Complete all checks before returning traffic:

1. `tiyi version` reports `v3.5.0`.
2. `systemctl status tiyi` is active and `tiyi system health` is healthy.
3. The new administrator can sign in and change the one-time password.
4. Every site routes a benign Host/SNI request to the correct upstream.
5. A controlled CRS probe is blocked with a non-empty response.
6. TLS certificates are valid and bound to the intended sites.
7. Request/block counters and lookup by `X-Request-Id` work.
8. Every remote Agent is freshly enrolled, online, and on the expected
   revision.
9. Audit-chain and log-pipeline health show no unexpected failures.

If service startup still fails, collect `systemctl status tiyi` and
`journalctl -u tiyi -n 200 --no-pager`. Do not run another purge until the new
failure has been identified.
