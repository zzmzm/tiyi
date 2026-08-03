# Move an older installation to Tiyi v3.4.0

> Upgrading to v3.5.0 instead? Do not use this historical procedure. v3.5.0
> requires a [complete uninstall and clean installation](upgrade-v3.5.md),
> including from the published v3.4.0 release.

Tiyi v3.4.0 is a clean-break single-Controller release. It deliberately
rejects state databases below schema 47 instead of guessing how to translate
legacy Controller roles, local-Agent identity, replication state, or older
configuration delivery records.

## Preserve before resetting

Export or save the source manifests for sites, upstreams, policies, users, and
secrets that you need to recreate. Back up uploaded certificate sources, the
license file, and the KEK with the old state. The archived database is a
rollback/analysis artifact only; v3.4.0 cannot open it.

## Controller

```sh
sudo systemctl stop tiyi

# Keep the old state intact. Use your configured state path if it differs.
sudo mv /var/lib/tiyi /var/lib/tiyi.pre-v3.4
sudo install -d -m 0750 /var/lib/tiyi

sudo tiyi install --now
sudo systemctl status tiyi --no-pager
tiyi system health
```

Do not copy the old `state.db`, observation/detail partitions, identity marker,
or cached bundle into the fresh directory.

## Remote Agents

Remove each old development/test Agent identity and cached bundle state only
after confirming its actual paths from the unit/config. Then open
**Nodes → Install**, issue a new one-use token, and re-enroll against the single
stable Controller URL.

```sh
systemctl cat tiyi-agent
sudo journalctl -u tiyi-agent -n 100 --no-pager
```

## Acceptance checks

1. `tiyi --version` reports `v3.4.0`.
2. `tiyi system health` is healthy and Nodes shows the built-in local node.
3. Recreate one site and send one benign request plus one CRS test request.
4. Confirm exact request/blocked counters and lookup by `X-Request-Id`.
5. Confirm every remote Agent is online and has applied the current revision.
