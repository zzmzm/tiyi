# Import, export, and move sites

For **v3.8.0**. Use the starter below to create a site from a file. For an existing site, export its complete configuration first.
Moving sites does not require copying the database. For an entire Controller, follow [backup and migration](upgrade-migration.md).

## 1. Copyable import starter

Prepare a reachable origin at `http://127.0.0.1:9000`, or replace that URL. The starter creates a **disabled** site so you can inspect it before serving traffic.
Use a hostname, site name, and upstream name not already present on the destination. Download: [site-import.json](templates/site-import.json).

```sh
umask 077
cat > site-import.json <<'JSON'
{
  "apiVersion": "tiyi.io/v1",
  "kind": "SiteConfiguration",
  "site": {
    "name": "imported-app",
    "primaryHost": "imported.example.com",
    "upstreams": [
      {
        "upstreamId": "00000000-0000-4000-8000-000000000010"
      }
    ],
    "tls": {
      "mode": "TLS_MODE_NONE"
    },
    "waf": {
      "enabled": true,
      "mode": "WAF_MODE_BLOCKING"
    },
    "status": "RESOURCE_STATUS_DISABLED"
  },
  "upstreams": [
    {
      "id": "00000000-0000-4000-8000-000000000010",
      "name": "imported-origin",
      "endpoints": [
        {
          "url": "http://127.0.0.1:9000",
          "weight": 100
        }
      ],
      "status": "RESOURCE_STATUS_ACTIVE"
    }
  ],
  "routing": {
    "unmatchedAction": "UNMATCHED_PATH_ACTION_DEFAULT_UPSTREAM"
  },
  "containsSecrets": false
}
JSON
sudo tiyi site import site-import.json
sudo tiyi site list
```

The console equivalent is **Application Delivery → Sites → Import**; upload the same JSON.
The result includes the new `site.id`, created upstream count, and warnings. Copy the returned ID:

```sh
SITE_ID='replace-with-returned-site-id'
sudo tiyi site get "$SITE_ID"
sudo tiyi site enable "$SITE_ID"
curl -i -H 'Host: imported.example.com' http://127.0.0.1/
```

Expect the normal origin response. For HTTPS use `curl --resolve domain:443:TIYI_IP https://domain/`; keep certificate verification enabled.

## 2. Fields to edit

| Field | What to supply |
|---|---|
| `apiVersion`, `kind` | Keep `tiyi.io/v1` and `SiteConfiguration` |
| `site.name` / `primaryHost` / `aliases` | New site name, primary hostname, and optional aliases; omit scheme, port, and path. Both hostname fields support [one-level wildcards](operations.md#wildcard-hosts) |
| `upstreams[].id` and `site.upstreams[].upstreamId` | Matching in-file references; import assigns new IDs, so the sample UUID can remain |
| `upstreams[].endpoints[].url` | Full origin URL reachable from serving nodes, including scheme and port |
| `site.waf` | This starter enables blocking and omits `policyId` to use built-in Light; custom policies must exist at the destination |
| `site.status` | `RESOURCE_STATUS_DISABLED` for review before enabling; `RESOURCE_STATUS_ACTIVE` publishes immediately |
| `routing` | This example uses the default upstream; export an existing multi-route site for a routing starter |

For a wildcard site, set `primaryHost` to `"*.example.com"`; add `"example.com"` to `aliases` for the root domain and `"api.example.com"` for concrete OpenAPI/Schema mappings. Deeper names such as `a.b.example.com` need a separate exact host or pattern. HTTPS certificates must cover every configured host.

These are API enum names, different from the short `active` and `none` values in `tiyi apply`.
This **site configuration bundle** is for `site import`; neither an apply manifest nor an OpenAPI file is interchangeable with it.

## 3. Export an existing site

Find its ID on the source, then export:

```sh
sudo tiyi site list
sudo tiyi site export SITE_ID -o site-backup.json
sudo tiyi site export -o all-sites.json
```

Without an ID, export includes all non-deleted sites in a `SiteConfigurationArchive`. A single export is a `SiteConfiguration`.
Import either with `sudo tiyi site import FILE`. Output files default to mode 0600 and refuse overwrite; use `--force` only when replacement is intended.
Preserve file privacy during editing and transfer.

A bundle includes the site, referenced upstream pools, routes, scalar site-policy overrides, upstream request headers, and the selected TLS certificate with its private key.
**It is not a full installation backup.** WAF policies remain external references. Check or recreate custom rules, shared IP lists, API documents and learning versions,
alerts, users, ACME accounts, and other dependencies separately. Bot IP-list references must exist too.
Even when `containsSecrets` is false, upstream headers can contain sensitive data; do not treat the flag as permission to publish the file.

## 4. Migration checks

1. Prepare referenced policies, lists, and dependencies on the destination; check compatibility when crossing versions.
2. Check origin reachability, hostname conflicts, and certificate coverage. Set exported sites to disabled before import when review is needed.
3. Import assigns new IDs and **never overwrites** destination resources. Duplicate hostnames, upstream names, or certificate fingerprints produce explicit conflicts.
4. Imported managed ACME certificates become uploaded certificates; the renewal account is not transferred. Issue and bind a new managed certificate if you need automatic renewal.
5. Enable and verify all domains, routes, TLS, normal traffic, and WAF behavior before switching DNS. Keep the old installation as a rollback point.

Archives import one site at a time. If a later site fails, earlier successes remain and progress is reported; resources created for the failed site are cleaned up.
Retry only entries that did not succeed. Replaying the whole archive can conflict with already imported resources; the archive is not one transaction.
