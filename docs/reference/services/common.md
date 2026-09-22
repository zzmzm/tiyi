<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# common.proto — Shared types

Schema: `tiyi.v1` · `common.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Messages

### BuildInfo

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `version` | `version` | `string` | singular | — |
| `commit` | `commit` | `string` | singular | — |
| `build_date` | `buildDate` | `string` | singular | — |

### CursorRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cursor` | `cursor` | `string` | singular | — |
| `page_size` | `pageSize` | `int32` | singular | — |
| `offset` | `offset` | `int32` | singular | offset enables direct page jumps without a forward cursor walk. When > 0 the server skips the first `offset` matching rows and returns the next `page_size`-sized window. Mutually exclusive with `cursor` — setting both is rejected with InvalidArgument. The server caps offset at an implementation-defined ceiling (currently 100_000 on log queries) and returns InvalidArgument past it; clients should narrow the time range instead. Cursor remains the streaming/export path; offset is the page-jump path. |

### CursorResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `next_cursor` | `nextCursor` | `string` | singular | — |
| `has_more` | `hasMore` | `bool` | singular | — |

### JsonPatch

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `before` | `before` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `after` | `after` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `changed_paths` | `changedPaths` | `string` | repeated | — |

### MutationResult

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `changed` | `changed` | `bool` | singular | — |

### NetworkGeo

NetworkGeo is best-effort context for an observed network exit. It is intentionally descriptive only: callers must not treat it as an attacker identity or use it as an enforcement/correlation key.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `country_code` | `countryCode` | `string` | singular | — |
| `country_name` | `countryName` | `string` | singular | — |
| `region` | `region` | `string` | singular | — |
| `city` | `city` | `string` | singular | — |
| `asn` | `asn` | `uint32` | singular | — |
| `asn_org` | `asnOrg` | `string` | singular | — |

### ObservationCoverage

Current delivery coverage of remote observation streams. Counts returned by data read surfaces are known lower bounds while incomplete is true.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `incomplete` | `incomplete` | `bool` | singular | — |
| `affected_nodes` | `affectedNodes` | `int32` | singular | — |
| `worst_node_id` | `worstNodeId` | `string` | singular | — |
| `worst_node_name` | `worstNodeName` | `string` | singular | — |
| `worst_state` | `worstState` | `string` | singular | backlog \| coverage_gap \| quarantined |
| `quarantined_streams` | `quarantinedStreams` | `string` | repeated | — |
| `pending_batches` | `pendingBatches` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `pending_bytes` | `pendingBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `evicted_batches` | `evictedBatches` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `gap_notices` | `gapNotices` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |

### PageRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | `int32` | singular | — |
| `page_size` | `pageSize` | `int32` | singular | — |

### PageResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | `int32` | singular | — |
| `page_size` | `pageSize` | `int32` | singular | — |
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### ResourceRef

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |

### TimeRange

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `start` | `start` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `end` | `end` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### TlsConfig

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `mode` | `mode` | [`TlsMode`](#tlsmode) | singular | — |
| `cert_id` | `certId` | `string` | singular | — |
| `min_version` | `minVersion` | [`TlsVersion`](#tlsversion) | singular | — |
| `http_behavior` | `httpBehavior` | [`TlsHttpBehavior`](#tlshttpbehavior) | singular | — |

### UpstreamEndpoint

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `url` | `url` | `string` | singular | — |
| `weight` | `weight` | `int32` | singular | — |
| `health_check_path` | `healthCheckPath` | `string` | singular | — |

### WafConfig

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enabled` | `enabled` | `bool` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `mode` | `mode` | [`WafMode`](#wafmode) | singular | — |

## Enums

### BlockingMode

| Value | Number | Description |
|---|---|---|
| `BLOCKING_MODE_UNSPECIFIED` | 0 | — |
| `BLOCKING_MODE_ANOMALY` | 1 | — |
| `BLOCKING_MODE_SELF_CONTAINED` | 2 | — |

### EngineState

| Value | Number | Description |
|---|---|---|
| `ENGINE_STATE_UNSPECIFIED` | 0 | — |
| `ENGINE_STATE_ON` | 1 | — |
| `ENGINE_STATE_DETECTION_ONLY` | 2 | — |
| `ENGINE_STATE_OFF` | 3 | — |

### ResourceStatus

| Value | Number | Description |
|---|---|---|
| `RESOURCE_STATUS_UNSPECIFIED` | 0 | — |
| `RESOURCE_STATUS_ACTIVE` | 1 | — |
| `RESOURCE_STATUS_DISABLED` | 2 | — |
| `RESOURCE_STATUS_DELETED` | 3 | — |
| `RESOURCE_STATUS_ERROR` | 4 | — |

### SecurityEventOutcome

SecurityEventOutcome is the canonical transaction-result filter used by SecurityFact queries. UNSPECIFIED is invalid on requests.

| Value | Number | Description |
|---|---|---|
| `SECURITY_EVENT_OUTCOME_UNSPECIFIED` | 0 | — |
| `SECURITY_EVENT_OUTCOME_ANY` | 1 | — |
| `SECURITY_EVENT_OUTCOME_BLOCKED` | 2 | — |
| `SECURITY_EVENT_OUTCOME_PASSED` | 3 | — |

### TlsHttpBehavior

| Value | Number | Description |
|---|---|---|
| `TLS_HTTP_BEHAVIOR_UNSPECIFIED` | 0 | — |
| `TLS_HTTP_BEHAVIOR_REDIRECT_TO_HTTPS` | 1 | — |
| `TLS_HTTP_BEHAVIOR_ACME_ONLY` | 2 | — |
| `TLS_HTTP_BEHAVIOR_SERVE_BOTH` | 3 | — |

### TlsMode

| Value | Number | Description |
|---|---|---|
| `TLS_MODE_UNSPECIFIED` | 0 | — |
| `TLS_MODE_NONE` | 1 | — |
| `TLS_MODE_MANAGED_ACME` | 2 | — |
| `TLS_MODE_UPLOADED` | 3 | — |

### TlsVersion

| Value | Number | Description |
|---|---|---|
| `TLS_VERSION_UNSPECIFIED` | 0 | — |
| `TLS_VERSION_1_2` | 1 | — |
| `TLS_VERSION_1_3` | 2 | — |

### WafMode

| Value | Number | Description |
|---|---|---|
| `WAF_MODE_UNSPECIFIED` | 0 | — |
| `WAF_MODE_BLOCKING` | 1 | — |
| `WAF_MODE_DETECTION` | 2 | — |
