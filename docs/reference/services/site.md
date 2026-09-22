<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# site.proto — Sites, routing, and per-site policy overrides

Schema: `tiyi.v1` · `site.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### SiteService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListSites`](#siteservicelistsites) | unary | (`site:read`) |
| [`GetSite`](#siteservicegetsite) | unary | (`site:read`) |
| [`CreateSite`](#siteservicecreatesite) | unary | (`site:write`) |
| [`UpdateSite`](#siteserviceupdatesite) | unary | (`site:write`) |
| [`DeleteSite`](#siteservicedeletesite) | unary | (`site:delete`) |
| [`EnableSite`](#siteserviceenablesite) | unary | (`site:write`) |
| [`DisableSite`](#siteservicedisablesite) | unary | (`site:write`) |
| [`PreviewCompiledConfig`](#siteservicepreviewcompiledconfig) | unary | (`site:preview`) |
| [`ExportSite`](#siteserviceexportsite) | unary | `site:read` and `upstream:read` and `cert:export` |
| [`ExportSites`](#siteserviceexportsites) | unary | `site:read` and `upstream:read` and `cert:export` |
| [`ImportSite`](#siteserviceimportsite) | unary | `site:write` and `upstream:write` and `cert:write` |
| [`GetSiteRouting`](#siteservicegetsiterouting) | unary | (`site:read`) |
| [`UpdateSiteRouting`](#siteserviceupdatesiterouting) | unary | (`site:write`) |
| [`GetSitePolicyOverride`](#siteservicegetsitepolicyoverride) | unary | (`site:read`) |
| [`UpsertSitePolicyOverride`](#siteserviceupsertsitepolicyoverride) | unary | (`site:write`) |
| [`DeleteSitePolicyOverride`](#siteservicedeletesitepolicyoverride) | unary | (`site:write`) |

## RPCs

### SiteService.ListSites

- **Procedure** `POST /tiyi.v1.SiteService/ListSites`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.ListSitesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |
| `status` | `status` | [`ResourceStatus`](common.md#resourcestatus) | singular | — |

**Response** — `tiyi.v1.ListSitesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Site`](#site) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### SiteService.GetSite

- **Procedure** `POST /tiyi.v1.SiteService/GetSite`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |

### SiteService.CreateSite

- **Procedure** `POST /tiyi.v1.SiteService/CreateSite`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.CreateSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |

**Response** — `tiyi.v1.CreateSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |

### SiteService.UpdateSite

- **Procedure** `POST /tiyi.v1.SiteService/UpdateSite`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.UpdateSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdateSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |

### SiteService.DeleteSite

- **Procedure** `POST /tiyi.v1.SiteService/DeleteSite`
- **Kind** unary
- **Auth** (`site:delete`)

**Request** — `tiyi.v1.DeleteSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### SiteService.EnableSite

- **Procedure** `POST /tiyi.v1.SiteService/EnableSite`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.EnableSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `force` | `force` | `bool` | singular | — |

**Response** — `tiyi.v1.EnableSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |

### SiteService.DisableSite

- **Procedure** `POST /tiyi.v1.SiteService/DisableSite`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.DisableSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.DisableSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |

### SiteService.PreviewCompiledConfig

- **Procedure** `POST /tiyi.v1.SiteService/PreviewCompiledConfig`
- **Kind** unary
- **Auth** (`site:preview`)

**Request** — `tiyi.v1.PreviewCompiledConfigRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |

**Response** — `tiyi.v1.PreviewCompiledConfigResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `caddy_json` | `caddyJson` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `warnings` | `warnings` | `string` | repeated | — |

### SiteService.ExportSite

- **Procedure** `POST /tiyi.v1.SiteService/ExportSite`
- **Kind** unary
- **Auth** `site:read` and `upstream:read` and `cert:export`

**Request** — `tiyi.v1.ExportSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.ExportSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `configuration` | `configuration` | [`SiteConfiguration`](#siteconfiguration) | singular | — |
| `filename` | `filename` | `string` | singular | — |

### SiteService.ExportSites

- **Procedure** `POST /tiyi.v1.SiteService/ExportSites`
- **Kind** unary
- **Auth** `site:read` and `upstream:read` and `cert:export`

**Request** — `tiyi.v1.ExportSitesRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ExportSitesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `archive` | `archive` | [`SiteConfigurationArchive`](#siteconfigurationarchive) | singular | — |
| `filename` | `filename` | `string` | singular | — |

### SiteService.ImportSite

- **Procedure** `POST /tiyi.v1.SiteService/ImportSite`
- **Kind** unary
- **Auth** `site:write` and `upstream:write` and `cert:write`

**Request** — `tiyi.v1.ImportSiteRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `configuration` | `configuration` | [`SiteConfiguration`](#siteconfiguration) | singular | — |

**Response** — `tiyi.v1.ImportSiteResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site` | `site` | [`Site`](#site) | singular | — |
| `upstreams_created` | `upstreamsCreated` | `int32` | singular | — |
| `certificate_imported` | `certificateImported` | `bool` | singular | — |
| `warnings` | `warnings` | `string` | repeated | — |

### SiteService.GetSiteRouting

Path routing — see PATH_ROUTING_DESIGN.md § 6. Routing is managed through its own RPC (not the Site message) so an UpdateSite from a routing-unaware client can never erase routes.

- **Procedure** `POST /tiyi.v1.SiteService/GetSiteRouting`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetSiteRoutingRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSiteRoutingResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `routing` | `routing` | [`SiteRouting`](#siterouting) | singular | — |
| `revision` | `revision` | `int64` | singular | current site revision, for optimistic concurrency on update _JSON string (64-bit ints are quoted)._ |

### SiteService.UpdateSiteRouting

- **Procedure** `POST /tiyi.v1.SiteService/UpdateSiteRouting`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.UpdateSiteRoutingRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | expected site revision (0 = unchecked) _JSON string (64-bit ints are quoted)._ |
| `routing` | `routing` | [`SiteRouting`](#siterouting) | singular | the COMPLETE desired route set |

**Response** — `tiyi.v1.UpdateSiteRoutingResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `routing` | `routing` | [`SiteRouting`](#siterouting) | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### SiteService.GetSitePolicyOverride

Per-site policy overrides — see WAF_POLICY_DESIGN.md § 3.2.

- **Procedure** `POST /tiyi.v1.SiteService/GetSitePolicyOverride`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetSitePolicyOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSitePolicyOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override` | `override` | [`SitePolicyOverride`](#sitepolicyoverride) | singular | — |

### SiteService.UpsertSitePolicyOverride

- **Procedure** `POST /tiyi.v1.SiteService/UpsertSitePolicyOverride`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.UpsertSitePolicyOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override` | `override` | [`SitePolicyOverride`](#sitepolicyoverride) | singular | — |

**Response** — `tiyi.v1.UpsertSitePolicyOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override` | `override` | [`SitePolicyOverride`](#sitepolicyoverride) | singular | — |

### SiteService.DeleteSitePolicyOverride

- **Procedure** `POST /tiyi.v1.SiteService/DeleteSitePolicyOverride`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.DeleteSitePolicyOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteSitePolicyOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

## Messages

### BotProtectionConfig

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `mode` | `mode` | [`BotProtectionMode`](#botprotectionmode) | singular | Site-wide mode. UNSPECIFIED is accepted as OFF. |
| `challenge_ttl_seconds` | `challengeTtlSeconds` | `int32` | singular | Lifetime of one proof or WebAuthn stage, in seconds (30–600; default 120). |
| `clearance_ttl_seconds` | `clearanceTtlSeconds` | `int32` | singular | Lifetime of the signed host clearance, in seconds (300–86400; default 3600). |
| `proof_difficulty` | `proofDifficulty` | `int32` | singular | Required SHA-256 leading zero bits (12–24; default 16). |
| `bind_network` | `bindNetwork` | `bool` | singular | Also bind challenge and clearance tokens to the resolved /24 or /56 network. |
| `exempt_paths` | `exemptPaths` | `string` | repeated | Canonical literal path prefixes that skip only the Bot gate. |
| `trusted_ip_list_ids` | `trustedIpListIds` | `string` | repeated | Tenant-owned IP Lists whose matching resolved clients skip only the Bot gate. |

### Site

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `primary_host` | `primaryHost` | `string` | singular | Hostname or IP literal, without a scheme, port, or path. A leading "*.example.com" matches one subdomain level (api.example.com), not the root example.com or deeper a.b.example.com. HTTPS certificates must cover this host and all aliases. OpenAPI/Schema mappings require explicitly configured concrete hostnames; a wildcard does not create concrete API bindings. |
| `aliases` | `aliases` | `string` | repeated | Additional hosts with the same matching rules as primary_host. Add example.com separately when serving both the root domain and *.example.com. Add concrete API hosts here before using them in OpenAPI/Schema mappings. |
| `upstreams` | `upstreams` | [`SiteUpstream`](#siteupstream) | repeated | — |
| `tls` | `tls` | [`TlsConfig`](common.md#tlsconfig) | singular | — |
| `waf` | `waf` | [`WafConfig`](common.md#wafconfig) | singular | — |
| `status` | `status` | [`ResourceStatus`](common.md#resourcestatus) | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `deleted_at` | `deletedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `bot_protection` | `botProtection` | [`BotProtectionConfig`](#botprotectionconfig) | singular | — |

### SiteCertificateMaterial

SiteCertificateMaterial contains the exact serving certificate selected by the exported site. key_pem is intentionally present: exporting this message requires cert:export. Imported managed ACME certificates are stored as uploaded certificates because ACME account credentials are deployment-wide and are not part of a site bundle.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source_id` | `sourceId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `cert_pem` | `certPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `key_pem` | `keyPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `chain_pem` | `chainPem` | `string` | repeated | — |
| `managed` | `managed` | `bool` | singular | — |

### SiteConfiguration

SiteConfiguration is the portable, versioned site bundle used by ExportSite and ImportSite. Referenced upstream pools and the selected TLS certificate are embedded so a bundle can be restored on another Tiyi installation. The WAF policy remains an explicit external reference and must already exist in the destination tenant.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `api_version` | `apiVersion` | `string` | singular | currently "tiyi.io/v1" |
| `kind` | `kind` | `string` | singular | currently "SiteConfiguration" |
| `site` | `site` | [`Site`](#site) | singular | — |
| `routing` | `routing` | [`SiteRouting`](#siterouting) | singular | — |
| `policy_override` | `policyOverride` | [`SitePolicyOverride`](#sitepolicyoverride) | singular | — |
| `upstreams` | `upstreams` | [`Upstream`](upstream.md#upstream) | repeated | — |
| `certificate` | `certificate` | [`SiteCertificateMaterial`](#sitecertificatematerial) | singular | — |
| `contains_secrets` | `containsSecrets` | `bool` | singular | — |
| `external_references` | `externalReferences` | `string` | repeated | — |

### SiteConfigurationArchive

SiteConfigurationArchive is the all-sites export format. Each configuration remains independently importable, which keeps the single-site format stable and makes a partially recovered archive diagnosable by site.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `api_version` | `apiVersion` | `string` | singular | currently "tiyi.io/v1" |
| `kind` | `kind` | `string` | singular | currently "SiteConfigurationArchive" |
| `configurations` | `configurations` | [`SiteConfiguration`](#siteconfiguration) | repeated | — |
| `contains_secrets` | `containsSecrets` | `bool` | singular | — |

### SitePolicyOverride

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `blocking_paranoia_level` | `blockingParanoiaLevel` | `int32` | optional (explicit) | Scalar overrides. An unset field means "inherit the policy value"; a set field replaces the base policy's value for this site. Follows the same semantics as CRS docs § 2-1 (thresholds), § 2-2 (paranoia levels), § 2-4 (sampling). |
| `detection_paranoia_level` | `detectionParanoiaLevel` | `int32` | optional (explicit) | — |
| `inbound_anomaly_score_threshold` | `inboundAnomalyScoreThreshold` | `int32` | optional (explicit) | — |
| `outbound_anomaly_score_threshold` | `outboundAnomalyScoreThreshold` | `int32` | optional (explicit) | — |
| `sampling_percentage` | `samplingPercentage` | `int32` | optional (explicit) | — |
| `rationale` | `rationale` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### SiteRoute

SiteRoute sends every request whose path falls under path_prefix (segment-boundary, case-insensitive) to exactly one named upstream pool.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `path_prefix` | `pathPrefix` | `string` | singular | canonicalized server-side (lowercased, no trailing slash) |
| `upstream_id` | `upstreamId` | `string` | singular | — |
| `rewrite_mode` | `rewriteMode` | [`PathRewriteMode`](#pathrewritemode) | singular | — |

### SiteRouting

SiteRouting is a site's complete path-routing configuration. Route order is not authoritative — the server orders by longest prefix first.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `routes` | `routes` | [`SiteRoute`](#siteroute) | repeated | — |
| `unmatched_action` | `unmatchedAction` | [`UnmatchedPathAction`](#unmatchedpathaction) | singular | — |

### SiteUpstream

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `upstream_id` | `upstreamId` | `string` | singular | — |
| `inline` | `inline` | [`UpstreamEndpoint`](common.md#upstreamendpoint) | singular | — |
| `request_headers` | `requestHeaders` | map&lt;`string`, `string`&gt; | map | Used only with inline. Named pools carry their own request_headers. |

## Enums

### BotProtectionMode

BotProtectionMode is a site-wide admission contract. It is deliberately independent from WAF policy rate limits: every request without a valid site clearance is denied unless it enters and completes the selected browser/human verification flow.

| Value | Number | Description |
|---|---|---|
| `BOT_PROTECTION_MODE_UNSPECIFIED` | 0 | canonicalized to OFF |
| `BOT_PROTECTION_MODE_OFF` | 1 | — |
| `BOT_PROTECTION_MODE_BROWSER_CHECK` | 2 | — |
| `BOT_PROTECTION_MODE_HUMAN_VERIFICATION` | 3 | — |

### PathRewriteMode

| Value | Number | Description |
|---|---|---|
| `PATH_REWRITE_MODE_UNSPECIFIED` | 0 | treated as PRESERVE |
| `PATH_REWRITE_MODE_PRESERVE` | 1 | forward the original path to the backend |
| `PATH_REWRITE_MODE_STRIP_PREFIX` | 2 | strip the matched prefix before proxying |

### UnmatchedPathAction

| Value | Number | Description |
|---|---|---|
| `UNMATCHED_PATH_ACTION_UNSPECIFIED` | 0 | treated as DEFAULT_UPSTREAM |
| `UNMATCHED_PATH_ACTION_DEFAULT_UPSTREAM` | 1 | fall through to the site default pool |
| `UNMATCHED_PATH_ACTION_RETURN_404` | 2 | strict allowlist: 404 unmatched paths |
