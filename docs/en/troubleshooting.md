# Troubleshooting

Diagnose from the outside in: process, listener, site match, route, WAF, then
upstream. Change one layer at a time and keep the failing request ID.

## First five minutes

```sh
tiyi doctor
systemctl status tiyi --no-pager
journalctl -u tiyi -n 200 --no-pager
ss -ltnp
tiyi system health
```

For an agent, use `tiyi-agent` as the unit name. For a manual foreground run,
inspect the terminal and the paths supplied on the command line.

## The dashboard does not open

- Confirm the configured `server.addr` listener and host firewall.
- A proxy listener on 80/443 is not the dashboard listener (default 8080).
- Run `tiyi doctor` for port conflicts and config errors.
- If a systemd service cannot write its state tree, use
  `sudo tiyi doctor --fix-state-ownership` after reviewing the reported path.

## The bootstrap password was lost

Do **not** delete `state.db`. The first password is printed once by design. Use
the local admin socket on the Tiyi host to reset the existing account:

```sh
sudo tiyi user list
sudo tiyi user reset-password <user-id> --password '<new-strong-password>'
```

If a custom admin socket is configured, pass its path. Socket filesystem
permissions are the local authentication boundary.

## Requests miss the site or return the wrong upstream

```sh
curl -v -H 'Host: app.example.com' http://127.0.0.1/
tiyi site list
tiyi upstream list
```

Check the Host header (including port normalization), listener, site enabled
state, longest-prefix path route, upstream scheme/port, and health probe. A
browser request to an IP without the configured Host is not a valid site test.

## Expected attacks are not blocked

- Confirm the request reached the intended site and WAF is enabled.
- Check effective policy, engine state, paranoia level, thresholds, bypasses,
  IP-list precedence, and path-scoped overrides.
- Search **Security Events** and **Attack Logs** by request ID and rule ID.
- Test with an untrusted source; a global/site allow or bypass can be decisive.
- Preview compiled policy before changing it.

## TLS or ACME fails

Check DNS, public reachability, port 80 for HTTP-01, certificate binding, clock,
and ACME order details. DNS-01 requires a supported provider and correctly
scoped credentials. Never paste provider secrets into an issue or support
bundle.

## Agent is offline or will not apply

- Compare the server URL, enrollment expiry, clock, DNS, and network path.
- Read both server and agent journals around the same timestamp.
- Distinguish offline, rejected identity/protocol, signature failure, and apply
  failure.
- When the target release changes identity or protocol contracts, re-enroll the
  Agent; never force an incompatible identity, spool, or bundle cache.
- Confirm the applied revision/hash after reconnect, not only online state.

## Installer refuses the host or startup rejects state

The public installer is for a clean host and refuses an existing binary, state
database, configuration, or systemd unit. Runtime rejects state whose schema or
migration ledger is incompatible with the running binary.

Do not edit migration metadata. Follow the
[upgrade and migration guide](upgrade-migration.md) to select a compatible
binary/state pair, move a complete installation, or use the documented purge
flow. State created before v3.6.0 requires the purge flow when moving to
v3.6.0.

## Counters exist but evidence or SIEM is late

Open **System Monitoring → Log Pipeline** and inspect queue depth, drops,
retries, and panic counters. Request Evidence adds local/store/upload lanes;
direct SIEM adds raw-source and per-destination lanes. Exact traffic counters,
immutable SecurityFacts, retained evidence, and SIEM delivery are independent.
Test the destination from the producing node and fix the consumer without
restarting a healthy data plane unless diagnostics require it.

## Collect a safe support bundle

Include version, mode, sanitized config, unit definition, health output,
`tiyi doctor`, recent relevant journals, site/upstream IDs, timestamp/timezone,
and request ID. Remove JWTs, passwords, enrollment tokens, private keys, DNS
credentials, cookies, and sensitive request bodies.
