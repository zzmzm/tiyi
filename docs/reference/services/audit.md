<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# audit.proto — Tamper-evident audit chain

Schema: `tiyi.v1` · `audit.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### AuditService

| RPC | Kind | Required permission |
|---|---|---|
| [`QueryAudit`](#auditservicequeryaudit) | unary | (`audit:read`) |
| [`GetAuditEntry`](#auditservicegetauditentry) | unary | (`audit:read`) |
| [`GetChainStatus`](#auditservicegetchainstatus) | unary | (`audit:read`) |
| [`VerifyChain`](#auditserviceverifychain) | unary | (`audit:verify`) |

## RPCs

### AuditService.QueryAudit

- **Procedure** `POST /tiyi.v1.AuditService/QueryAudit`
- **Kind** unary
- **Auth** (`audit:read`)

**Request** — `tiyi.v1.QueryAuditRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`CursorRequest`](common.md#cursorrequest) | singular | — |
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `actor_id` | `actorId` | `string` | singular | — |
| `action` | `action` | `string` | singular | — |
| `resource_type` | `resourceType` | `string` | singular | — |
| `resource_id` | `resourceId` | `string` | singular | — |
| `actor_query` | `actorQuery` | `string` | singular | — |
| `outcome` | `outcome` | `string` | singular | — |
| `actor_ip` | `actorIp` | `string` | singular | — |

**Response** — `tiyi.v1.QueryAuditResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AuditEntry`](#auditentry) | repeated | — |
| `page` | `page` | [`CursorResponse`](common.md#cursorresponse) | singular | — |
| `total` | `total` | `int64` | singular | Total rows matching the tenant and active filters. Web clients use this with CursorRequest.offset for direct, server-backed page navigation. _JSON string (64-bit ints are quoted)._ |

### AuditService.GetAuditEntry

- **Procedure** `POST /tiyi.v1.AuditService/GetAuditEntry`
- **Kind** unary
- **Auth** (`audit:read`)

**Request** — `tiyi.v1.GetAuditEntryRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAuditEntryResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `entry` | `entry` | [`AuditEntry`](#auditentry) | singular | — |

### AuditService.GetChainStatus

- **Procedure** `POST /tiyi.v1.AuditService/GetChainStatus`
- **Kind** unary
- **Auth** (`audit:read`)

**Request** — `tiyi.v1.GetChainStatusRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetChainStatusResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `healthy` | `healthy` | `bool` | singular | — |
| `latest_hash` | `latestHash` | `string` | singular | — |
| `latest_verified_at` | `latestVerifiedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `breaks` | `breaks` | [`ChainBreak`](#chainbreak) | repeated | — |
| `checked_rows` | `checkedRows` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AuditService.VerifyChain

- **Procedure** `POST /tiyi.v1.AuditService/VerifyChain`
- **Kind** unary
- **Auth** (`audit:verify`)

**Request** — `tiyi.v1.VerifyChainRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |

**Response** — `tiyi.v1.VerifyChainResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `healthy` | `healthy` | `bool` | singular | — |
| `breaks` | `breaks` | [`ChainBreak`](#chainbreak) | repeated | — |
| `verified_at` | `verifiedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `checked_rows` | `checkedRows` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `latest_hash` | `latestHash` | `string` | singular | — |

## Messages

### AuditEntry

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `actor_id` | `actorId` | `string` | singular | — |
| `action` | `action` | `string` | singular | — |
| `resource_type` | `resourceType` | `string` | singular | — |
| `resource_id` | `resourceId` | `string` | singular | — |
| `diff` | `diff` | [`JsonPatch`](common.md#jsonpatch) | singular | — |
| `prev_hash` | `prevHash` | `string` | singular | — |
| `hash` | `hash` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `metadata` | `metadata` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `actor_name` | `actorName` | `string` | singular | Current display name (falling back to username) for the canonical actor_id. |
| `resource_name` | `resourceName` | `string` | singular | Best-effort resource label captured from this row's immutable diff. |

### ChainBreak

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `row_id` | `rowId` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `expected_prev_hash` | `expectedPrevHash` | `string` | singular | — |
| `actual_prev_hash` | `actualPrevHash` | `string` | singular | — |
| `expected_row_hash` | `expectedRowHash` | `string` | singular | — |
| `actual_row_hash` | `actualRowHash` | `string` | singular | — |
