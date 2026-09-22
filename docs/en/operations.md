# Operations guide

This page follows the normal operator loop: publish, observe, investigate,
tune, and verify. Run local CLI commands on the Tiyi host with sudo; omit sudo and add `--api URL
--token JWT` when operating remotely.

Choose a task: [Wildcard hosts](#wildcard-hosts) · [HTTPS](#https) · [WAF tuning](#tuning) · [Notifications](#notifications) · [Monitoring](#prometheus) · [Backup and recovery](upgrade-migration.md#backup). For guided exercises on a demo, use [practice and advanced use](practice.md).

## 1. Publish an application

Start the backend, create a site, and test routing before changing DNS:

```sh
sudo tiyi site create \
  --name shop \
  --host shop.example.com \
  --upstream-url http://10.0.0.20:9000 \
  --tls none

curl -i -H 'Host: shop.example.com' http://127.0.0.1/
sudo tiyi site list
```

A newly created site is active immediately. The one-step form creates the
inline upstream and uses the built-in Light policy. Light keeps attack blocking enabled while logging ordinary argument/body-size excess and treating MIME/parser mismatches as compatibility observations. Upload, Schema, and other resource guards retain their independent controls. Use **Application
Delivery → Sites** for TLS, path routes, health state, and per-site security
overrides. Use an uploaded certificate or managed ACME before changing public
DNS to the Tiyi listener.

For one hostname with several applications, configure longest-prefix path
routes (for example `/api/` and `/static/`) and keep a fallback route. Probe
each route after saving.

<a id="wildcard-hosts"></a>
### Use a wildcard hostname

In **Sites → Create / Edit**, both **Primary Host** and **Aliases** accept
`*.example.com`. Enter hostnames without a scheme, port, or path; separate UI
aliases with commas. The wildcard replaces exactly one subdomain label:

| Request hostname | Matches `*.example.com`? |
|---|---|
| `www.example.com`, `api.example.com` | Yes |
| `example.com` | No; add it separately as a primary host or alias |
| `a.b.example.com` | No; add that exact host or a separate `*.b.example.com` pattern |

For a separate new site, this example serves the wildcard and root domain and
explicitly registers `api.example.com` for API configuration. Replace the
domain, site name, and origin URL with your own values:

```sh
sudo tiyi site create --name wildcard-app \
  --host '*.example.com' --alias example.com --alias api.example.com \
  --upstream-url http://10.0.0.20:9000 --tls none
curl -i -H 'Host: api.example.com' http://127.0.0.1/
```

Quote `*.example.com` in shell commands so the shell does not expand `*` into
local filenames. Before public access, point the actual hostnames or a wildcard
DNS record at Tiyi. Saving a site does not create DNS records.

For **HTTPS**, first obtain a certificate covering the wildcard and every
configured alias. A certificate for `*.example.com` alone does not cover
`example.com` or `a.b.example.com`. Upload an existing certificate, or use
**DNS-01** for ACME wildcard issuance; HTTP-01 cannot issue a wildcard
certificate. Configure the supported Cloudflare DNS Provider before requesting
DNS-01 issuance. Bind the covering certificate, then enable HTTPS as described
[below](#https). HTTP hostname matching itself does not require ACME or DNS-01.

For **OpenAPI import and request validation**, first add each concrete API
hostname, such as `api.example.com`, as the primary host or an alias, then use
that exact hostname in the mapping. A wildcard can route requests but does not
automatically create concrete API bindings or apply Schema validation to every
matching subdomain. Follow the [API protection guide](api-protection.md).

<a id="https"></a>
### Enable HTTPS for a real site

Replace `app.example.com` with your domain. HTTP-01 requires its A/AAAA records to point to Tiyi and public port 80 to be reachable.
Check DNS and the firewall before requesting a certificate. Take IDs from list output:

```sh
sudo tiyi cert issue app.example.com --email admin@example.com
sudo tiyi cert list
sudo tiyi site list
SITE_ID='replace-with-site-id'
CERT_ID='replace-with-issued-certificate-id'
sudo tiyi site update "$SITE_ID" --tls managed-acme --tls-cert-id "$CERT_ID" \
  --tls-http-behavior redirect
curl -i --resolve app.example.com:443:127.0.0.1 https://app.example.com/
```

Bind only after issuance succeeds and the certificate covers all site hostnames. For an existing enterprise certificate use
`sudo tiyi cert upload --name app-cert --cert-pem cert.pem --key-pem key.pem`, then bind with `--tls uploaded`.
Supply intermediates with repeated `--chain-pem`. ACME wildcard certificate issuance needs DNS-01: configure a supported Cloudflare DNS Provider in the certificate UI,
then check credential scope, challenge type, and domain coverage. Uploaded certificates need your renewal process; managed certificates renew automatically.

### Multiple origins and path routes

This creates a two-backend pool and routes `/api` to it. Replace addresses and IDs with your values.
Both backends must answer `/healthz` with 200; submission checks connectivity and probes:

```sh
sudo tiyi upstream create --name api-pool \
  --endpoint-url http://10.0.0.20:9000 --endpoint-url http://10.0.0.21:9000 \
  --health-check-path /healthz --health-expected-status 200
sudo tiyi upstream list
sudo tiyi site routing get SITE_ID
sudo tiyi site routing set SITE_ID --route /api=UPSTREAM_ID --unmatched default
```

`routing set` replaces the complete routing table. Save `routing get` first and include every route you intend to keep.
The longest segment-bounded prefix wins: `/api` does not match `/apix`. Paths are preserved by default;
use `--route /api=UPSTREAM_ID:strip` when the origin expects the prefix removed.
`--unmatched default` requires a default site upstream; `--unmatched 404` rejects unmatched paths.
Test every route and the unmatched case. Review health on all serving nodes; unknown or stale reports are not healthy results.

### Site migration and repeatable setup

Use [site import/export JSON](site-import.md) or [declarative YAML](configuration.md#apply).
Follow the [API protection walkthrough](api-protection.md) for application APIs; do not put OpenAPI into startup configuration.

## 2. Establish a baseline

Use **Overview** to select a site and time range. Read the protection chain
first — Bot gate → rate/challenge → IP/country → resource guards → WAF/CRS →
origin — then check request rate, terminated totals, status classes, top
attackers, normalized URL Top, and fixed UA classes. The Bot stage opens
**Logs → Bot Analytics**; other stages open **Logs → Enforcement** already
filtered. Use **Application Delivery → API Assets** for discovered assets.

The observation pipeline has four independent truth planes:

- exact hot-path traffic and block counters;
- immutable compact `SecurityFact` records for direct investigation;
- optional retained detail and Request Evidence under independent policy,
  retention, and storage quotas;
- producer-direct SIEM delivery with one bounded queue per destination.

Check **System Monitoring → Log Pipeline** when a consumer falls behind. A slow SIEM
must not change exact counters or block proxy requests.

### Read exact counts and sampled investigation correctly

Overview security rankings, Enforcement and threshold alerts use counters collected before sampling. Event Analysis uses retained samples for relationship pivots; do not use its associations as full traffic totals. Keep the same site, time range and IP when moving into Enforcement. A limited dimension shows lost coverage and cannot prove that a missing entity had no activity.

Automatic remediation respects attack-type and severity filters. IP quick actions report saved and applied states separately, retain the same operation when retried, and support withdrawal. Check remote-node deployment results before concluding a block is active everywhere.

### Request Evidence and direct SIEM

Fresh installations default Request Evidence to `security_only`. Configure the global policy under
**System Administration → Settings → Global logging & evidence policy**, then
optionally override a site from its **Logging & evidence** drawer.
`security_only` retains evidence for requests that produced a SecurityFact;
`retained_logs` attaches it to retained Attack/Access rows. Captured Cookie,
Authorization, API keys, personal data, and bodies are intentionally
unredacted. Restrict log-read access and use short retention. The in-console
preview starts with an HTTP-style request line (method, exact target, client
HTTP version), then Host and captured headers.

Configure destinations under **System Administration → Settings → SIEM**. Each
target independently selects native Caddy access JSON, native Coraza audit
JSON, or Tiyi-formatted events over UDP/TCP/TLS. Queue-full and network errors
drop only that target's event and increment its pipeline lane; they never
delay a WAF response.

## 3. Investigate an alert

1. Open **Alerts & Notifications → Alert Center** and follow the evidence link.
2. Pin the site and time range. Copy the `X-Request-Id` / unique request ID.
3. Use **Logs → Security Events** to pivot bounded facts by
   attacker, attack type, or target.
4. Open the matching **Attack Logs** row, then correlate Access and Runtime
   Error rows by request ID.
5. Load Request Evidence only when authorized and needed; treat Geo/ASN as
   advisory network-exit metadata.
6. Acknowledge, add a note, then resolve only after the cause or safe
   mitigation is verified.

AI enrichment is optional, default-off, structured, and advisory. Never apply
an AI suggestion without checking the retained evidence and compiled policy.

## 4. Tune safely

Prefer the narrowest change:

1. reproduce and identify the rule, path, site, and client class;
2. preview the effective policy or use the UI diff;
3. use log-only/canary behavior where the feature supports it;
4. scope an exclusion to the exact site/path/rule;
5. send both malicious and legitimate regression requests;
6. monitor blocked rate, status codes, SecurityFacts, and attack logs after
   apply.

An IP allow list is not a substitute for a rule exclusion. A WAF bypass skips
remaining inspection and should be restricted more tightly than a normal
per-rule pass.

### v3.7 adaptive controls

- Configure **Protection → IP Lists** subscriptions as untrusted inputs: preview
  parser output, bind only an accepted snapshot, and investigate an **Update
  protected** hold instead of bypassing empty, oversized, or invalid results.
  Use **Protection → Country Access** for country policy; `geo:*` is not an
  IP-list entry.
- Configure site-wide **Bot protection** only on HTTPS-only sites. Start with
  browser check, exempt only narrow health/login callbacks, and reserve human
  verification for flows where a private WebAuthn device gesture is acceptable.
- Under **System Administration → Settings → WAF overload**, keep **Continue
  full inspection** unless the service has an explicit availability policy.
  Reject mode returns 503 with `X-Tiyi-Enforcement-Reason:
  cpu_overload_reject`; bypass mode skips only Coraza/CRS and remains visible in
  **Logs → Enforcement**.
- Rate-limit temporary bans and challenge profiles are independent controls.
  Verify rolling-window thresholds, site/global scope, TTL, and final response
  in **Logs → Enforcement** before widening rollout.

## 5. Operate remote nodes

Under **Nodes → Install**, set the reachable Controller URL, tags, expiry, and maximum registered nodes, then generate the installation command.
Run the recommended systemd command on the target host and inspect enrollment and configuration results in Nodes.
See [remote deployment](deployment.md#nodes) for platform, license, complete commands, and recovery boundaries.

Use `sudo tiyi agents list` for current status. Site configuration is published to the local node and all enrolled nodes; offline nodes receive it on reconnect.
Groups organize machines and do not limit a site to that group. Check current applied configuration, proxy/origin health, and a real request on every serving node.
Offline and online-but-not-applied are separate failures.

## 6. Daily and change checks

Daily:

- health, disk space, certificate expiry, agents, and evidence/pipeline backlog;
- firing alerts, SecurityFact trends, and unusual API inventory;
- failed SIEM/channel deliveries and audit-chain verification.

Before and after a change:

```sh
sudo tiyi doctor
sudo tiyi diff -f desired.yaml
sudo tiyi apply -f desired.yaml
sudo tiyi system health
sudo tiyi audit verify
```

For a version-controlled change, start from the
[complete four-kind manifest](templates/apply.yaml) and review the
[replacement, reference, transaction, and rollback rules](configuration.md)
before the first apply. In particular, apply specs replace their managed
fields; they are not merge patches.

Keep the complete state directory, configuration, external KEK, uploaded
certificate sources, license file, and declarative manifests in the backup
plan. Test restoration rather than only testing backup creation; see
[Upgrade and migration](upgrade-migration.md).

<a id="prometheus"></a>
## 7. Connect Prometheus

Tiyi exposes OpenMetrics only on the permission-protected local admin socket.
Verify it locally first:

```sh
sudo curl -fsS --unix-socket /run/tiyi/admin.sock \
  http://localhost/metrics | grep '^tiyi_' | head
```

Do **not** publish that Unix socket through a generic TCP proxy: the socket also
provides passwordless local-administration endpoints. A safe, simple bridge is
node_exporter's textfile collector, which publishes only the metrics body.
Configure node_exporter with
`--collector.textfile.directory=/var/lib/node_exporter/textfile_collector`, then
create this oneshot collector and timer:

```ini
# /etc/systemd/system/tiyi-metrics-textfile.service
[Unit]
Description=Export Tiyi OpenMetrics to node_exporter textfile collector
After=tiyi.service

[Service]
Type=oneshot
User=root
UMask=0022
NoNewPrivileges=true
PrivateTmp=true
ProtectHome=true
ExecStart=/bin/sh -ec '/usr/bin/curl -fsS --unix-socket /run/tiyi/admin.sock http://localhost/metrics -o /var/lib/node_exporter/textfile_collector/tiyi.prom.tmp; /usr/bin/chmod 0644 /var/lib/node_exporter/textfile_collector/tiyi.prom.tmp; /usr/bin/mv -f /var/lib/node_exporter/textfile_collector/tiyi.prom.tmp /var/lib/node_exporter/textfile_collector/tiyi.prom'
```

```ini
# /etc/systemd/system/tiyi-metrics-textfile.timer
[Unit]
Description=Refresh Tiyi OpenMetrics for node_exporter

[Timer]
OnBootSec=30s
OnUnitActiveSec=30s
AccuracySec=5s
Unit=tiyi-metrics-textfile.service

[Install]
WantedBy=timers.target
```

```sh
sudo install -d -m 0755 /var/lib/node_exporter/textfile_collector
sudo systemctl daemon-reload
sudo systemctl enable --now tiyi-metrics-textfile.timer
sudo systemctl start tiyi-metrics-textfile.service
systemctl status tiyi-metrics-textfile.timer --no-pager
curl -fsS http://127.0.0.1:9100/metrics | grep '^tiyi_' | head
```

Prometheus then scrapes the existing node_exporter target:

```yaml
scrape_configs:
  - job_name: node
    static_configs:
      - targets: ['tiyi-host.example.com:9100']
```

The main families are `tiyi_observation_lane_value{lane,field}`,
`tiyi_observation_pipeline_value{field}`, and
`tiyi_api_inventory_value{site_id,field}`. Alert if the timer or oneshot unit
fails, and watch queue/drop/panic fields. Adjust paths if your node_exporter
package uses another textfile directory.

## 8. Operate API Assets

Open **API Assets**, select a site, and inspect the endpoint tree. Discovery
does not add an endpoint to the API catalog. Use **Add to API catalog** or
import an API document, review its host/base-path mappings and apply it.
New catalog entries do not silently enable validation. Hiding a row only
changes the default list; it does not change request handling or learning.

Open an endpoint to review its request definition, traffic samples and learning
results. **Request specification validation** offers Off, Observe and Enforce
where supported. Select a mode, review the change and apply once; wait for all
serving-node receipts before treating it as effective. Unsupported constraints
prevent enforcement. Unlisted-request handling is an independent site/document
scope choice; include legitimate health checks, callbacks and OPTIONS endpoints
before blocking requests outside the catalog.

Eligible POST/PUT/PATCH endpoints automatically learn bounded successful JSON
structures after their sampling configuration is applied. Learning does not
store field values, overwrite authored definitions or turn on blocking.
Review **Learning results**, save a version and export an OpenAPI draft or
establish a specification through the normal review/apply flow. Sampling limits
mean learning counts differ from request counts; incomplete evidence is shown.

Configure body and upload capacities in the site's policy. Endpoint definitions
can add file-field requirements without duplicating the site capacity controls.
Use **Detection statistics** for the actual server-resolved time window and
coverage; enable Schema violation samples explicitly in global/site Log policy
only when retained examples are needed. Counts work with sample capture off.

Use **Manage API document → History and rollback** to inspect publication
results and restore a reviewed prior version. Current intent and actual serving
state are shown separately. See the [v3.8.0 release notes](release-3.8.0.md)
before upgrading an existing deployment.

<a id="notifications"></a>
## 9. Set up notifications that reach someone

In **Alerts & Notifications → Notification Channels**, choose Webhook, Slack, PagerDuty, Feishu, WeCom, or email,
provide the required address/credentials, and save. Test sends a real notification: verify receipt at the destination.
In **Alert Rules**, select events, site/node scope, time window, and threshold, attach the channel, preview content, and enable it.
Certificate expiry, offline nodes, HTTP error rates, and slow requests are useful starting points.
Review firing, repeat, and recovery messages against your on-call needs. Use time-bounded silences for maintenance.
Acknowledging or resolving an alert records the operator and note; manual resolution does not establish that the cause has disappeared.

<a id="tuning"></a>
## 10. Tune WAF and create virtual patches

New sites use Light. Evaluate Standard/Strict for stricter Content-Type/parser requirements after testing login, search, payment callbacks, and uploads.
Policies are attached to sites; changing a shared policy affects every consumer. Inspect impact and create a separate policy when needed.
Start false-positive analysis from rule evidence in Attack Logs. Prefer an exact rule/site/path exception; a custom `pass` rule does not prevent later CRS blocking.
The custom-rule editor includes path, method, and header recipes for virtual patches. Fill real business values, inspect the preview, and test normal plus malicious requests.
`log_only` removes that rule's blocking-score contribution; other rules can still block. Full bypass skips later inspection.
Policy history supports rollback, but shared lists, country datasets, and external CRS dependencies must still exist. It does not roll back application data, site settings, or logs.

Browser/human Bot challenges are unsuitable for noninteractive API clients. Identify the caller before choosing path/IP exemptions or other rate controls.
IP lists contain addresses and need an allow/deny/observe binding; country controls use an activated Country database.
Missing node counters or logs represent incomplete coverage, not proof that no attacks occurred. Check AI suggestions against real request evidence.

## Customize block pages and API errors

Six protection scenarios share templates and have individual statuses. Use the [complete response template and restore steps](responses.md), then verify actual HTML and JSON responses.
