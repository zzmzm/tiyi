# Operations guide

This page follows the normal operator loop: publish, observe, investigate,
tune, and verify. Run local CLI commands on the Tiyi host; add `--api URL
--token JWT` when operating remotely.

## 1. Publish an application

Start the backend, create a site, and test routing before changing DNS:

```sh
tiyi site create \
  --name shop \
  --host shop.example.com \
  --upstream-url http://10.0.0.20:9000 \
  --tls none

curl -i -H 'Host: shop.example.com' http://127.0.0.1/
tiyi site list
```

A newly created site is active immediately. The one-step form creates the
upstream pool and uses the built-in Standard policy. Use **Application
Delivery → Sites** for TLS, path routes, health state, and per-site security
overrides. Use an uploaded certificate or managed ACME before changing public
DNS to the Tiyi listener.

For one hostname with several applications, configure longest-prefix path
routes (for example `/api/` and `/static/`) and keep a fallback route. Probe
each route after saving.

## 2. Establish a baseline

Use **Overview** to select a site and time range, then check request rate,
blocked rate, status classes, top attackers, normalized URL Top, and fixed UA
classes. Use **Logs → API Inventory** for discovered assets.

The observation pipeline has four independent truth planes:

- exact hot-path traffic and block counters;
- immutable compact `SecurityFact` records for direct investigation;
- optional retained detail and Request Evidence under independent policy,
  retention, and storage quotas;
- producer-direct SIEM delivery with one bounded queue per destination.

Check **System Monitoring → Log Pipeline** when a consumer falls behind. A slow SIEM
must not change exact counters or block proxy requests.

### Request Evidence and direct SIEM

Fresh installations default Request Evidence to `security_only`. Configure the global policy under
**System Administration → Settings → Global logging & evidence policy**, then
optionally override a site from its **Logging & evidence** drawer.
`security_only` retains evidence for requests that produced a SecurityFact;
`retained_logs` attaches it to retained Attack/Access rows. Captured Cookie,
Authorization, API keys, personal data, and bodies are intentionally
unredacted. Restrict log-read access and use short retention.

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

## 5. Operate agents

In **Nodes → Install**, issue the one-use token and follow the separately shown
download and systemd steps:

```sh
sudo curl -fsSL -o /usr/local/bin/tiyi 'https://tiyi.example.com/download/tiyi'
sudo chmod 0755 /usr/local/bin/tiyi
sudo mkdir -p /etc/tiyi
printf 'TIYI_CONTROLLER_URL=https://tiyi.example.com\nTIYI_AGENT_ENROLLMENT_TOKEN=<one-use-token>\n' | sudo tee /etc/tiyi/tiyi-agent.env >/dev/null
sudo chmod 0600 /etc/tiyi/tiyi-agent.env
sudo tiyi install --mode agent --unit-name tiyi-agent --now
```

Verify online state and the applied revision in Nodes or with
`tiyi agents list`.

Use agent groups for stable targeting. Before a rollout, check the bundle diff;
afterward check apply results and proxy health. Treat an offline agent and a
connected agent on an old revision as different failures.

## 6. Daily and change checks

Daily:

- health, disk space, certificate expiry, agents, and evidence/pipeline backlog;
- firing alerts, SecurityFact trends, and unusual API inventory;
- failed SIEM/channel deliveries and audit-chain verification.

Before and after a change:

```sh
tiyi doctor
tiyi diff -f desired.yaml
tiyi apply -f desired.yaml
tiyi system health
tiyi audit verify
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
