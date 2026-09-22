# CLI task reference

For **v3.8.0**. On the Tiyi host, the system service uses a protected local socket: usually add `sudo`, with no login required.
For remote CLI access, obtain `TIYI_API` and `TIYI_TOKEN` using the [API guide](api.md#authentication) and omit sudo.
For a custom foreground process, pass `--admin-socket /actual/path/admin.sock`.

## Common read-only checks

```sh
sudo tiyi system health
sudo tiyi site list
sudo tiyi upstream list
sudo tiyi cert list
sudo tiyi policy list
sudo tiyi agents list
sudo tiyi audit verify
```

Lists and resource commands usually return JSON. Save output and use `jq` to obtain IDs instead of inventing them.
Log lists are paginated; the default page is not the whole history. Failures return nonzero: ordinarily 1, or 78 for rejected Agent enrollment/reset-required state.
`system health` also returns nonzero for unhealthy or unknown components; automation should check the exit status.

## Find commands by task

| Task | Commands | Walkthrough |
|---|---|---|
| Install, start, diagnose | `install`, `run`, `doctor` | [Installation](installation.md) |
| Sites, routes, site migration | `site`, `site routing`, `site export/import` | [Operations](operations.md) · [JSON import template](site-import.md) |
| Origin pools, health probes, retries | `upstream` | [Operations](operations.md) |
| Uploaded certificates, ACME, DNS credentials | `cert` | [HTTPS](operations.md#https) |
| WAF policies, versions, request capacity | `policy` | [Tuning](operations.md) |
| Custom rules, CRS overrides, IP/country, rate limits | `rule`, `crs` | [Operations](operations.md) |
| Client IP and trusted proxies/CDNs | `trust` | [Deployment](deployment.md#client-ip) |
| API files, learning, validation, publication | `api-document` | [API protection](api-protection.md) |
| Request investigation, alerts, notifications, audit | `log`, `alert`, `audit` | [Operations](operations.md) |
| Remote nodes and groups | `agents`, `agent-group` | [Deployment](deployment.md#nodes) |
| Authentication, users, roles | `auth`, `user`, `role` | [API](api.md) · [Deployment](deployment.md) |
| Resource files | `get`, `diff`, `apply` | [YAML templates](configuration.md) |
| Settings, updates, node rollout | `system`, `update`, `release` | [Upgrade and migration](upgrade-migration.md) |

## Common mutations

Read the target with list/get first. Complete templates exist for every file below:

```sh
sudo tiyi diff -f first-site.yaml
sudo tiyi apply -f first-site.yaml --dry-run
sudo tiyi apply -f first-site.yaml
sudo tiyi site import site-import.json
sudo tiyi api-document upload --site SITE_ID --file orders-openapi.yaml
```

`first-site.yaml` is for apply, `site-import.json` for site import, and `orders-openapi.yaml` for API documentation.
These formats are not interchangeable. Resource creation usually takes effect immediately; `diff`, `--dry-run`, and document preview are the preview operations.

## Wildcard site hostnames

`site create` and `site update` accept wildcard values in `--host` and repeatable `--alias`. Quote them, for example `--host '*.example.com' --alias example.com`. This matches one subdomain level; it excludes the root domain unless added separately and excludes deeper names such as `a.b.example.com`. See the [complete example and HTTPS/API requirements](operations.md#wildcard-hosts).

## Look up exact flags

The [complete command option reference](../reference/cli-options.md) is available here, without a source checkout.
The installed binary also includes help:

```sh
tiyi --help
tiyi site create --help
tiyi site routing set --help
tiyi api-document --help
tiyi api-document preview --help
tiyi alert channel upsert --help
```

Requests for `api-document -f` use protobuf JSON; see the [API method tables](../reference/services/api_schema.md).
Use the UI or HTTP JSON API for operations without a dedicated CLI wrapper. Do not edit the database or generated proxy configuration.
