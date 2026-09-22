<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# upstream.proto — Upstream pools

Schema: `tiyi.v1` · `upstream.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### UpstreamService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListUpstreams`](#upstreamservicelistupstreams) | unary | (`upstream:read`) |
| [`GetUpstream`](#upstreamservicegetupstream) | unary | (`upstream:read`) |
| [`CreateUpstream`](#upstreamservicecreateupstream) | unary | (`upstream:write`) |
| [`UpdateUpstream`](#upstreamserviceupdateupstream) | unary | (`upstream:write`) |
| [`DeleteUpstream`](#upstreamservicedeleteupstream) | unary | (`upstream:delete`) |
| [`ListUpstreamHealth`](#upstreamservicelistupstreamhealth) | unary | (`upstream:read`) |

## RPCs

### UpstreamService.ListUpstreams

- **Procedure** `POST /tiyi.v1.UpstreamService/ListUpstreams`
- **Kind** unary
- **Auth** (`upstream:read`)

**Request** — `tiyi.v1.ListUpstreamsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |

**Response** — `tiyi.v1.ListUpstreamsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Upstream`](#upstream) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### UpstreamService.GetUpstream

- **Procedure** `POST /tiyi.v1.UpstreamService/GetUpstream`
- **Kind** unary
- **Auth** (`upstream:read`)

**Request** — `tiyi.v1.GetUpstreamRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetUpstreamResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `upstream` | `upstream` | [`Upstream`](#upstream) | singular | — |

### UpstreamService.CreateUpstream

- **Procedure** `POST /tiyi.v1.UpstreamService/CreateUpstream`
- **Kind** unary
- **Auth** (`upstream:write`)

**Request** — `tiyi.v1.CreateUpstreamRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `upstream` | `upstream` | [`Upstream`](#upstream) | singular | — |

**Response** — `tiyi.v1.CreateUpstreamResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `upstream` | `upstream` | [`Upstream`](#upstream) | singular | — |

### UpstreamService.UpdateUpstream

- **Procedure** `POST /tiyi.v1.UpstreamService/UpdateUpstream`
- **Kind** unary
- **Auth** (`upstream:write`)

**Request** — `tiyi.v1.UpdateUpstreamRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `upstream` | `upstream` | [`Upstream`](#upstream) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdateUpstreamResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `upstream` | `upstream` | [`Upstream`](#upstream) | singular | — |

### UpstreamService.DeleteUpstream

- **Procedure** `POST /tiyi.v1.UpstreamService/DeleteUpstream`
- **Kind** unary
- **Auth** (`upstream:delete`)

**Request** — `tiyi.v1.DeleteUpstreamRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteUpstreamResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### UpstreamService.ListUpstreamHealth

- **Procedure** `POST /tiyi.v1.UpstreamService/ListUpstreamHealth`
- **Kind** unary
- **Auth** (`upstream:read`)

**Request** — `tiyi.v1.ListUpstreamHealthRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `upstream_ids` | `upstreamIds` | `string` | repeated | Up to 200 pools. Omit to query all pools. |

**Response** — `tiyi.v1.ListUpstreamHealthResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`UpstreamHealthState`](#upstreamhealthstate) | repeated | — |
| `expected_node_ids` | `expectedNodeIds` | `string` | repeated | The built-in node and every enrolled, non-deleted remote node, including offline nodes and nodes which have never reported health. |

## Messages

### Upstream

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `endpoints` | `endpoints` | [`UpstreamEndpoint`](common.md#upstreamendpoint) | repeated | — |
| `status` | `status` | [`ResourceStatus`](common.md#resourcestatus) | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `deleted_at` | `deletedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `health_check` | `healthCheck` | [`UpstreamHealthCheck`](#upstreamhealthcheck) | singular | — |
| `resilience` | `resilience` | [`UpstreamResiliencePolicy`](#upstreamresiliencepolicy) | singular | — |
| `request_headers` | `requestHeaders` | map&lt;`string`, `string`&gt; | map | Plaintext request headers applied to every request sent through this pool. These are ordinary portable configuration, not secret material. |

### UpstreamHealthCheck

UpstreamHealthCheck is the pool-level active probe contract compiled into Caddy. An empty path disables active checks. Defaults are applied server-side when optional tuning values are omitted.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `path` | `path` | `string` | singular | — |
| `method` | `method` | `string` | singular | — |
| `expected_status` | `expectedStatus` | `int32` | singular | — |
| `interval_seconds` | `intervalSeconds` | `int32` | singular | — |
| `timeout_seconds` | `timeoutSeconds` | `int32` | singular | — |
| `unhealthy_threshold` | `unhealthyThreshold` | `int32` | singular | — |
| `healthy_threshold` | `healthyThreshold` | `int32` | singular | — |
| `follow_redirects` | `followRedirects` | `bool` | singular | — |
| `expected_body` | `expectedBody` | `string` | singular | — |
| `host` | `host` | `string` | singular | — |

### UpstreamHealthState

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `upstream_id` | `upstreamId` | `string` | singular | — |
| `endpoint_url` | `endpointUrl` | `string` | singular | — |
| `address` | `address` | `string` | singular | — |
| `status` | `status` | `string` | singular | unknown \| healthy \| unhealthy |
| `reported_at` | `reportedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `last_transition_at` | `lastTransitionAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `config_generation` | `configGeneration` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `artifact_sha256` | `artifactSha256` | `string` | singular | — |

### UpstreamResiliencePolicy

UpstreamResiliencePolicy protects real traffic independently of active probes. When this message is omitted, the server enables passive failure ejection (30 seconds / 2 failures) and safe bounded retries (5 seconds / 250 milliseconds). Explicit booleans allow either lane to be disabled without changing the active health-check contract.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `passive_health_enabled` | `passiveHealthEnabled` | `bool` | singular | — |
| `passive_fail_duration_seconds` | `passiveFailDurationSeconds` | `int32` | singular | — |
| `passive_max_fails` | `passiveMaxFails` | `int32` | singular | — |
| `retry_enabled` | `retryEnabled` | `bool` | singular | — |
| `retry_duration_seconds` | `retryDurationSeconds` | `int32` | singular | — |
| `retry_interval_milliseconds` | `retryIntervalMilliseconds` | `int32` | singular | — |
