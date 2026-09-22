<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# log.proto — Observation v2: events, evidence, exports, log policy

Schema: `tiyi.v1` · `log.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### LogService

| RPC | Kind | Required permission |
|---|---|---|
| [`GetGlobalLogPolicy`](#logservicegetgloballogpolicy) | unary | (`system:read`) |
| [`UpdateGlobalLogPolicy`](#logserviceupdategloballogpolicy) | unary | (`system:write`) |
| [`GetSiteLogPolicy`](#logservicegetsitelogpolicy) | unary | (`site:read`) |
| [`UpsertSiteLogPolicyOverride`](#logserviceupsertsitelogpolicyoverride) | unary | (`site:write`) |
| [`DeleteSiteLogPolicyOverride`](#logservicedeletesitelogpolicyoverride) | unary | (`site:write`) |
| [`QuerySecurityEvents`](#logservicequerysecurityevents) | unary | (`log:read`) |
| [`QueryAccessEvents`](#logservicequeryaccessevents) | unary | (`log:read`) |
| [`QueryErrorEvents`](#logservicequeryerrorevents) | unary | (`log:read`) |
| [`GetSecurityEvent`](#logservicegetsecurityevent) | unary | (`log:read`) |
| [`GetAccessEvent`](#logservicegetaccessevent) | unary | (`log:read`) |
| [`GetErrorEvent`](#logservicegeterrorevent) | unary | (`log:read`) |
| [`TailSecurityEvents`](#logservicetailsecurityevents) | server stream | (`log:read`) |
| [`ExportSecurityEvents`](#logserviceexportsecurityevents) | unary | (`log:export`) |
| [`ExportAccessEvents`](#logserviceexportaccessevents) | unary | (`log:export`) |
| [`ExportErrorEvents`](#logserviceexporterrorevents) | unary | (`log:export`) |
| [`GetAccessLogSummary`](#logservicegetaccesslogsummary) | unary | (`log:read`) |
| [`GetAccessLogRankings`](#logservicegetaccesslogrankings) | unary | (`log:read`) |
| [`GetSecurityLogSummary`](#logservicegetsecuritylogsummary) | unary | (`log:read`) |
| [`GetRequestEvidenceMetadata`](#logservicegetrequestevidencemetadata) | unary | (`log:read`) |
| [`GetRequestEvidenceHeaders`](#logservicegetrequestevidenceheaders) | unary | (`log:read`) |
| [`StreamRequestEvidenceBody`](#logservicestreamrequestevidencebody) | server stream | (`log:read`) |
| [`DownloadRequestEvidenceBody`](#logservicedownloadrequestevidencebody) | server stream | (`log:read`) |

## RPCs

### LogService.GetGlobalLogPolicy

- **Procedure** `POST /tiyi.v1.LogService/GetGlobalLogPolicy`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.GetGlobalLogPolicyRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetGlobalLogPolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`GlobalLogPolicy`](#globallogpolicy) | singular | — |
| `storage_health` | `storageHealth` | [`LogStorageHealth`](#logstoragehealth) | singular | — |

### LogService.UpdateGlobalLogPolicy

- **Procedure** `POST /tiyi.v1.LogService/UpdateGlobalLogPolicy`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.UpdateGlobalLogPolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`LogPolicy`](#logpolicy) | singular | — |
| `expected_revision` | `expectedRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `acknowledge_storage_risk` | `acknowledgeStorageRisk` | `bool` | singular | Required for storage-intensive combinations such as full request-body capture or retaining evidence for every Access row. |

