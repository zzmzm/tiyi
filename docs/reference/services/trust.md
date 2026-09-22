<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# trust.proto — Client-IP trust profiles and resolved IP Lists

Schema: `tiyi.v1` · `trust.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### TrustService

| RPC | Kind | Required permission |
|---|---|---|
| [`GetTrustProfile`](#trustservicegettrustprofile) | unary | (`system:read`) |
| [`SetTrustProfile`](#trustservicesettrustprofile) | unary | (`system:write`) |
| [`ResetTrustProfile`](#trustserviceresettrustprofile) | unary | (`system:write`) |
| [`ExplainTrust`](#trustserviceexplaintrust) | unary | (`system:read`) |
| [`GetTrustStatus`](#trustservicegettruststatus) | unary | (`system:read`) |
| [`StartClientIPAnalysis`](#trustservicestartclientipanalysis) | unary | (`system:write`) |
| [`GetClientIPAnalysis`](#trustservicegetclientipanalysis) | unary | (`system:read`) |
| [`StopClientIPAnalysis`](#trustservicestopclientipanalysis) | unary | (`system:write`) |
| [`ApplyClientIPAnalysis`](#trustserviceapplyclientipanalysis) | unary | (`system:write`) |

## RPCs

### TrustService.GetTrustProfile

GetTrustProfile returns the deployment-wide profile. When site_id is set, returns the per-site override (or NotFound when no override is set). Use ExplainTrust for the resolved profile the data plane actually loads.

- **Procedure** `POST /tiyi.v1.TrustService/GetTrustProfile`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.GetTrustProfileRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | site_id selects a per-site override; empty returns the global default. |

**Response** — `tiyi.v1.GetTrustProfileResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `profile` | `profile` | [`TrustProfile`](#trustprofile) | singular | — |
| `resolved` | `resolved` | [`ResolvedTrustProfile`](#resolvedtrustprofile) | singular | resolved is the request-ready graph: referenced IP Lists are attached to their owning proxy nodes and extraction Headers are canonicalised. |

### TrustService.SetTrustProfile

SetTrustProfile replaces the operator-authored profile JSON. The handler runs ValidateProfile; rejection returns an InvalidArgument carrying TrustProfileValidation as details.

- **Procedure** `POST /tiyi.v1.TrustService/SetTrustProfile`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.SetTrustProfileRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | empty ⇒ global default |
| `profile` | `profile` | [`TrustProfile`](#trustprofile) | singular | — |
| `force` | `force` | `bool` | singular | force allows a non-safelisted forwarded header (audited). |

**Response** — `tiyi.v1.SetTrustProfileResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `profile` | `profile` | [`TrustProfile`](#trustprofile) | singular | — |
| `resolved` | `resolved` | [`ResolvedTrustProfile`](#resolvedtrustprofile) | singular | — |

### TrustService.ResetTrustProfile

ResetTrustProfile restores the safe default (empty profile — no proxies trusted, no headers honoured) for the targeted scope.

- **Procedure** `POST /tiyi.v1.TrustService/ResetTrustProfile`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.ResetTrustProfileRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.ResetTrustProfileResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### TrustService.ExplainTrust

ExplainTrust replays a request shape against the active profile or an optional validated draft and returns the same Result the data plane would produce. Powers `tiyi trust test` and the web editor's no-persist preview.

- **Procedure** `POST /tiyi.v1.TrustService/ExplainTrust`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.ExplainTrustRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `peer` | `peer` | `string` | singular | — |
| `headers` | `headers` | map&lt;`string`, `string`&gt; | map | headers is the request shape the operator would like to explain. Empty value strings are skipped. |
| `draft_profile` | `draftProfile` | [`TrustProfile`](#trustprofile) | singular | draft_profile, when present, is validated and explained instead of the saved effective profile. This lets the UI test unsaved edits without changing the live data-plane configuration. |

**Response** — `tiyi.v1.ExplainTrustResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip` | `ip` | `string` | singular | ip is the canonical client IP the data plane would have used. |
| `source_header` | `sourceHeader` | `string` | singular | empty ⇒ peer fallback |
| `peer_trusted` | `peerTrusted` | `bool` | singular | — |
| `spoofed` | `spoofed` | `bool` | singular | — |
| `hops` | `hops` | `string` | repeated | hops is the full forwarded chain the explain call observed, left-to-right as on the wire. |
| `warnings` | `warnings` | `string` | repeated | warnings carries human-readable advisories the CLI renders under the WARNINGS heading (e.g. "header X present but peer not in cloudflare range"). |
| `rule_traces` | `ruleTraces` | [`ClientIPRuleTrace`](#clientipruletrace) | repeated | — |
| `verified_node_ids` | `verifiedNodeIds` | `string` | repeated | — |
| `untrusted_rule` | `untrustedRule` | `bool` | singular | untrusted_rule is true when an allow_untrusted rule supplied the result without a verified proxy path. It is configured risk, not proof of spoofing. |

### TrustService.GetTrustStatus

GetTrustStatus returns the high-level dashboard state: the global profile, per-site override summary, and recent spoof-warning ringbuffer.

- **Procedure** `POST /tiyi.v1.TrustService/GetTrustStatus`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.GetTrustStatusRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetTrustStatusResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `global` | `global` | [`TrustProfile`](#trustprofile) | singular | — |
| `site_overrides` | `siteOverrides` | [`TrustSiteOverride`](#trustsiteoverride) | repeated | per_site overrides list, in stable site_id order. |
| `recent_warnings` | `recentWarnings` | [`TrustSpoofWarning`](#trustspoofwarning) | repeated | recent_warnings is the last hour of spoof-warning summary entries the data plane emitted (rate-limited 1/h/tuple). |
| `total_sites` | `totalSites` | `uint32` | singular | total_sites is the tenant-wide non-deleted site count. It is returned here so global impact copy never depends on filtered list pagination. |

### TrustService.StartClientIPAnalysis

Client-IP analysis is always scoped to one site. It samples a bounded allow-list of IP headers in memory and never changes normal log policy.

- **Procedure** `POST /tiyi.v1.TrustService/StartClientIPAnalysis`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.StartClientIPAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.StartClientIPAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `analysis` | `analysis` | [`ClientIPAnalysis`](#clientipanalysis) | singular | — |

### TrustService.GetClientIPAnalysis

- **Procedure** `POST /tiyi.v1.TrustService/GetClientIPAnalysis`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.GetClientIPAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `analysis_id` | `analysisId` | `string` | singular | — |

**Response** — `tiyi.v1.GetClientIPAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `analysis` | `analysis` | [`ClientIPAnalysis`](#clientipanalysis) | singular | — |

### TrustService.StopClientIPAnalysis

- **Procedure** `POST /tiyi.v1.TrustService/StopClientIPAnalysis`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.StopClientIPAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `analysis_id` | `analysisId` | `string` | singular | — |

**Response** — `tiyi.v1.StopClientIPAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `analysis` | `analysis` | [`ClientIPAnalysis`](#clientipanalysis) | singular | — |

### TrustService.ApplyClientIPAnalysis

- **Procedure** `POST /tiyi.v1.TrustService/ApplyClientIPAnalysis`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.ApplyClientIPAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `analysis_id` | `analysisId` | `string` | singular | — |
| `scope` | `scope` | [`ClientIPAnalysisApplyScope`](#clientipanalysisapplyscope) | singular | — |
| `acknowledge_unverified` | `acknowledgeUnverified` | `bool` | singular | Required when the server-generated candidate is not verified. The web UI makes this acknowledgement explicit beside the action that changes live configuration. |
| `draft_profile` | `draftProfile` | [`TrustProfile`](#trustprofile) | singular | Optional operator-edited form of the server-generated candidate. When an unchanged suggested node has no IP List yet, the server materializes that node's analysed ranges before validating and applying the draft. |
| `node_trust_drafts` | `nodeTrustDrafts` | [`ClientIPAnalysisNodeTrustDraft`](#clientipanalysisnodetrustdraft) | repeated | Optional per-node decisions for the server-held analysed ranges. New web clients send an explicit decision for every suggested node; absence keeps the legacy draft_profile behavior for backwards compatibility. |

**Response** — `tiyi.v1.ApplyClientIPAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `scope` | `scope` | [`ClientIPAnalysisApplyScope`](#clientipanalysisapplyscope) | singular | — |
| `profile` | `profile` | [`TrustProfile`](#trustprofile) | singular | — |
| `resolved` | `resolved` | [`ResolvedTrustProfile`](#resolvedtrustprofile) | singular | — |

## Messages

### ClientIPAnalysis

ClientIPAnalysis is a point-in-time view of one site-only, memory-only diagnostic session.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `state` | `state` | `string` | singular | collecting \| complete \| stopped |
| `started_at` | `startedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `ends_at` | `endsAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `completed_at` | `completedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `sample_count` | `sampleCount` | `uint32` | singular | — |
| `target_sample_count` | `targetSampleCount` | `uint32` | singular | — |
| `distinct_peer_count` | `distinctPeerCount` | `uint32` | singular | — |
| `distinct_client_count` | `distinctClientCount` | `uint32` | singular | — |
| `confidence` | `confidence` | `string` | singular | verified \| partial \| insufficient |
| `suggestion_kind` | `suggestionKind` | `string` | singular | direct \| proxy \| proxy_chain \| fixed |
| `suggestion_header` | `suggestionHeader` | `string` | singular | — |
| `suggested_profile` | `suggestedProfile` | [`TrustProfile`](#trustprofile) | singular | — |
| `paths` | `paths` | [`ClientIPAnalysisPath`](#clientipanalysispath) | repeated | — |
| `findings` | `findings` | `string` | repeated | — |
| `evidence` | `evidence` | `string` | repeated | — |
| `inferences` | `inferences` | `string` | repeated | — |
| `conflicts` | `conflicts` | `string` | repeated | — |
| `node_trust_previews` | `nodeTrustPreviews` | [`ClientIPAnalysisNodeTrustPreview`](#clientipanalysisnodetrustpreview) | repeated | — |

### ClientIPAnalysisNodeTrustDraft

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `mode` | `mode` | [`ClientIPAnalysisRangesMode`](#clientipanalysisrangesmode) | singular | — |
| `ranges` | `ranges` | `string` | repeated | Used only with REPLACE. These transient ranges are validated and materialized as an ordinary manual IP List in the Apply transaction. |

### ClientIPAnalysisNodeTrustPreview

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `suggested_list_name` | `suggestedListName` | `string` | singular | The ordinary manual IP List name that Apply will use if these ranges are retained. Renaming the proxy node before Apply may update this name. |
| `source_kind` | `sourceKind` | `string` | singular | observed_peers \| product_snapshot |
| `entry_count` | `entryCount` | `uint32` | singular | — |
| `ranges` | `ranges` | `string` | repeated | Exact transient candidate content so the operator can review and edit it. It is not an authored TrustSource and is never persisted inline. |

### ClientIPAnalysisPath

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `product_hint` | `productHint` | `string` | singular | Advisory product label inferred from bounded evidence. It is editable suggestion text, not node identity or a trust binding. |
| `header` | `header` | `string` | singular | Strongest Header name supporting this path or advisory product hint. |
| `sample_count` | `sampleCount` | `uint32` | singular | Requests supporting this path. Advisory product signals count at most once per product per request, even when several Headers match. |
| `header_sample_count` | `headerSampleCount` | `uint32` | singular | Requests containing the strongest matching Header signal. |
| `peer_verified` | `peerVerified` | `bool` | singular | — |
| `observed_peers` | `observedPeers` | `string` | repeated | — |
| `confidence` | `confidence` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |

### ClientIPRule

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `header` | `header` | `string` | singular | empty for remote_addr |
| `parser` | `parser` | `string` | singular | single_ip \| xff \| forwarded \| remote_addr |
| `node_ids` | `nodeIds` | `string` | repeated | Alternative Header-writer/source bindings. At least one listed node must be evidenced by a complete surviving topology path. Verified rules always carry explicit bindings; Header names never imply a provider or node. |
| `managed` | `managed` | `bool` | singular | generated from a topology-node suggestion |
| `enabled` | `enabled` | `bool` | singular | — |
| `selector` | `selector` | `string` | singular | selector controls which address is chosen from xff/forwarded list values. Empty selects the verified-path first_untrusted default. Fixed list rules must explicitly use single, leftmost, rightmost, or position. |
| `position` | `position` | `uint32` | singular | One-based; selector=position only. A right-counted position longer than the observed list falls back to the leftmost available address. |
| `position_from` | `positionFrom` | `string` | singular | left \| right; selector=position only |
| `allow_untrusted` | `allowUntrusted` | `bool` | singular | allow_untrusted permits extraction when no selected sender or configured proxy path verifies. The UI uses this for fixed extraction, which does not require proxy ranges and is surfaced as an explicit risk. |

### ClientIPRuleTrace

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule_id` | `ruleId` | `string` | singular | — |
| `header` | `header` | `string` | singular | — |
| `status` | `status` | `string` | singular | used \| skipped \| rejected \| fallback |
| `reason` | `reason` | `string` | singular | — |
| `candidate_ip` | `candidateIp` | `string` | singular | — |
| `path_node_ids` | `pathNodeIds` | `string` | repeated | — |

### ResolvedTrustNode

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `real_ip_header` | `realIpHeader` | `string` | singular | — |
| `trust` | `trust` | [`ResolvedTrustSource`](#resolvedtrustsource) | singular | — |
| `xff_mode` | `xffMode` | `string` | singular | — |

### ResolvedTrustProfile

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `nodes` | `nodes` | [`ResolvedTrustNode`](#resolvedtrustnode) | repeated | — |
| `edges` | `edges` | [`TrustEdge`](#trustedge) | repeated | — |
| `extraction_rules` | `extractionRules` | [`ClientIPRule`](#clientiprule) | repeated | — |

### ResolvedTrustSource

ResolvedTrustProfile is the executable graph loaded by the data plane. Its node ranges contain the current content of referenced IP Lists, so request processing performs no I/O.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_ids` | `ipListIds` | `string` | repeated | — |
| `ranges` | `ranges` | `string` | repeated | — |

### TrustEdge

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `from` | `from` | `string` | singular | node id or the reserved endpoint "internet" |
| `to` | `to` | `string` | singular | node id or the reserved endpoint "tiyi" |

### TrustNode

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | stable profile-local identifier |
| `name` | `name` | `string` | singular | operator-owned label; presets only suggest a value |
| `real_ip_header` | `realIpHeader` | `string` | singular | optional operator-authored Header suggestion |
| `trust` | `trust` | [`TrustSource`](#trustsource) | singular | — |
| `xff_mode` | `xffMode` | `string` | singular | Automatic XFF extraction accepts empty/auto/append/overwrite. A traversed preserve/duplicate/unknown node cannot establish a trusted chain boundary; an overwrite node cannot have another reported trusted hop upstream. |

### TrustProfile

TrustProfile is an executable request-ingress topology. Internet and Tiyi are implicit endpoints; nodes are proxy hops between them, edges describe serial or parallel paths, and extraction_rules are evaluated in priority order against the node-tagged recursive trust state for the request.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `nodes` | `nodes` | [`TrustNode`](#trustnode) | repeated | — |
| `edges` | `edges` | [`TrustEdge`](#trustedge) | repeated | — |
| `extraction_rules` | `extractionRules` | [`ClientIPRule`](#clientiprule) | repeated | — |

### TrustProfileValidation

TrustProfileValidation is attached to InvalidArgument errors returned by SetTrustProfile so the CLI can render line-numbered fix hints (design § 6.3).

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `issues` | `issues` | [`TrustProfileValidationIssue`](#trustprofilevalidationissue) | repeated | — |

### TrustProfileValidationIssue

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `field` | `field` | `string` | singular | e.g. nodes[0].trust.interval |
| `code` | `code` | `string` | singular | stable identifier; switchable on |
| `message` | `message` | `string` | singular | human-readable description |

### TrustSiteOverride

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `primary_host` | `primaryHost` | `string` | singular | — |
| `profile` | `profile` | [`TrustProfile`](#trustprofile) | singular | — |
| `resolved` | `resolved` | [`ResolvedTrustProfile`](#resolvedtrustprofile) | singular | — |

### TrustSource

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_ids` | `ipListIds` | `string` | repeated | Authored profiles contain stable list references only. List content, subscription source, schedule, and sync health are owned by IpListService. |

### TrustSpoofWarning

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `first_seen_at` | `firstSeenAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `site_id` | `siteId` | `string` | singular | — |
| `peer` | `peer` | `string` | singular | — |
| `header` | `header` | `string` | singular | — |
| `count` | `count` | `uint32` | singular | — |

## Enums

### ClientIPAnalysisApplyScope

| Value | Number | Description |
|---|---|---|
| `CLIENT_IP_ANALYSIS_APPLY_SCOPE_UNSPECIFIED` | 0 | — |
| `CLIENT_IP_ANALYSIS_APPLY_SCOPE_SITE` | 1 | — |
| `CLIENT_IP_ANALYSIS_APPLY_SCOPE_GLOBAL` | 2 | — |

### ClientIPAnalysisRangesMode

Controls whether one analysed node's server-held ranges are retained, replaced by an operator-edited draft, or deliberately omitted on Apply.

| Value | Number | Description |
|---|---|---|
| `CLIENT_IP_ANALYSIS_RANGES_MODE_UNSPECIFIED` | 0 | — |
| `CLIENT_IP_ANALYSIS_RANGES_MODE_KEEP_SUGGESTED` | 1 | — |
| `CLIENT_IP_ANALYSIS_RANGES_MODE_REPLACE` | 2 | — |
| `CLIENT_IP_ANALYSIS_RANGES_MODE_DROP` | 3 | — |
