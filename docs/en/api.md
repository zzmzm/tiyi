# API integration and complete reference

For **v3.8.0**. Automate administration with ordinary ConnectRPC HTTP JSON:
`POST /tiyi.v1.Service/Method`. No SDK is needed. Your application's OpenAPI file belongs to [request protection](api-protection.md);
this page covers the **API that manages Tiyi**.

Complete reference: [309 RPCs / 26 services](../reference/rpc-index.md) · [request/response fields](../reference/README.md) ·
[permissions](../reference/permissions.md). Each RPC includes its path, request, response, enums, and required permissions.

<a id="authentication"></a>
## 1. Choose authentication

| Context | Entry point | Credentials |
|---|---|---|
| Maintenance on the Tiyi host | `/run/tiyi/admin.sock` | Unix file permissions, usually sudo; local administrator privileges |
| Your computer, CI, or another service | Management URL; use HTTPS in production | `Authorization: Bearer JWT`, with the user's permissions |
| Remote Agent | Generated node-install flow | Expiring, node-limited enrollment token and node identity, separate from an administrator JWT |

Local read without a login:

```sh
sudo curl --fail-with-body -sS --unix-socket /run/tiyi/admin.sock \
  http://localhost/tiyi.v1.SiteService/ListSites \
  -H 'Content-Type: application/json' -d '{"page":{"page":1,"pageSize":20}}'
```

Do not expose the entire admin socket through a public TCP proxy. For remote automation, create a user and role with the permissions needed for its tasks.

## 2. Log in and obtain a token

This example needs Bash, curl, Python 3, and jq. Replace `SERVER_IP` below with the Tiyi host's IP address; if you have an HTTPS management URL, use that URL instead.
Change the username in the script from `admin` to your automation user when appropriate.
The password is entered without echo and kept out of shell history; temporary credentials stay in a private directory.

```sh
export TIYI_API='http://SERVER_IP:8080'
umask 077
SESSION_DIR=$(mktemp -d)
python3 - "$SESSION_DIR/login.json" <<'PY'
import getpass, json, pathlib, sys
pathlib.Path(sys.argv[1]).write_text(json.dumps({
    "username": "admin", "password": getpass.getpass("Tiyi password: ")
}))
PY
curl --fail-with-body -sS -c "$SESSION_DIR/cookies" \
  -H 'Content-Type: application/json' \
  --data-binary @"$SESSION_DIR/login.json" \
  "$TIYI_API/tiyi.v1.AuthService/Login" -o "$SESSION_DIR/session.json"
rm "$SESSION_DIR/login.json"
while jq -e '.challengeRequired == true' "$SESSION_DIR/session.json" >/dev/null; do
  python3 - "$SESSION_DIR/challenge.json" <<'PY'
import getpass, json, pathlib, sys
pathlib.Path(sys.argv[1]).write_text(json.dumps({"code": getpass.getpass("MFA / RADIUS code: ")}))
PY
  curl --fail-with-body -sS -b "$SESSION_DIR/cookies" -c "$SESSION_DIR/cookies" \
    -H 'Content-Type: application/json' --data-binary @"$SESSION_DIR/challenge.json" \
    "$TIYI_API/tiyi.v1.AuthService/CompleteAuthenticationChallenge" \
    -o "$SESSION_DIR/session.json" || break
  rm -f "$SESSION_DIR/challenge.json"
done
TIYI_TOKEN=$(jq -er '.accessToken | select(length > 0)' "$SESSION_DIR/session.json")
export TIYI_TOKEN
tiyi auth user
```

A successful `auth user` returns the current identity. Resolve login failures before proceeding; an empty token is not a successful login.
With TOTP or RADIUS challenges, `challengeRequired` is true and the challenge cookie must accompany completion.
OIDC/SAML use browser redirect flows; an identity-provider token is not a Tiyi JWT.

The CLI does not automatically persist `auth login` output as a session. `TIYI_API` and `TIYI_TOKEN` provide credentials for subsequent CLI calls here.
Defaults are 8 hours for access tokens and 7 days for refresh tokens, configurable by the administrator.

## 3. Query and create a site

Define a reusable function and request the first page:

```sh
tiyi_rpc() {
  curl --fail-with-body -sS "$TIYI_API/tiyi.v1.$1" \
    -H "Authorization: Bearer $TIYI_TOKEN" \
    -H 'Content-Type: application/json' -H 'Connect-Protocol-Version: 1' \
    --data-binary "$2"
}
tiyi_rpc SiteService/ListSites '{"page":{"page":1,"pageSize":20}}'
```