**Response** — `tiyi.v1.UpdateGlobalLogPolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`GlobalLogPolicy`](#globallogpolicy) | singular | — |
| `storage_health` | `storageHealth` | [`LogStorageHealth`](#logstoragehealth) | singular | — |

### LogService.GetSiteLogPolicy

- **Procedure** `POST /tiyi.v1.LogService/GetSiteLogPolicy`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetSiteLogPolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSiteLogPolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`ResolvedLogPolicy`](#resolvedlogpolicy) | singular | — |
| `override` | `override` | [`SiteLogPolicyOverride`](#sitelogpolicyoverride) | singular | — |

### LogService.UpsertSiteLogPolicyOverride

- **Procedure** `POST /tiyi.v1.LogService/UpsertSiteLogPolicyOverride`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.UpsertSiteLogPolicyOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override` | `override` | [`SiteLogPolicyOverride`](#sitelogpolicyoverride) | singular | — |
| `expected_revision` | `expectedRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.UpsertSiteLogPolicyOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`ResolvedLogPolicy`](#resolvedlogpolicy) | singular | — |
| `override` | `override` | [`SiteLogPolicyOverride`](#sitelogpolicyoverride) | singular | — |

### LogService.DeleteSiteLogPolicyOverride

- **Procedure** `POST /tiyi.v1.LogService/DeleteSiteLogPolicyOverride`
- **Kind** unary
- **Auth** (`site:write`)

**Request** — `tiyi.v1.DeleteSiteLogPolicyOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `expected_revision` | `expectedRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.DeleteSiteLogPolicyOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`ResolvedLogPolicy`](#resolvedlogpolicy) | singular | — |

### LogService.QuerySecurityEvents

- **Procedure** `POST /tiyi.v1.LogService/QuerySecurityEvents`
- **Kind** unary
- **Auth** (`log:read`)

<a id="querysecurityeventsrequest"></a>
**Request** — `tiyi.v1.QuerySecurityEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`CursorRequest`](common.md#cursorrequest) | singular | — |
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `unique_id` | `uniqueId` | `string` | singular | — |
| `client_ip_cidrs` | `clientIpCidrs` | `string` | repeated | — |
| `rule_ids` | `ruleIds` | `string` | repeated | — |
| `attack_types` | `attackTypes` | `string` | repeated | — |
| `target_identity` | `targetIdentity` | `string` | singular | — |
| `outcome` | `outcome` | [`SecurityEventOutcome`](common.md#securityeventoutcome) | singular | — |
| `minimum_severity` | `minimumSeverity` | `string` | singular | Include this severity and more severe facts. Empty means any severity; supported values: critical, error, warning, notice, info, debug. |

**Response** — `tiyi.v1.QuerySecurityEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`SecurityEvent`](#securityevent) | repeated | — |
| `page` | `page` | [`CursorResponse`](common.md#cursorresponse) | singular | — |

### LogService.QueryAccessEvents

- **Procedure** `POST /tiyi.v1.LogService/QueryAccessEvents`
- **Kind** unary
- **Auth** (`log:read`)

<a id="queryaccesseventsrequest"></a>
**Request** — `tiyi.v1.QueryAccessEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`CursorRequest`](common.md#cursorrequest) | singular | — |
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `unique_id` | `uniqueId` | `string` | singular | — |
| `client_ip_cidrs` | `clientIpCidrs` | `string` | repeated | — |
| `statuses` | `statuses` | `int32` | repeated | — |
| `method` | `method` | `string` | singular | — |
| `path_prefix` | `pathPrefix` | `string` | singular | — |
| `route_id` | `routeId` | `string` | singular | — |
| `upstream_id` | `upstreamId` | `string` | singular | — |

**Response** — `tiyi.v1.QueryAccessEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AccessEvent`](#accessevent) | repeated | — |
| `page` | `page` | [`CursorResponse`](common.md#cursorresponse) | singular | — |
| `detail_policy_annotations` | `detailPolicyAnnotations` | [`DetailPolicyAnnotation`](#detailpolicyannotation) | repeated | — |
| `observation_coverage` | `observationCoverage` | [`ObservationCoverage`](common.md#observationcoverage) | singular | — |

### LogService.QueryErrorEvents

- **Procedure** `POST /tiyi.v1.LogService/QueryErrorEvents`
- **Kind** unary
- **Auth** (`log:read`)

<a id="queryerroreventsrequest"></a>
**Request** — `tiyi.v1.QueryErrorEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`CursorRequest`](common.md#cursorrequest) | singular | — |
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `unique_id` | `uniqueId` | `string` | singular | — |
| `level` | `level` | `string` | singular | — |
| `logger_contains` | `loggerContains` | `string` | singular | — |
| `message_contains` | `messageContains` | `string` | singular | — |

**Response** — `tiyi.v1.QueryErrorEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`ErrorEvent`](#errorevent) | repeated | — |
| `page` | `page` | [`CursorResponse`](common.md#cursorresponse) | singular | — |

### LogService.GetSecurityEvent

- **Procedure** `POST /tiyi.v1.LogService/GetSecurityEvent`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetSecurityEventRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetSecurityEventResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `event` | `event` | [`SecurityEvent`](#securityevent) | singular | — |

### LogService.GetAccessEvent

- **Procedure** `POST /tiyi.v1.LogService/GetAccessEvent`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetAccessEventRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAccessEventResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `event` | `event` | [`AccessEvent`](#accessevent) | singular | — |

### LogService.GetErrorEvent

- **Procedure** `POST /tiyi.v1.LogService/GetErrorEvent`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetErrorEventRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetErrorEventResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `event` | `event` | [`ErrorEvent`](#errorevent) | singular | — |

### LogService.TailSecurityEvents

- **Procedure** `POST /tiyi.v1.LogService/TailSecurityEvents`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** (`log:read`)

**Request** — `tiyi.v1.TailSecurityEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |

**Response** — `tiyi.v1.TailSecurityEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `event` | `event` | [`SecurityEvent`](#securityevent) | singular | — |
| `skipped_events` | `skippedEvents` | `uint64` | singular | Events intentionally omitted by the bounded live-tail transport since the previous response. This does not delete admitted historical facts or alter exact counters. Reconnect gaps have no replay guarantee. _JSON string (64-bit ints are quoted)._ |
| `heartbeat_at` | `heartbeatAt` | `google.protobuf.Timestamp` | singular | Sent immediately on connection and every ten seconds while idle. _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### LogService.ExportSecurityEvents

- **Procedure** `POST /tiyi.v1.LogService/ExportSecurityEvents`
- **Kind** unary
- **Auth** (`log:export`)

**Request** — `tiyi.v1.ExportSecurityEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | [`QuerySecurityEventsRequest`](#querysecurityeventsrequest) | singular | Complete list query; pagination is owned by the exporter. |

**Response** — `tiyi.v1.ExportSecurityEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ndjson` | `ndjson` | `bytes` | singular | _base64-encoded JSON string._ |
| `filename` | `filename` | `string` | singular | — |

### LogService.ExportAccessEvents

- **Procedure** `POST /tiyi.v1.LogService/ExportAccessEvents`
- **Kind** unary
- **Auth** (`log:export`)

**Request** — `tiyi.v1.ExportAccessEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | [`QueryAccessEventsRequest`](#queryaccesseventsrequest) | singular | Complete list query; pagination is owned by the exporter. |

**Response** — `tiyi.v1.ExportAccessEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ndjson` | `ndjson` | `bytes` | singular | _base64-encoded JSON string._ |
| `filename` | `filename` | `string` | singular | — |

### LogService.ExportErrorEvents

- **Procedure** `POST /tiyi.v1.LogService/ExportErrorEvents`
- **Kind** unary
- **Auth** (`log:export`)

**Request** — `tiyi.v1.ExportErrorEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | [`QueryErrorEventsRequest`](#queryerroreventsrequest) | singular | — |

**Response** — `tiyi.v1.ExportErrorEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ndjson` | `ndjson` | `bytes` | singular | _base64-encoded JSON string._ |
| `filename` | `filename` | `string` | singular | — |

### LogService.GetAccessLogSummary

- **Procedure** `POST /tiyi.v1.LogService/GetAccessLogSummary`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetAccessLogSummaryRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetAccessLogSummaryResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `errors` | `errors` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `avg_duration_ms` | `avgDurationMs` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `total_bytes` | `totalBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `trend` | `trend` | [`LogTrendBucket`](#logtrendbucket) | repeated | — |
| `top_statuses` | `topStatuses` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `top_methods` | `topMethods` | [`LogTopEntry`](#logtopentry) | repeated | — |

### LogService.GetAccessLogRankings

- **Procedure** `POST /tiyi.v1.LogService/GetAccessLogRankings`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetAccessLogRankingsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `dimension` | `dimension` | [`AccessLogRankingDimension`](#accesslogrankingdimension) | singular | — |

**Response** — `tiyi.v1.GetAccessLogRankingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `entries` | `entries` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `retained_detail_count` | `retainedDetailCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### LogService.GetSecurityLogSummary

- **Procedure** `POST /tiyi.v1.LogService/GetSecurityLogSummary`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetSecurityLogSummaryRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | [`QuerySecurityEventsRequest`](#querysecurityeventsrequest) | singular | Same filter contract as the event list; page is ignored. |
| `top_limit` | `topLimit` | `uint32` | singular | — |
| `dimensions` | `dimensions` | [`SecuritySummaryDimension`](#securitysummarydimension) | repeated | Only these rankings are calculated. Empty means totals only. |
| `include_trend` | `includeTrend` | `bool` | singular | Trends are calculated only when explicitly requested. |

**Response** — `tiyi.v1.GetSecurityLogSummaryResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `total` | `total` | `int64` | singular | Exact totals over admitted compact facts; independent of local detail mode. _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `passed` | `passed` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `trend` | `trend` | [`LogTrendBucket`](#logtrendbucket) | repeated | — |
| `top_ips` | `topIps` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `top_paths` | `topPaths` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `top_rules` | `topRules` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `top_methods` | `topMethods` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `top_attack_types` | `topAttackTypes` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `top_targets` | `topTargets` | [`LogTopEntry`](#logtopentry) | repeated | — |
| `top_sites` | `topSites` | [`LogTopEntry`](#logtopentry) | repeated | — |

### LogService.GetRequestEvidenceMetadata

- **Procedure** `POST /tiyi.v1.LogService/GetRequestEvidenceMetadata`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetRequestEvidenceMetadataRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `request_id` | `requestId` | `string` | singular | — |

**Response** — `tiyi.v1.GetRequestEvidenceMetadataResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence` | `evidence` | [`RequestEvidenceMetadata`](#requestevidencemetadata) | singular | — |

### LogService.GetRequestEvidenceHeaders

- **Procedure** `POST /tiyi.v1.LogService/GetRequestEvidenceHeaders`
- **Kind** unary
- **Auth** (`log:read`)

**Request** — `tiyi.v1.GetRequestEvidenceHeadersRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |

**Response** — `tiyi.v1.GetRequestEvidenceHeadersResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `headers` | `headers` | [`RequestEvidenceHeader`](#requestevidenceheader) | repeated | — |

### LogService.StreamRequestEvidenceBody

- **Procedure** `POST /tiyi.v1.LogService/StreamRequestEvidenceBody`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** (`log:read`)

**Request** — `tiyi.v1.StreamRequestEvidenceBodyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `offset` | `offset` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `limit` | `limit` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.StreamRequestEvidenceBodyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `data` | `data` | `bytes` | singular | _base64-encoded JSON string._ |
| `offset` | `offset` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `eof` | `eof` | `bool` | singular | — |

### LogService.DownloadRequestEvidenceBody

- **Procedure** `POST /tiyi.v1.LogService/DownloadRequestEvidenceBody`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** (`log:read`)

**Request** — `tiyi.v1.DownloadRequestEvidenceBodyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `offset` | `offset` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `limit` | `limit` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.DownloadRequestEvidenceBodyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `data` | `data` | `bytes` | singular | _base64-encoded JSON string._ |
| `offset` | `offset` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `eof` | `eof` | `bool` | singular | — |

## Messages

### AccessEvent

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `unique_id` | `uniqueId` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `occurred_at` | `occurredAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `client_ip` | `clientIp` | `string` | singular | — |
| `method` | `method` | `string` | singular | — |
| `host` | `host` | `string` | singular | — |
| `path` | `path` | `string` | singular | — |
| `status` | `status` | `int32` | singular | — |
| `duration_ms` | `durationMs` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bytes_read` | `bytesRead` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bytes_written` | `bytesWritten` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `raw` | `raw` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `route_id` | `routeId` | `string` | singular | — |
| `upstream_id` | `upstreamId` | `string` | singular | — |
| `detail_selection` | `detailSelection` | [`DetailSelection`](#detailselection) | singular | — |
| `request_id` | `requestId` | `string` | singular | — |
| `request_evidence` | `requestEvidence` | [`RequestEvidenceSummary`](#requestevidencesummary) | singular | — |
| `user_agent` | `userAgent` | `string` | singular | Raw, bounded self-reported value retained only on selected access detail and SIEM records. Exact UA Top uses a separate fixed classifier. |
| `http_version` | `httpVersion` | `string` | singular | Client-to-Tiyi application protocol negotiated for this request. |
| `transport_version` | `transportVersion` | `string` | singular | Client-to-Tiyi transport security version, or PLAINTEXT. |

### DetailPolicyAnnotation

Current policy snapshot for the selected site or sites represented on this page. It does not attest to completeness of the historical query window.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `configured` | `configured` | [`LogDetailMode`](#logdetailmode) | singular | — |
| `effective` | `effective` | [`LogDetailMode`](#logdetailmode) | singular | — |
| `reason` | `reason` | `string` | singular | effective is UNSPECIFIED when no matching applied runtime is observable. |
| `configured_source` | `configuredSource` | `string` | singular | — |
| `observed_at` | `observedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `agent_id` | `agentId` | `string` | singular | — |

### DetailSelection

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `retention_tier` | `retentionTier` | [`DetailRetentionTier`](#detailretentiontier) | singular | — |
| `capture_reasons` | `captureReasons` | `string` | repeated | — |
| `sample_window` | `sampleWindow` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `reservoir_score_hex` | `reservoirScoreHex` | `string` | singular | — |
| `evidence_bundle_id` | `evidenceBundleId` | `string` | singular | — |
| `policy_revision` | `policyRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `selection_flags` | `selectionFlags` | `uint32` | singular | — |
| `feature_count` | `featureCount` | `int32` | singular | — |

### ErrorEvent

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `unique_id` | `uniqueId` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `occurred_at` | `occurredAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `level` | `level` | `string` | singular | — |
| `logger` | `logger` | `string` | singular | — |
| `message` | `message` | `string` | singular | — |
| `raw` | `raw` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `detail_selection` | `detailSelection` | [`DetailSelection`](#detailselection) | singular | — |

### GlobalLogPolicy

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`LogPolicy`](#logpolicy) | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### LogPolicy

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `access_mode` | `accessMode` | [`LogDetailMode`](#logdetailmode) | singular | — |
| `security_mode` | `securityMode` | [`LogDetailMode`](#logdetailmode) | singular | — |
| `access_full_retention_days` | `accessFullRetentionDays` | `int32` | singular | — |
| `security_full_retention_days` | `securityFullRetentionDays` | `int32` | singular | — |
| `exemplar_retention_days` | `exemplarRetentionDays` | `int32` | singular | — |
| `security_fact_retention_days` | `securityFactRetentionDays` | `int32` | singular | — |
| `evidence_pairing` | `evidencePairing` | `bool` | singular | — |
| `status_exemplar_k` | `statusExemplarK` | `int32` | singular | — |
| `api_exemplar_k` | `apiExemplarK` | `int32` | singular | — |
| `security_exemplar_k` | `securityExemplarK` | `int32` | singular | — |
| `sample_window_seconds` | `sampleWindowSeconds` | `int32` | singular | — |
| `pressure_policy` | `pressurePolicy` | [`LogPressurePolicy`](#logpressurepolicy) | singular | — |
| `request_evidence_mode` | `requestEvidenceMode` | [`RequestEvidenceMode`](#requestevidencemode) | singular | — |
| `request_evidence_header_max_bytes` | `requestEvidenceHeaderMaxBytes` | `int32` | singular | — |
| `request_evidence_body_mode` | `requestEvidenceBodyMode` | [`RequestEvidenceBodyMode`](#requestevidencebodymode) | singular | — |
| `request_evidence_body_max_bytes` | `requestEvidenceBodyMaxBytes` | `int32` | singular | — |
| `request_evidence_retention_days` | `requestEvidenceRetentionDays` | `int32` | singular | — |
| `request_evidence_inflight_max_bytes` | `requestEvidenceInflightMaxBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `request_evidence_finalized_queue_max_bytes` | `requestEvidenceFinalizedQueueMaxBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `schema_violation_details` | `schemaViolationDetails` | `bool` | singular | — |

### LogPolicySources

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `access_mode` | `accessMode` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `security_mode` | `securityMode` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `access_full_retention_days` | `accessFullRetentionDays` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `security_full_retention_days` | `securityFullRetentionDays` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `exemplar_retention_days` | `exemplarRetentionDays` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `security_fact_retention_days` | `securityFactRetentionDays` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `evidence_pairing` | `evidencePairing` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `status_exemplar_k` | `statusExemplarK` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `api_exemplar_k` | `apiExemplarK` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `security_exemplar_k` | `securityExemplarK` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `sample_window_seconds` | `sampleWindowSeconds` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `pressure_policy` | `pressurePolicy` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `request_evidence_mode` | `requestEvidenceMode` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `request_evidence_header_max_bytes` | `requestEvidenceHeaderMaxBytes` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `request_evidence_body_mode` | `requestEvidenceBodyMode` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `request_evidence_body_max_bytes` | `requestEvidenceBodyMaxBytes` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `request_evidence_retention_days` | `requestEvidenceRetentionDays` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `request_evidence_inflight_max_bytes` | `requestEvidenceInflightMaxBytes` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `request_evidence_finalized_queue_max_bytes` | `requestEvidenceFinalizedQueueMaxBytes` | [`LogPolicySource`](#logpolicysource) | singular | — |
| `schema_violation_details` | `schemaViolationDetails` | [`LogPolicySource`](#logpolicysource) | singular | — |

### LogStorageHealth

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `status` | `status` | [`LogStorageHealthStatus`](#logstoragehealthstatus) | singular | — |
| `managed_bytes` | `managedBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `filesystem_total_bytes` | `filesystemTotalBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `filesystem_available_bytes` | `filesystemAvailableBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `growth_bytes_per_day` | `growthBytesPerDay` | `double` | singular | Signed window changes are floored at zero only after measuring the window. |
| `estimate_state` | `estimateState` | [`LogStorageEstimateState`](#logstorageestimatestate) | singular | — |
| `estimated_remaining_seconds` | `estimatedRemainingSeconds` | `int64` | singular | Valid only for PRELIMINARY / READY, as of calculated_at. _JSON string (64-bit ints are quoted)._ |
| `evidence_stored_bytes` | `evidenceStoredBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `evidence_staged_bytes` | `evidenceStagedBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `pending_bytes` | `pendingBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `evidence_quota_bytes` | `evidenceQuotaBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `quota_rejected` | `quotaRejected` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `write_failed` | `writeFailed` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `observed_at` | `observedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `calculated_at` | `calculatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `observation_window_seconds` | `observationWindowSeconds` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### LogTopEntry

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `key` | `key` | `string` | singular | — |
| `count` | `count` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `label` | `label` | `string` | singular | Human-friendly label for the key, when one is available. For the security-log top-rules aggregation this is the matched CRS rule message (for example "SQL Injection Attack Detected via libinjection" for rule 942100). Empty when the aggregator has no enrichment. |
| `geo` | `geo` | [`NetworkGeo`](common.md#networkgeo) | singular | Present when the key is a source IP and a local GeoIP dataset resolves it. This describes the observed network exit, not a physical attacker location. |

### LogTrendBucket

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time` | `time` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `count` | `count` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `errors` | `errors` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### RequestEvidenceHeader

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `values` | `values` | `string` | repeated | — |

### RequestEvidenceMetadata

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `request_id` | `requestId` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `started_at` | `startedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `completed_at` | `completedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `reason` | `reason` | `string` | singular | — |
| `method` | `method` | `string` | singular | — |
| `host` | `host` | `string` | singular | — |
| `request_target` | `requestTarget` | `string` | singular | — |
| `content_type` | `contentType` | `string` | singular | — |
| `content_encoding` | `contentEncoding` | `string` | singular | — |
| `transfer_encodings` | `transferEncodings` | `string` | repeated | — |
| `content_length` | `contentLength` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `header_original_bytes` | `headerOriginalBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `header_captured_bytes` | `headerCapturedBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `header_truncated` | `headerTruncated` | `bool` | singular | — |
| `body_original_bytes` | `bodyOriginalBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `body_captured_bytes` | `bodyCapturedBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `body_truncated` | `bodyTruncated` | `bool` | singular | — |
| `unavailable_reason` | `unavailableReason` | `string` | singular | — |

### RequestEvidenceSummary

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `available` | `available` | `bool` | singular | — |
| `header_original_bytes` | `headerOriginalBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `header_captured_bytes` | `headerCapturedBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `header_truncated` | `headerTruncated` | `bool` | singular | — |
| `body_original_bytes` | `bodyOriginalBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `body_captured_bytes` | `bodyCapturedBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `body_truncated` | `bodyTruncated` | `bool` | singular | — |
| `unavailable_reason` | `unavailableReason` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### ResolvedLogPolicy

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `inherited` | `inherited` | [`LogPolicy`](#logpolicy) | singular | — |
| `configured` | `configured` | [`LogPolicy`](#logpolicy) | singular | — |
| `effective` | `effective` | [`LogPolicy`](#logpolicy) | singular | — |
| `configured_sources` | `configuredSources` | [`LogPolicySources`](#logpolicysources) | singular | — |
| `effective_sources` | `effectiveSources` | [`LogPolicySources`](#logpolicysources) | singular | — |
| `global_revision` | `globalRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `site_revision` | `siteRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `safety_epoch` | `safetyEpoch` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### SecurityEvent

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `unique_id` | `uniqueId` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `occurred_at` | `occurredAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `client_ip` | `clientIp` | `string` | singular | — |
| `method` | `method` | `string` | singular | — |
| `path` | `path` | `string` | singular | — |
| `status` | `status` | `int32` | singular | — |
| `blocked` | `blocked` | `bool` | singular | — |
| `messages` | `messages` | [`SecurityMessage`](#securitymessage) | repeated | — |
| `raw` | `raw` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `detail_selection` | `detailSelection` | [`DetailSelection`](#detailselection) | singular | — |
| `attack_type` | `attackType` | `string` | singular | — |
| `attack_types` | `attackTypes` | `string` | repeated | — |
| `target_identity` | `targetIdentity` | `string` | singular | — |
| `severity` | `severity` | `string` | singular | — |
| `anomaly_score` | `anomalyScore` | `int32` | singular | — |
| `rule_match_count` | `ruleMatchCount` | `int32` | singular | — |
| `rule_ids` | `ruleIds` | `string` | repeated | — |
| `tags` | `tags` | `string` | repeated | — |
| `detail_available` | `detailAvailable` | `bool` | singular | detail_available is true only when this response includes retained Full/Exemplar review payload. Compact fact fields above are always exact. |
| `request_id` | `requestId` | `string` | singular | — |
| `request_evidence` | `requestEvidence` | [`RequestEvidenceSummary`](#requestevidencesummary) | singular | — |
| `http_version` | `httpVersion` | `string` | singular | Client-to-Tiyi application protocol negotiated for this request. |
| `transport_version` | `transportVersion` | `string` | singular | Client-to-Tiyi transport security version, or PLAINTEXT. |

### SecurityMessage

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule_id` | `ruleId` | `string` | singular | — |
| `severity` | `severity` | `string` | singular | — |
| `message` | `message` | `string` | singular | — |
| `error_message` | `errorMessage` | `string` | singular | — |
| `tags` | `tags` | `string` | repeated | — |
| `match_variable` | `matchVariable` | `string` | singular | Structured Coraza match evidence. match_value is the bounded value as evaluated by the WAF after rule transformations; it is not redacted. |
| `match_key` | `matchKey` | `string` | singular | — |
| `match_value` | `matchValue` | `string` | singular | — |
| `match_data` | `matchData` | `string` | singular | — |
| `matched_text` | `matchedText` | `string` | singular | — |
| `phase` | `phase` | `int32` | singular | — |
| `operator` | `operator` | `string` | singular | — |
| `disruptive` | `disruptive` | `bool` | singular | — |
| `chain_level` | `chainLevel` | `int32` | singular | — |
| `match_value_truncated` | `matchValueTruncated` | `bool` | singular | — |

### SiteLogPolicyOverride

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `access_mode` | `accessMode` | [`LogDetailMode`](#logdetailmode) | optional (explicit) | — |
| `security_mode` | `securityMode` | [`LogDetailMode`](#logdetailmode) | optional (explicit) | — |
| `access_full_retention_days` | `accessFullRetentionDays` | `int32` | optional (explicit) | — |
| `security_full_retention_days` | `securityFullRetentionDays` | `int32` | optional (explicit) | — |
| `exemplar_retention_days` | `exemplarRetentionDays` | `int32` | optional (explicit) | — |
| `evidence_pairing` | `evidencePairing` | `bool` | optional (explicit) | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `request_evidence_mode` | `requestEvidenceMode` | [`RequestEvidenceMode`](#requestevidencemode) | optional (explicit) | — |
| `schema_violation_details` | `schemaViolationDetails` | `bool` | optional (explicit) | — |

## Enums

### AccessLogRankingDimension

| Value | Number | Description |
|---|---|---|
| `ACCESS_LOG_RANKING_DIMENSION_UNSPECIFIED` | 0 | — |
| `ACCESS_LOG_RANKING_DIMENSION_PATH` | 1 | — |
| `ACCESS_LOG_RANKING_DIMENSION_IP` | 2 | — |
| `ACCESS_LOG_RANKING_DIMENSION_HOST` | 3 | — |

### DetailRetentionTier

| Value | Number | Description |
|---|---|---|
| `DETAIL_RETENTION_TIER_UNSPECIFIED` | 0 | — |
| `DETAIL_RETENTION_TIER_FULL` | 1 | — |
| `DETAIL_RETENTION_TIER_EVIDENCE` | 2 | — |

### LogDetailMode

| Value | Number | Description |
|---|---|---|
| `LOG_DETAIL_MODE_UNSPECIFIED` | 0 | — |
| `LOG_DETAIL_MODE_NONE` | 1 | — |
| `LOG_DETAIL_MODE_EXEMPLARS` | 2 | — |
| `LOG_DETAIL_MODE_ALL` | 3 | — |

### LogPolicySource

| Value | Number | Description |
|---|---|---|
| `LOG_POLICY_SOURCE_UNSPECIFIED` | 0 | — |
| `LOG_POLICY_SOURCE_GLOBAL` | 1 | — |
| `LOG_POLICY_SOURCE_SITE` | 2 | — |
| `LOG_POLICY_SOURCE_EMERGENCY` | 3 | — |

### LogPressurePolicy

| Value | Number | Description |
|---|---|---|
| `LOG_PRESSURE_POLICY_UNSPECIFIED` | 0 | — |
| `LOG_PRESSURE_POLICY_PROTECT_TRAFFIC` | 1 | — |
| `LOG_PRESSURE_POLICY_REPORT_ONLY` | 2 | — |

### LogStorageEstimateState

| Value | Number | Description |
|---|---|---|
| `LOG_STORAGE_ESTIMATE_STATE_UNSPECIFIED` | 0 | — |
| `LOG_STORAGE_ESTIMATE_STATE_COLLECTING` | 1 | — |
| `LOG_STORAGE_ESTIMATE_STATE_PRELIMINARY` | 2 | — |
| `LOG_STORAGE_ESTIMATE_STATE_READY` | 3 | — |
| `LOG_STORAGE_ESTIMATE_STATE_NOT_GROWING` | 4 | — |
| `LOG_STORAGE_ESTIMATE_STATE_UNAVAILABLE` | 5 | — |

### LogStorageHealthStatus

| Value | Number | Description |
|---|---|---|
| `LOG_STORAGE_HEALTH_STATUS_UNSPECIFIED` | 0 | — |
| `LOG_STORAGE_HEALTH_STATUS_UNKNOWN` | 1 | — |
| `LOG_STORAGE_HEALTH_STATUS_HEALTHY` | 2 | — |
| `LOG_STORAGE_HEALTH_STATUS_WARNING` | 3 | — |
| `LOG_STORAGE_HEALTH_STATUS_CRITICAL` | 4 | — |

### RequestEvidenceBodyMode

| Value | Number | Description |
|---|---|---|
| `REQUEST_EVIDENCE_BODY_MODE_UNSPECIFIED` | 0 | — |
| `REQUEST_EVIDENCE_BODY_MODE_OFF` | 1 | — |
| `REQUEST_EVIDENCE_BODY_MODE_PREFIX` | 2 | — |
| `REQUEST_EVIDENCE_BODY_MODE_FULL` | 3 | — |

### RequestEvidenceMode

| Value | Number | Description |
|---|---|---|
| `REQUEST_EVIDENCE_MODE_UNSPECIFIED` | 0 | — |
| `REQUEST_EVIDENCE_MODE_OFF` | 1 | — |
| `REQUEST_EVIDENCE_MODE_SECURITY_ONLY` | 2 | — |
| `REQUEST_EVIDENCE_MODE_RETAINED_LOGS` | 3 | — |

### SecuritySummaryDimension

| Value | Number | Description |
|---|---|---|
| `SECURITY_SUMMARY_DIMENSION_UNSPECIFIED` | 0 | — |
| `SECURITY_SUMMARY_DIMENSION_ATTACKER` | 1 | — |
| `SECURITY_SUMMARY_DIMENSION_SITE` | 2 | — |
| `SECURITY_SUMMARY_DIMENSION_TARGET` | 3 | — |
| `SECURITY_SUMMARY_DIMENSION_ATTACK_TYPE` | 4 | — |
| `SECURITY_SUMMARY_DIMENSION_PATH` | 5 | — |
| `SECURITY_SUMMARY_DIMENSION_RULE` | 6 | — |
| `SECURITY_SUMMARY_DIMENSION_METHOD` | 7 | — |
