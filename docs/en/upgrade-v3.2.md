# Move a development or test installation to v3.2

Tiyi v3.2 introduces the observation-v2 storage and agent protocol. The project
has no supported production upgrade population yet, so this release deliberately
uses a clean-state cutover instead of carrying legacy observation data forward.

## What must be reset

- A v3.1 (or older) `state.db` is rejected at startup.
- Existing agent identity markers and cached configuration bundles are rejected.
- Historical detail databases and spool files are not imported into v3.2.

Configuration should be recreated from declarative manifests or the Web UI.
Keep any source YAML, certificates, license file, and KEK that you need before
removing the old test state.

## Standalone or server

```sh
sudo systemctl stop tiyi

# Development/test data only. Back it up if you need it for analysis.
sudo mv /var/lib/tiyi /var/lib/tiyi.pre-v3.2
sudo install -d -m 0750 /var/lib/tiyi

sudo tiyi install --now
sudo systemctl status tiyi --no-pager
tiyi system health
```

If you use custom paths, move the configured state database, observation/detail
directories, and local spools instead of `/var/lib/tiyi`. Do not copy the old
database back after v3.2 starts.

## Agents

Reset each development/test agent's local identity and observation state, then
issue a new enrollment token from the v3.2 server and enroll it again. The exact
paths are shown in the installed unit/config; inspect them before removal:

```sh
systemctl cat tiyi-agent
sudo journalctl -u tiyi-agent -n 100 --no-pager
```

After re-enrollment, confirm that the agent is online and has applied the latest
revision in **Fleet → Agents** or with `tiyi agents list`.

## Acceptance checks

1. `tiyi --version` reports `v3.2.0`.
2. `tiyi system health` is healthy.
3. Create a site and send one normal request plus one CRS test request.
4. Confirm exact request/blocked counters, a security finding, and cross-stream
   lookup by `X-Request-Id`.
5. Confirm every remote agent is online and no old-format error remains in its
   journal.