`items` contains the current page; `page.total` is the total as a 64-bit decimal string. Increment `page.page` for subsequent pages.

The following creates an **immediately active** demo site. Start the quickstart origin first and change example names or domains already in use:

```sh
cat > api-site.json <<'JSON'
{
  "site": {
    "name": "api-example",
    "primaryHost": "api.example.com",
    "upstreams": [{"inline": {"url": "http://127.0.0.1:9000", "weight": 100}}],
    "tls": {"mode": "TLS_MODE_NONE"},
    "waf": {"enabled": true, "mode": "WAF_MODE_BLOCKING"},
    "status": "RESOURCE_STATUS_ACTIVE"
  }
}
JSON
tiyi_rpc SiteService/CreateSite @api-site.json > created-site.json
SITE_ID=$(jq -er '.site.id' created-site.json)
curl -i -H 'Host: api.example.com' http://127.0.0.1/
```

Expect the origin's normal response. WAF is enabled and defaults to Light when no policy is specified. Also verify attack probes and node publication results.

## 4. Update one field with concurrency protection

Read the latest site, then send its revision and a mask to change only the name:

```sh
jq -n --arg id "$SITE_ID" '{id:$id}' > get-site.json
tiyi_rpc SiteService/GetSite @get-site.json > current-site.json
jq '{site:{id:.site.id,name:"api-renamed"},
     revision:.site.revision,updateMask:"name"}' current-site.json > update-site.json
tiyi_rpc SiteService/UpdateSite @update-site.json
```

`updateMask` is a comma-separated JSON field-path string, not an array. Keep `revision` as the returned decimal string to avoid JavaScript precision loss.
On `aborted` or a revision conflict, reread, compare, and decide the change again instead of overwriting blindly.
Update behavior varies by service; some operations, including policy-layer writes, replace complete objects.

## 5. Refresh, log out, and follow JSON conventions

The refresh token normally arrives in an HttpOnly cookie, not the login JSON. Renew using the latest cookie:

```sh
curl --fail-with-body -sS -b "$SESSION_DIR/cookies" -c "$SESSION_DIR/cookies" \
  -H 'Content-Type: application/json' -d '{}' \
  "$TIYI_API/tiyi.v1.AuthService/Refresh" -o "$SESSION_DIR/session.json"
TIYI_TOKEN=$(jq -er '.accessToken | select(length > 0)' "$SESSION_DIR/session.json")
export TIYI_TOKEN
```

Refresh rotates the token. Do not concurrently reuse or repeatedly replay an old refresh cookie.
When done, log out and remove this session's temporary credentials:

```sh
curl --fail-with-body -sS -b "$SESSION_DIR/cookies" \
  -H 'Content-Type: application/json' -d '{}' "$TIYI_API/tiyi.v1.AuthService/Logout"
unset TIYI_TOKEN
rm -rf -- "$SESSION_DIR"
unset SESSION_DIR
```


| Convention | Handling |
|---|---|
| JSON fields | Use documented lowerCamelCase such as `siteId`, not apply-YAML aliases |
| 64-bit integers | Keep revisions, counts, and totals as decimal strings unless conversion is known to be safe |
| `bytes` | Base64 strings, including `source`, `reportJson`, and certificate PEM fields |
| Enums | Full symbolic names, such as `RESOURCE_STATUS_ACTIVE` and `TLS_MODE_MANAGED_ACME` |
| Time | RFC 3339, preferably UTC, e.g. `2026-09-17T08:00:00Z` |
| Tenant | Determined by the caller; a supplied `tenantId` does not grant cross-tenant access |
| Idempotency | Use `idempotencyKey` only where defined; exact retries retain the key and request, changed requests need a new key |

## 6. Errors and permissions

Connect errors usually look like `{"code":"permission_denied","message":"..."}`.
Preserve the response body and HTTP status; completion of a network request is not proof of success.

