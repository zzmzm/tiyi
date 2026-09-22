# Production deployment and administration

For **v3.8.0**. Before replacing a demo with a real application, decide how traffic and administrators reach Tiyi, how much data to retain, and how to recover.
Tiyi sits between clients and origins: point the domain at Tiyi, which proxies accepted requests to your application.

## 1. Choose topology and access boundaries

| Scenario | Deployment | Prepare |
|---|---|---|
| One website or small team | One `tiyi run`, including console and local data plane | Linux, persistent disk, domain/certificate, reachable origin; full Community features |
| Protect an app behind a CDN/load balancer | CDN/LB → Tiyi → origin | Exact proxy trust chain and expected ingress sources |
| Multiple regions or entry nodes | One Controller with remote Agents | Reachable HTTPS management URL, licensed remote-node capacity, matching versions |
| Offline/internal network | Install signed files offline | Uploaded certificates, offline Geo data, reachable internal origins, backups |

There is one writable Controller, with no built-in leader election or automatic control-plane failover.
Remote Agents continue using their last accepted configuration while the Controller is unavailable, but receive no new configuration; administration, enrollment, and central views are unavailable.
Account for this in recovery planning. CPU, memory, and disk needs depend on traffic, rules, body/upload limits, and retained evidence; measure your workload instead of treating a demo as a capacity claim.

## 2. Protect management access and state

Start from the [copyable configuration](configuration.md#startup): management listens on `0.0.0.0:8080`, and websites use 80/443.
For initial access, open `http://SERVER_IP:8080` in your browser. For team HTTPS access, proxy the management listener through your existing HTTPS gateway,
or create a dedicated HTTPS Tiyi site with origin `http://127.0.0.1:8080`.
Obtain a covering certificate first, verify login, refresh, and long-lived connections, then allow only intended management networks. Set `auth.refresh_cookie_secure: true`.
See [HTTPS operations](operations.md#https); retain SSH and the local socket for recovery.

Keep `/var/lib/tiyi` on persistent disk. Upload spooling needs writable disk storage; tmpfs is not a substitute for all persistent paths.
Set a stable JWT secret and preserve `kek.bin` with its database; do not recreate or lose the KEK.
The systemd `tiyi` user must read configuration/secrets and write state. Do not edit SQLite, generated Caddy configuration, or Agent identity files directly.

<a id="client-ip"></a>
## 3. Behind a CDN or proxy

Direct deployments use the connection peer as the client. Behind a CDN/LB, configure the actual chain in **Protection → Client IP**:
create or enable a list of trusted proxy egress addresses, then select the verified forwarded header.
Do not trust arbitrary clients' `X-Forwarded-For`. A manual address-list starter for the list editor or CLI replace file is:

```text
# Replace with the actual proxy egress networks
192.0.2.10/32
2001:db8:10::/48
```

These are documentation networks; replace them with real proxy egress ranges. Trust lists must be nonempty and use permanent entries; TTL entries are not supported for proxy trust.
Provider subscriptions such as Cloudflare start paused; inspect the source and parsed entries before enabling.
Failed subscription updates retain the last accepted snapshot; investigate protected-update states.
Read `sudo tiyi trust show` and use `tiyi trust test --help` to test peer/header combinations, then verify the resolved client IP on real requests.
IP controls, country controls, and rate limits depend on that value.

<a id="nodes"></a>
## 4. Add remote nodes

Community includes the local node and zero remote nodes. Import a signed license under **System Administration → About** or configure `license.key_path` first.
Use a Controller HTTPS URL reachable from the remote hosts and the same v3.8.0 build on all nodes. Every serving node must reach its origins.
`/download/tiyi` serves the Controller's own platform binary, so use the generated script on a matching OS/architecture.

Under **Nodes → Install**, choose the reachable URL, tags, expiry, and node count, then generate the installation command.
Run the recommended systemd command on the target. The page tracks this enrollment and configuration result; you do not need to assemble token files by hand.
Generate the installation command on the Controller host:

```sh
sudo tiyi agents install-command --controller-url https://tiyi.example.com \
  --tag edge --ttl-seconds 3600 --max-nodes 1
```

Copy the output and execute it on the target node, not on the Controller. It contains short-lived installation credentials; keep it private.
Add `--json` to review full scripts and expiry, or `--foreground` for foreground startup.
After enrollment, run `sudo tiyi agents list` and verify online status, applied configuration, origin health, and a real site request to that node.
Online alone does not prove service. Distinguish offline from online with application failures.
For a different architecture, prepare the correct signed binary for the same version and follow the advanced foreground/service instructions.
Crossing from older releases to v3.8.0 requires [fresh state and re-enrollment](upgrade-migration.md), not an ordinary rolling update.

Saving a site publishes its configuration to the built-in node and all enrolled nodes; offline nodes receive it on reconnect. Node groups organize the fleet and related operations; they do not automatically restrict a site to one group. Every receiving node needs access to the configured origins.

## 5. Users, roles, and single sign-on

Use **System Administration → Users / Roles / Authentication** for accounts, permissions, LDAP/AD, RADIUS, OIDC, SAML, and TOTP MFA.
Keep a tested local-administrator recovery path. External authentication proves identity; prepare matching users and roles instead of assuming it grants arbitrary access.
The [tiyi.yaml template](templates/tiyi.yaml) includes LDAP/RADIUS startup settings.
For browser OIDC/SAML, configure the provider's issuer/metadata, client, and callback information in Authentication settings.
Register the exact callback URL shown by the console and test a fresh browser session; do not guess it from an unrelated example.
Use operator or read-only roles for daily tasks. See [permissions](../reference/permissions.md) for automation, and keep MFA recovery codes offline.

## 6. Logs, alerts, external systems, and backups

Check request/block counters in Overview and retained samples/evidence in Logs. Detailed logs are not guaranteed to retain every request indefinitely.
Choose retention, sampling, and realistic disk limits under **System Administration → Settings → Logs & Evidence**.
Request evidence can contain raw cookies, authorization headers, and bodies; restrict read access and retention.
Configure [notifications](operations.md) with real destinations. SIEM sends from the traffic-producing nodes; verify each node can reach its destination.
Use the [metrics-only Prometheus setup](operations.md#prometheus). `/healthz` is liveness only; use `sudo tiyi system health` or local `/readyz` for deeper health.

AI Copilot is off by default. If enabled, configure a provider and decide which investigation data may be sent; output remains advisory.
Back up the complete state directory, config/environment files, KEK, certificates, license, and a matching old binary.
Use a consistent cold backup and actually rehearse [restore/migration](upgrade-migration.md).
