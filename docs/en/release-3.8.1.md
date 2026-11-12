# Tiyi v3.8.1

Released on 2026-11-12.

## Highlights

- Investigate logs, IPs, alerts and configuration with the optional AI assistant. Continue conversations, review and edit suggestions, diagnose real client IPs, and generate reports using permission-scoped evidence and embedded operator guidance.
- Schedule reports, follow-ups and alert handover summaries. Explicit IP targets, event-count conditions and expiry can authorize bounded automatic actions; model prose does not grant authorization. AI remains off by default and outside request handling.
- Build custom rules with grouped AND/OR conditions, request and response fields, structured bodies and explicit inspection dependencies. Preview, test, inspect history and restore reviewed revisions. Unsupported node capabilities prevent publication.
- Draft narrow rule exceptions directly from security events, preview scope, and batch reviewed CRS adjustments. Keep Tiyi custom rules and IP controls active when selecting a CRS-only exception.
- Search Access, Security and Error Logs with compact filters, editable time ranges, calendar selection and applied-query exports. Retention cutoffs distinguish unavailable history from zero events and avoid errors when partitions have expired.
- Recover reliably after console navigation, keep dialogs and AI context scoped to their page, and retain clear save, application and request-evidence results. Public CLI/API references match the release.

## Upgrade from v3.8.0

Back up the complete installation and matching binary first. v3.8.1 retains the v3.8.0 state boundary (schema 143); startup applies the additional migrations to v3.8.0 state. Upgrade Controller and remote Agents to v3.8.1 before publishing rules that need the new node capabilities. Do not purge v3.8.0 state for this update.

Use the [backup and signed update guide](https://www.tiyisec.com/docs/upgrade-migration.html). The updater replaces the binary after verification; restart deliberately and verify health, node application and normal/blocked requests. To roll back after migration, restore the complete pre-upgrade backup with its matching binary, rather than opening migrated state with an older binary.

v3.7.2 and earlier state remains incompatible. Follow the documented fresh-state migration and re-enroll remote Agents when crossing that earlier boundary. AI provider compatibility and external integrations depend on the configured service; the release does not imply universal provider or physical-cluster qualification.

## Signed downloads

Linux amd64 and arm64 archives contain the executable, its signature, release metadata, these notes and license notices. Verify SHA256SUMS and SHA256SUMS.sig using the published release-key.pub.