| Error | Next action |
|---|---|
| `unauthenticated` / 401 | Check token, expiry, and clock; refresh or log in again |
| `permission_denied` / 403 | Check the user's roles and all required method permissions |
| `invalid_argument` / 400 | Check field names, types, enums, limits, and required values |
| `already_exists` / 409 | Read the existing name/hostname instead of recreating it |
| `aborted` / 409 | State or preview changed; reread and preview again |
| `failed_precondition` | Check certificates, policies, dependencies, node capabilities, and current state |
| `resource_exhausted` / `unavailable` | Use bounded backoff; establish whether a write already succeeded and follow its idempotency contract |
| `unimplemented` / 501 | The entry point cannot perform the action; retries or fabricated fields will not enable it |

`SystemService.Health` needs `system:read`; use `/healthz` for anonymous liveness. A schema field is not an authorization grant.

<a id="api-documents"></a>
## 7. API document and validation publication

Start with the [copyable upload and preview](api-protection.md#7-cli-and-api-automation).
Call [ApiSchemaService](../reference/services/api_schema.md) in dependency order below.
Take IDs, hashes, and approval objects from real responses:

| Step | Method / CLI | Output needed next |
|---|---|---|
| Upload a file | `StageSchemaSource` / `api-document upload` | `source.id`; the request's `source` field is file content as base64 |
| Review mapping and existing endpoints | `PreviewApiDeclaration` / `declaration-preview` | `reportSha256`, `catalogSha256`, decoded report and matching results |
| Save the reviewed declaration | `StageApiDeclaration` / `declaration-stage` | `contract.id`; explicit decisions for ambiguous matches; independently reviewed coverage |
| Compile executable checks | `StageSchemaProfile` / `profile-stage` | `profile.id` and capability/diagnostic report; unsupported checks are not enforced |
| Select endpoint modes | `StageSchemaBindings` / `bindings-stage` | `bindings.id`; `operationKeys` selects validation and `enforceOperationKeys` is its enforced subset |
| Preview publication | `PreviewSchemaControl` / `preview` | Complete `approval`, change/resource reports, and `executionSupported` |
| Submit the review | `ChangeSchemaControl` / `publish` | `intent` and state; send the original approval, reason, idempotency key, and actually reviewed acknowledgements |
| Check application and requests | `OperationControlService.GetOperationControlState`, `GetSchemaValidation`, `GetSchemaDetection` | Serving-node results, configured validation, and detection statistics |

Catalog-only publication may omit a validation binding and does not enable request validation. A root mapping uses `basePath: ""`.
Learning, request editing, document versions, deactivation, and rollback have dedicated methods in the [field reference](../reference/services/api_schema.md).
Hiding/restoring an asset row does not enable blocking. Catalog membership changes use `StageApiCatalogChange` and the same publication lifecycle.


### Copyable recipe: publish the demo order endpoint in Observe

Continue in the same directory and terminal with `source-result.json`, `declaration-preview.json`, and `preview-result.json`
from the [API protection tutorial](api-protection.md#7-cli-and-api-automation). This needs jq and assumes the single demo endpoint has been reviewed.
For a real document with ambiguous matches, conflicts, or unsupported checks, resolve the report first; do not automatically accept everything.

**Stage the declaration and compile checks.** After reviewing mapping and reconciliation:

```sh
jq -s '.[0] + {reportSha256:.[1].reportSha256,
  catalogSha256:.[1].catalogSha256,idempotencyKey:"orders-declaration-v1"}' \
  declaration-preview.json preview-result.json > declaration-stage.json
sudo tiyi api-document declaration-stage -f declaration-stage.json > declaration-result.json
jq '. + {idempotencyKey:"orders-profile-v1"}' declaration-preview.json > profile-stage.json
sudo tiyi api-document profile-stage -f profile-stage.json > profile-result.json
jq '{siteId:.contract.siteId,contractId:.contract.id}' declaration-result.json > contract-request.json
sudo tiyi api-document declaration -f contract-request.json > contract-result.json
jq -r '.contractJson' contract-result.json | base64 -d > contract.json
jq '.operations' contract.json
```

The operations should contain only the demo `POST /api/orders`. Inspect the profile's report; these operations still have not published to traffic.

**Select observation and preview impact.** The next block selects every endpoint in this one-endpoint demo. For your own document, narrow `operationKeys` to the reviewed endpoints:

```sh
jq -n --slurpfile c declaration-result.json --slurpfile p profile-result.json \
  --slurpfile d contract.json '{siteId:$c[0].contract.siteId,
    declarationId:$c[0].contract.id,profileId:$p[0].profile.id,
    operationKeys:[$d[0].operations[].key],idempotencyKey:"orders-bindings-observe-v1"}' \
  > bindings-stage.json
sudo tiyi api-document bindings-stage -f bindings-stage.json > bindings-result.json
jq -n --slurpfile c declaration-result.json --slurpfile b bindings-result.json \
  '{siteId:$c[0].contract.siteId,action:"activate",contractId:$c[0].contract.id,
    bindingId:$b[0].bindings.id,undeclaredAction:"allow"}' > control-preview.json
sudo tiyi api-document preview -f control-preview.json > control-preview-result.json
jq '{executionSupported,approval}' control-preview-result.json
jq -r '.changesJson' control-preview-result.json | base64 -d
jq -r '.resourcesJson' control-preview-result.json | base64 -d
```

Require `executionSupported: true` and review scope, capabilities, and resource reports. If execution is unavailable or partial acceptance is required, resolve it rather than adding flags to bypass review.

**Submit the reviewed change and check nodes.** The acknowledgement fields below represent the review you just performed. Query the exact returned intent:

```sh
jq -e 'select(.executionSupported == true) | {approval:.approval,
  idempotencyKey:"orders-publish-observe-v1",reason:"Reviewed demo orders API",
  impactAcknowledged:true,resourceAcknowledged:true,typeOnlyAcknowledged:true}' \
  control-preview-result.json > publish-request.json
sudo tiyi api-document publish -f publish-request.json > publication-result.json
jq '{siteId:.intent.siteId,intentId:.intent.id}' publication-result.json > state-request.json
sudo curl --fail-with-body -sS --unix-socket /run/tiyi/admin.sock \
  http://localhost/tiyi.v1.OperationControlService/GetOperationControlState \
  -H 'Content-Type: application/json' --data-binary @state-request.json
```

Repeat the final read-only query until the target nodes have applied it, then send both tutorial probes. Observe returns 200 for both unless an independent rule blocks.
These idempotency keys identify one demo revision. Use a new key for changed content and retain the same key/request for an exact retry.

### Move from observation to enforcement

After validating the demo and deciding to reject type errors, create an enforced binding:

```sh
jq '.enforceOperationKeys = .operationKeys |
    .idempotencyKey = "orders-bindings-enforce-v1"' \
  bindings-stage.json > bindings-enforce.json
sudo tiyi api-document bindings-stage -f bindings-enforce.json > bindings-result.json
```

Rebuild the control-preview request above using the new `bindings-result.json`, preview again, and review the reports.
For publication, change the key to `orders-publish-enforce-v1` and supply the real reason for the change. **Do not reuse the Observe approval.**
Check this intent's serving-node results, then replay both probes: valid 200, invalid type 403.
To revert, select the observing binding through a new preview/publication or restore a reviewed version in console history. Editing a local JSON file alone never changes live traffic.

<a id="http"></a>
## 8. HTTP probes, telemetry, and metrics

| Endpoint | Method and authentication | Purpose |
|---|---|---|
| `/healthz` | GET, management or socket, anonymous | Process liveness only, normally `{"status":"ok"}` |
| `/readyz` | GET, local socket only | Storage and built-in proxy/config readiness; failure returns 503, management listener returns 404 |
| `/metrics` | GET, local socket only | OpenMetrics; [Prometheus setup](operations.md#prometheus) |
| `/download/tiyi` | GET, anonymous | Running Controller binary for Agents on the same platform |
| `/api/v1/telemetry/qps` | GET, JWT + `telemetry:read` | Optional `site`, `window` such as `1m` |
| `/api/v1/telemetry/series`, `topk` | GET, JWT + `telemetry:read` | Time windows, dimensions, and aggregates |
| `/api/v1/telemetry/apitree` | GET, JWT + `telemetry:read` | Required `site`; optional `base=/`, `depth=128`, and time bounds |
| `/api/v1/telemetry/apitree/action` | POST, `api_inventory:write` + `site:read` | `hide`, `restore`, `retire`, with the current `expected_revision` string |
| `/debug/*` | GET, local socket only | Diagnostics; fields may change across versions |

Telemetry HTTP JSON uses its own snake_case fields and errors shaped as `{"error":{"code":...,"message":...}}`.
Asset `block` and `apply_body_suggestion` actions are reserved and return 501; the old `confirm` action is unsupported.
Unknown management URLs may return the console's HTML with status 200. Check `Content-Type` before treating it as an API response.
