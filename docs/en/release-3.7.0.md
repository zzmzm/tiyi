# Tiyi v3.7.0 release notes

Released 2026-08-31. v3.7.0 is the adaptive-protection and trust-topology
release.

## Highlights

- **Site-wide bot protection:** HTTPS-only sites can remain off, run a silent
  browser proof-of-work check, or require browser proof followed by private
  WebAuthn device confirmation. Narrow path exemptions, trusted IP-list
  references, clearance TTLs, proof difficulty, and network binding are
  operator-controlled.
- **Causal WAF overload handling:** every node correlates normalized Tiyi CPU
  with measured Coraza demand. The default keeps full inspection; explicit
  policies can reject quickly with a marked 503 or bypass only CRS while native
  IP, country, rate, and body controls remain active. Enforcement telemetry
  records the exact result.
- **IP Lists v2 and Country Access:** manual lists, file import, provider feeds,
  custom subscriptions, JSONPath extraction, atomic snapshots, deletion holds,
  and last-good consumer compilation share one list model. Country policy now
  uses a separate first-class resource backed by the active Country database;
  `geo:*` pseudo entries are rejected.
- **Rolling-window abuse controls:** endpoint and client-class limits gain
  deterministic rolling windows, temporary site/global bans, and independent
  browser challenge profiles. WAF and rate-limit interception responses now
  have separate templates.
- **Generic client-IP trust topology:** named proxy nodes consume ordinary
  manual or subscribed IP lists and express Header-first trust edges. Topology
  analysis produces reviewed drafts without silently trusting a provider feed.
- **Bounded observation under pressure:** client-fair SecurityFact sampling,
  separated overload/coverage signals, durable country activation, and a
  complete CRS file manifest keep enforcement and diagnostics explainable when
  input volume or external data changes.

## Required clean-state transition

v3.7.0 cannot open state created by v3.6.0 or earlier releases. This release
does not provide an in-place database migration for the replaced site,
rate-limit, trust, and observation contracts.

Before updating, stop writes and archive the complete installation: state
directory, configuration, unit, binary, external KEK/license/certificates, and
reviewed declarative source. Then use the documented `uninstall --purge`
workflow, let the retained signed updater install v3.7.0, install a fresh
service, recreate reviewed resources, and re-enroll every remote Agent. Do not
import the old database, Agent identity, spool, or bundle cache into v3.7.0.

Follow [Upgrade and migration](upgrade-migration.md) for exact commands and the
rollback boundary.

## After installation

1. Confirm `tiyi --version` reports `v3.7.0`, run `tiyi system health`, and
   verify the local node has an active bundle.
2. Activate a Country database before enabling Country Access. Provider IP
   subscriptions start paused and empty; inspect and explicitly resume only the
   feeds you intend to trust or enforce.
3. Leave WAF overload at **Continue full inspection** until an availability
   owner chooses reject or CRS-bypass behavior and verifies it in **Logs →
   Enforcement**.
4. Enable bot protection only after the site is HTTPS-only. Test legitimate
   browsers, unsupported clients, health checks, and required login callbacks.
5. Rebuild rate-limit rows and response profiles from reviewed intent; do not
   recreate legacy rows mechanically.

Downloads, `SHA256SUMS`, its Ed25519 signature, and the release manifest are on
the [GitHub release](https://github.com/zzmzm/tiyi/releases/tag/v3.7.0) and the
[Gitee mirror](https://gitee.com/tiyisec/tiyi/releases/tag/v3.7.0).
