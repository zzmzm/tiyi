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
blocked rate, status classes, latency, and top attackers. Use **Monitoring →
Telemetry Explorer** for a deeper breakdown and the API Inventory view.

The observation pipeline has three independent truth planes:

- exact hot-path traffic and block counters;
- compact retained evidence (`SecurityFact` and `Finding`) for investigation;
- independently retried detail/SIEM delivery.

Check **Monitoring → Log Pipeline** when a consumer falls behind. A slow SIEM
must not change exact counters or block proxy requests.

## 3. Investigate an alert

1. Open **Detection & Response → Active Alerts** and follow the evidence link.
2. Pin the site and time range. Copy the `X-Request-Id` / unique request ID.
3. Correlate the security finding with access and error evidence.
4. Review the Incident lifecycle, source/target, Geo/ASN (advisory), and MITRE
   projection.
5. Review or triage the persistent Attack Campaign when several incidents form
   a larger source/target/TTP pattern.
6. Acknowledge, assign, add a note, then resolve only after the cause or safe
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
6. monitor blocked rate, status codes, and new findings after apply.

An IP allow list is not a substitute for a rule exclusion. A WAF bypass skips
remaining inspection and should be restricted more tightly than a normal
per-rule pass.

## 5. Operate agents

Install the signed binary from the public release channel on every target node,
then issue a short-lived enrollment token and start the agent with that token.
Verify online state and the applied revision after enrollment:

```sh
# On the target node:
curl -fsSL https://www.tiyisec.com/install.sh | bash

# On the primary, issue a token; then copy its token value to the target node:
tiyi agents issue-token --tag edge --ttl-seconds 3600

# On the target node:
sudo tiyi agent --api http://primary:8080 --enrollment-token <token> \
  --state-dir /var/lib/tiyi/agent

# Back on the primary:
tiyi agents list
```

Use agent groups for stable targeting. Before a rollout, check the bundle diff;
afterward check apply results and proxy health. Treat an offline agent and a
connected agent on an old revision as different failures.

## 6. Daily and change checks

Daily:

- health, disk space, certificate expiry, agents, and log-pipeline backlog;
- firing alerts, open incidents, campaign changes, and unusual API inventory;
- failed SIEM/channel deliveries and audit-chain verification.

Before and after a change:

```sh
tiyi doctor
tiyi diff -f desired.yaml
tiyi apply -f desired.yaml
tiyi system health
tiyi audit verify
```

Keep `state.db`, the KEK, uploaded certificate sources, license file, and
declarative manifests in the backup plan. Test restoration rather than only
testing backup creation.
