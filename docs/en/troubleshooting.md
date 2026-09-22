# Troubleshooting

Diagnose from the outside in: process, listener, site match, route, WAF, then
upstream. Change one layer at a time and keep the failing request ID.

## Start with the symptom

| Symptom | First check | Next action |
|---|---|---|
| `sudo: tiyi: command not found` | `/usr/local/bin/tiyi --version` | Use `sudo /usr/local/bin/tiyi …` and check sudo PATH |
| `address already in use` | `sudo ss -ltnp` and `sudo tiyi doctor` | Identify the owner and follow [port configuration](configuration.md#ports); do not stop an unknown application |
| No 443 listener after installation | Enabled TLS site and certificate | Complete [HTTPS setup](operations.md#https); the console alone does not create an HTTPS website |
| The console does not open | Server IP, management listener, firewall/security group | Open `http://SERVER_IP:8080`; use `sudo ss -ltnp` to check the default `0.0.0.0:8080` listener and verify port 8080 is reachable |
| Local CLI says `permission denied` | Admin socket permissions | Use sudo for the system service or the actual socket path for a foreground instance |
| Website returns 421 | Host matching an active site | Use the real domain or `curl -H 'Host: …'`; a bare-IP request is different |
| Website returns 502 | Origin reachability from the serving node | Check the origin process, address, port, protocol, and probes |
| Website returns 403 / 413 / 503 | Request ID, enforcement reason, and origin response | Identify the actual rule, limit, overload, or application response; status alone does not identify the source |
| Saved configuration has no effect | Node application results and actual request path | Check site, policy, node, and publication failures, then retry |

## First five minutes

```sh
sudo tiyi doctor
sudo systemctl status tiyi --no-pager
sudo journalctl -u tiyi -n 200 --no-pager
sudo ss -ltnp
sudo tiyi system health
```

For an agent, use `tiyi-agent` as the unit name. For a manual foreground run,
inspect the terminal and the paths supplied on the command line.

## The dashboard does not open

- Confirm the configured `server.addr` listener and host firewall.
- A proxy listener on 80/443 is not the dashboard listener (default 8080).
- Run `tiyi doctor` for port conflicts and config errors.
- If a systemd service cannot write its state tree, use
  `sudo tiyi doctor --fix-state-ownership` after reviewing the reported path.

<a id="reset-password"></a>
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
sudo tiyi site list
sudo tiyi upstream list
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

## A request gets a Tiyi 503 or bypasses CRS

Check `X-Tiyi-Enforcement-Reason` and **Logs → Enforcement**. A causal WAF CPU
reject is `cpu_overload_reject`; a CRS-only degradation is
`cpu_overload_bypass`. An origin 503 has neither decision. Review the affected
node's WAF pressure trend and `/debug/wafoverload/stats` on the protected local
admin socket before changing thresholds. Observation backlog or telemetry gaps
do not trigger WAF overload.

## Bot challenge or IP subscription fails

- Bot protection requires an HTTPS-only site. Check certificate binding,
  browser cookie/storage policy, system time, exempt paths, and trusted-list
  references. Human verification additionally requires WebAuthn support and a
  user gesture.
- For an IP subscription, inspect sync history, HTTP status, response limits,
  parser/JSONPath output, deletion-ratio hold, and consumer compile result. The
  prior accepted snapshot stays active when an update is protected.

## Installer refuses the host or startup rejects state

The public installer is for a clean host and refuses an existing binary, state
database, configuration, or systemd unit. Runtime rejects state whose schema or
migration ledger is incompatible with the running binary.

Do not edit migration metadata. Follow the
[upgrade and migration guide](upgrade-migration.md) to select a compatible
binary/state pair, move a complete installation, or use the documented purge
flow. v3.8.0 cannot open state created by v3.7.2 or earlier releases and
requires the documented purge and remote-Agent re-enrollment flow.

## Counters exist but evidence or SIEM is late

Open **System Monitoring → Log Pipeline** and inspect queue depth, drops,
retries, and panic counters. Request Evidence adds local/store/upload lanes;
direct SIEM adds raw-source and per-destination lanes. Exact traffic counters,
bounded SecurityFact samples, retained evidence, and SIEM delivery are independent.
Test the destination from the producing node and fix the consumer without
restarting a healthy data plane unless diagnostics require it.

## Console recovery and slow diagnostic output

If session recovery is temporarily unavailable, use the retry page after checking connectivity and component health. A temporary read failure does not prove the session has expired. Preserve settings drafts until the save/application result is known.

On the Controller host, inspect bounded diagnostic output and management latency through the protected local socket:

```sh
sudo curl -fsS --unix-socket /run/tiyi/admin.sock http://tiyi.local/debug/runtime/stats
sudo tiyi system health
```

Use the actual socket path for a custom instance. Check the journal/output consumer and storage pressure; diagnostics can drop whole records when full, with counters, while durable audit and security records use separate paths. Do not expose the admin socket over the network to collect diagnostics.

## Collect a safe support bundle

Include version, mode, sanitized config, unit definition, health output,
`tiyi doctor`, recent relevant journals, site/upstream IDs, timestamp/timezone,
and request ID. Remove JWTs, passwords, enrollment tokens, private keys, DNS
credentials, cookies, and sensitive request bodies.

## API / configuration file problems

| Symptom | Check |
|---|---|
| Site import says invalid JSON | Use [site-import.json](templates/site-import.json), not apply YAML or OpenAPI. |
| Apply says unknown field or unsupported reference | Use [apply templates](configuration.md); Bot trusted IP-list name references are not currently resolved by apply. Bind the list in the site UI after creation. |
| API document reports `invalid_oas` | Use the [OpenAPI starter](api-protection.md). Root mapping is `basePath: ""`, not `/`; avoid duplicate base-path prefixes. |
| Document saved but traffic unchanged | Check publication and serving-node results; uploading or saving a draft does not apply it. |
| No violation samples | Counters and retained samples are separate. Enable Schema violation sampling deliberately in log policy when needed; it is off by default. |
| CLI cannot reach a custom instance | Supply the actual `--admin-socket` path, or `TIYI_API` and `TIYI_TOKEN`. `auth login` does not save a CLI session. |
