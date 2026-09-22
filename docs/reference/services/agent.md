<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# agent.proto — Agents, groups, and the agent stream

Schema: `tiyi.v1` · `agent.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### AgentService

| RPC | Kind | Required permission |
|---|---|---|
| [`Enroll`](#agentserviceenroll) | unary | **public** (no token) |
| [`ListNodes`](#agentservicelistnodes) | unary | (`agent:read`) |
| [`ListAgents`](#agentservicelistagents) | unary | (`agent:read`) |
| [`GetAgent`](#agentservicegetagent) | unary | (`agent:read`) |
| [`GetNodeCapabilities`](#agentservicegetnodecapabilities) | unary | (`agent:read`) |
| [`GetNodeServingState`](#agentservicegetnodeservingstate) | unary | (`agent:read`) |
| [`UpdateAgent`](#agentserviceupdateagent) | unary | (`agent:write`) |
| [`DeleteAgent`](#agentservicedeleteagent) | unary | (`agent:delete`) |
| [`RetryNodeConfig`](#agentserviceretrynodeconfig) | unary | (`agent:write`) |
| [`IssueEnrollmentToken`](#agentserviceissueenrollmenttoken) | unary | (`agent:install`) |
| [`CreateNodeInstallation`](#agentservicecreatenodeinstallation) | unary | (`agent:install`) |
| [`GetNodeInstallStatus`](#agentservicegetnodeinstallstatus) | unary | (`agent:install`) |
| [`StreamAgentEvents`](#agentservicestreamagentevents) | server stream | (`agent:read`) |
| [`ListNodeMetricSamples`](#agentservicelistnodemetricsamples) | unary | (`agent:read`) |
| [`ListConfigBundles`](#agentservicelistconfigbundles) | unary | (`agent:read`) |
| [`GetConfigBundle`](#agentservicegetconfigbundle) | unary | (`agent:read`) |

### AgentGroupService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListAgentGroups`](#agentgroupservicelistagentgroups) | unary | (`agent_group:read`) |
| [`GetAgentGroup`](#agentgroupservicegetagentgroup) | unary | (`agent_group:read`) |
| [`CreateAgentGroup`](#agentgroupservicecreateagentgroup) | unary | (`agent_group:write`) |
| [`UpdateAgentGroup`](#agentgroupserviceupdateagentgroup) | unary | (`agent_group:write`) |
| [`DeleteAgentGroup`](#agentgroupservicedeleteagentgroup) | unary | (`agent_group:delete`) |
| [`ResolveAgentGroup`](#agentgroupserviceresolveagentgroup) | unary | (`agent_group:read`) |

### AgentStreamService

| RPC | Kind | Required permission |
|---|---|---|
| [`Connect`](#agentstreamserviceconnect) | bidi stream | **public** (no token) |

### EvidenceUploadService

EvidenceUploadService is deliberately separate from AgentStreamService so large request bodies cannot head-of-line block config, metrics, facts, or binary-rollout traffic.

| RPC | Kind | Required permission |
|---|---|---|
| [`Upload`](#evidenceuploadserviceupload) | bidi stream | **public** (no token) |

## RPCs

### AgentService.Enroll

- **Procedure** `POST /tiyi.v1.AgentService/Enroll`
- **Kind** unary
- **Auth** **public** (no token)

**Request** — `tiyi.v1.EnrollRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enrollment_token` | `enrollmentToken` | `string` | singular | — |
| `fingerprint` | `fingerprint` | `string` | singular | — |
| `hostname` | `hostname` | `string` | singular | — |
| `os` | `os` | `string` | singular | — |
| `arch` | `arch` | `string` | singular | — |
| `version` | `version` | `string` | singular | — |

**Response** — `tiyi.v1.EnrollResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent` | `agent` | [`Agent`](#agent) | singular | — |
| `workload_cert_pem` | `workloadCertPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `workload_key_pem` | `workloadKeyPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `ca_cert_pem` | `caCertPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `stream_token` | `streamToken` | `string` | singular | — |
| `bundle_signing_public_key` | `bundleSigningPublicKey` | `bytes` | singular | _base64-encoded JSON string._ |

### AgentService.ListNodes

- **Procedure** `POST /tiyi.v1.AgentService/ListNodes`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.ListNodesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | `string` | singular | — |
| `status` | `status` | [`AgentStatus`](#agentstatus) | singular | — |
| `local_only` | `localOnly` | `bool` | singular | Return only the synthesized built-in local node. Used by the local detail poll so it never enumerates every enrolled Agent. |

**Response** — `tiyi.v1.ListNodesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Node`](#node) | repeated | — |
| `remote_total` | `remoteTotal` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AgentService.ListAgents

- **Procedure** `POST /tiyi.v1.AgentService/ListAgents`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.ListAgentsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |
| `status` | `status` | [`AgentStatus`](#agentstatus) | singular | — |

**Response** — `tiyi.v1.ListAgentsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Agent`](#agent) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### AgentService.GetAgent

- **Procedure** `POST /tiyi.v1.AgentService/GetAgent`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.GetAgentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAgentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent` | `agent` | [`Agent`](#agent) | singular | — |

### AgentService.GetNodeCapabilities

- **Procedure** `POST /tiyi.v1.AgentService/GetNodeCapabilities`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.GetNodeCapabilitiesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |

**Response** — `tiyi.v1.GetNodeCapabilitiesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `known` | `known` | `bool` | singular | Unknown is not an empty set of supported features and never qualifies a control publication. A local report describes this Controller binary. |
| `capabilities` | `capabilities` | [`AgentCapabilities`](#agentcapabilities) | singular | — |
| `capability_revision` | `capabilityRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `capabilities_sha256` | `capabilitiesSha256` | `string` | singular | — |
| `foundation_supported` | `foundationSupported` | `bool` | singular | — |

### AgentService.GetNodeServingState

- **Procedure** `POST /tiyi.v1.AgentService/GetNodeServingState`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.GetNodeServingStateRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |

**Response** — `tiyi.v1.GetNodeServingStateResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `remote` | `remote` | `bool` | singular | Local admission uses the built-in runtime, not remote signed grants. |
| `assigned` | `assigned` | `bool` | singular | — |
| `acknowledged` | `acknowledged` | `bool` | singular | Receipt of this exact grant, not current liveness or serving convergence. |
| `grant_revision` | `grantRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `grant_sha256` | `grantSha256` | `string` | singular | — |
| `config_revision_id` | `configRevisionId` | `string` | singular | — |
| `generation` | `generation` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bundle_id` | `bundleId` | `string` | singular | — |
| `target_revision` | `targetRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `artifact_sha256` | `artifactSha256` | `string` | singular | — |
| `site_ids` | `siteIds` | `string` | repeated | — |

### AgentService.UpdateAgent

- **Procedure** `POST /tiyi.v1.AgentService/UpdateAgent`
- **Kind** unary
- **Auth** (`agent:write`)

**Request** — `tiyi.v1.UpdateAgentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent` | `agent` | [`Agent`](#agent) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdateAgentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent` | `agent` | [`Agent`](#agent) | singular | — |

### AgentService.DeleteAgent

- **Procedure** `POST /tiyi.v1.AgentService/DeleteAgent`
- **Kind** unary
- **Auth** (`agent:delete`)

**Request** — `tiyi.v1.DeleteAgentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteAgentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### AgentService.RetryNodeConfig

RetryNodeConfig is the only operator-triggered node action. The built-in node reapplies its current desired config; a remote Agent gets the latest failed/stale-delivered signed bundle again.

- **Procedure** `POST /tiyi.v1.AgentService/RetryNodeConfig`
- **Kind** unary
- **Auth** (`agent:write`)

**Request** — `tiyi.v1.RetryNodeConfigRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |

**Response** — `tiyi.v1.RetryNodeConfigResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### AgentService.IssueEnrollmentToken

- **Procedure** `POST /tiyi.v1.AgentService/IssueEnrollmentToken`
- **Kind** unary
- **Auth** (`agent:install`)

**Request** — `tiyi.v1.IssueEnrollmentTokenRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `tags` | `tags` | `string` | repeated | — |
| `ttl_seconds` | `ttlSeconds` | `int32` | singular | — |
| `max_nodes` | `maxNodes` | `int32` | singular | Maximum distinct nodes; zero defaults to one. Range: 1..1000. |

**Response** — `tiyi.v1.IssueEnrollmentTokenResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `token` | `token` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `token_id` | `tokenId` | `string` | singular | — |
| `max_nodes` | `maxNodes` | `int32` | singular | — |

### AgentService.CreateNodeInstallation

- **Procedure** `POST /tiyi.v1.AgentService/CreateNodeInstallation`
- **Kind** unary
- **Auth** (`agent:install`)

**Request** — `tiyi.v1.CreateNodeInstallationRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `controller_url` | `controllerUrl` | `string` | singular | — |
| `tags` | `tags` | `string` | repeated | — |
| `ttl_seconds` | `ttlSeconds` | `int32` | singular | — |
| `max_nodes` | `maxNodes` | `int32` | singular | Maximum distinct nodes; zero defaults to one. Range: 1..1000. |

**Response** — `tiyi.v1.CreateNodeInstallationResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `command` | `command` | `string` | singular | Copy-ready curl \| sh commands; their URLs contain the enrollment secret. |
| `foreground_command` | `foregroundCommand` | `string` | singular | — |
| `script` | `script` | `string` | singular | Complete scripts for review, download and configuration management. |
| `foreground_script` | `foregroundScript` | `string` | singular | — |
| `token_id` | `tokenId` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `controller_url` | `controllerUrl` | `string` | singular | — |
| `platform` | `platform` | `string` | singular | — |
| `tags` | `tags` | `string` | repeated | — |
| `max_nodes` | `maxNodes` | `int32` | singular | — |
| `proxy_http_addr` | `proxyHttpAddr` | `string` | singular | — |
| `proxy_https_addr` | `proxyHttpsAddr` | `string` | singular | — |

### AgentService.GetNodeInstallStatus

- **Procedure** `POST /tiyi.v1.AgentService/GetNodeInstallStatus`
- **Kind** unary
- **Auth** (`agent:install`)

**Request** — `tiyi.v1.GetNodeInstallStatusRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `token_id` | `tokenId` | `string` | singular | — |

**Response** — `tiyi.v1.GetNodeInstallStatusResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `token_id` | `tokenId` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `max_nodes` | `maxNodes` | `int32` | singular | — |
| `registered_nodes` | `registeredNodes` | `int32` | singular | Successful distinct registrations through this command, including nodes subsequently deleted. Re-enrollment of the same fingerprint counts once. |

### AgentService.StreamAgentEvents

- **Procedure** `POST /tiyi.v1.AgentService/StreamAgentEvents`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.StreamAgentEventsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent_id` | `agentId` | `string` | singular | — |

**Response** — `tiyi.v1.StreamAgentEventsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `event` | `event` | [`AgentEvent`](#agentevent) | singular | — |
| `agent` | `agent` | [`Agent`](#agent) | singular | Full agent row, refreshed whenever this event changes its state (status/metrics/config revision/tags). Absent when the server only streams metadata events. |

### AgentService.ListNodeMetricSamples

Enrolled Agents and the built-in local node share one node-scoped metric history.

- **Procedure** `POST /tiyi.v1.AgentService/ListNodeMetricSamples`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.ListNodeMetricSamplesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `start_time` | `startTime` | `google.protobuf.Timestamp` | singular | Optional. Defaults to thirty days ago and is clamped to the server-retained thirty-day history window. _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `end_time` | `endTime` | `google.protobuf.Timestamp` | singular | Optional. Defaults to now. _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `max_points` | `maxPoints` | `int32` | singular | Desired response bound. Defaults to 400 and is capped at 2000. |
| `bucket_seconds` | `bucketSeconds` | `int32` | singular | Optional aggregation width. The server may choose a wider bucket to keep the response within max_points. Values below one minute are rounded up. |

**Response** — `tiyi.v1.ListNodeMetricSamplesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `samples` | `samples` | [`NodeMetricSample`](#nodemetricsample) | repeated | — |

### AgentService.ListConfigBundles

- **Procedure** `POST /tiyi.v1.AgentService/ListConfigBundles`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.ListConfigBundlesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `node_id` | `nodeId` | `string` | singular | Built-in local node id or enrolled remote Agent id. |

**Response** — `tiyi.v1.ListConfigBundlesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`ConfigBundleSummary`](#configbundlesummary) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### AgentService.GetConfigBundle

GetConfigBundle accepts either a remote config_bundle id or a built-in local config_revision id returned by ListConfigBundles.

- **Procedure** `POST /tiyi.v1.AgentService/GetConfigBundle`
- **Kind** unary
- **Auth** (`agent:read`)

**Request** — `tiyi.v1.GetConfigBundleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetConfigBundleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `bundle` | `bundle` | [`ConfigBundle`](#configbundle) | singular | — |

### AgentGroupService.ListAgentGroups

- **Procedure** `POST /tiyi.v1.AgentGroupService/ListAgentGroups`
- **Kind** unary
- **Auth** (`agent_group:read`)

**Request** — `tiyi.v1.ListAgentGroupsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |

**Response** — `tiyi.v1.ListAgentGroupsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AgentGroup`](#agentgroup) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### AgentGroupService.GetAgentGroup

- **Procedure** `POST /tiyi.v1.AgentGroupService/GetAgentGroup`
- **Kind** unary
- **Auth** (`agent_group:read`)

**Request** — `tiyi.v1.GetAgentGroupRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAgentGroupResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `group` | `group` | [`AgentGroup`](#agentgroup) | singular | — |

### AgentGroupService.CreateAgentGroup

- **Procedure** `POST /tiyi.v1.AgentGroupService/CreateAgentGroup`
- **Kind** unary
- **Auth** (`agent_group:write`)

**Request** — `tiyi.v1.CreateAgentGroupRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `group` | `group` | [`AgentGroup`](#agentgroup) | singular | — |

**Response** — `tiyi.v1.CreateAgentGroupResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `group` | `group` | [`AgentGroup`](#agentgroup) | singular | — |

### AgentGroupService.UpdateAgentGroup

- **Procedure** `POST /tiyi.v1.AgentGroupService/UpdateAgentGroup`
- **Kind** unary
- **Auth** (`agent_group:write`)

**Request** — `tiyi.v1.UpdateAgentGroupRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `group` | `group` | [`AgentGroup`](#agentgroup) | singular | Complete replacement: name and selector are required. |

**Response** — `tiyi.v1.UpdateAgentGroupResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `group` | `group` | [`AgentGroup`](#agentgroup) | singular | — |

### AgentGroupService.DeleteAgentGroup

- **Procedure** `POST /tiyi.v1.AgentGroupService/DeleteAgentGroup`
- **Kind** unary
- **Auth** (`agent_group:delete`)

**Request** — `tiyi.v1.DeleteAgentGroupRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteAgentGroupResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### AgentGroupService.ResolveAgentGroup

- **Procedure** `POST /tiyi.v1.AgentGroupService/ResolveAgentGroup`
- **Kind** unary
- **Auth** (`agent_group:read`)

**Request** — `tiyi.v1.ResolveAgentGroupRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | Resolve a saved group by id … |
| `group` | `group` | [`AgentGroup`](#agentgroup) | singular | … or an ad-hoc spec when the editor is previewing unsaved edits. Exactly one of `id` or `group` must be set. |

**Response** — `tiyi.v1.ResolveAgentGroupResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agents` | `agents` | [`Agent`](#agent) | repeated | Full agent rows for callers that want to render a preview list. |
| `agent_ids` | `agentIds` | `string` | repeated | Compact id list for callers that only need the count or id set (the Vben group editor uses this for its match-count badge). |

### AgentStreamService.Connect

- **Procedure** `POST /tiyi.v1.AgentStreamService/Connect`
- **Kind** bidi stream — bidirectional stream (gRPC or Connect streaming transport required)
- **Auth** **public** (no token)

**Request** — `tiyi.v1.AgentStreamServiceConnectRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `hello` | `hello` | [`AgentHello`](#agenthello) | singular | Part of oneof `message`. |
| `state_report` | `stateReport` | [`AgentStateReport`](#agentstatereport) | singular | Part of oneof `message`. |
| `apply_result` | `applyResult` | [`AgentApplyResult`](#agentapplyresult) | singular | Part of oneof `message`. |
| `metrics_push` | `metricsPush` | [`AgentMetricsPush`](#agentmetricspush) | singular | Part of oneof `message`. |
| `challenge_response` | `challengeResponse` | [`ChallengeResponse`](#challengeresponse) | singular | Part of oneof `message`. |
| `ping_ack` | `pingAck` | [`PingAck`](#pingack) | singular | Part of oneof `message`. |
| `command_result` | `commandResult` | [`AgentCommandResult`](#agentcommandresult) | singular | Part of oneof `message`. |
| `observation_batch` | `observationBatch` | [`ObservationBatch`](#observationbatch) | singular | Part of oneof `message`. |
| `gap_notice` | `gapNotice` | [`GapNotice`](#gapnotice) | singular | Part of oneof `message`. |
| `serving_grant_ack` | `servingGrantAck` | [`AgentServingGrantAck`](#agentservinggrantack) | singular | Part of oneof `message`. |

**Response** — `tiyi.v1.AgentStreamServiceConnectResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `welcome` | `welcome` | [`AgentWelcome`](#agentwelcome) | singular | Part of oneof `message`. |
| `config_update` | `configUpdate` | [`ConfigUpdate`](#configupdate) | singular | Part of oneof `message`. |
| `command` | `command` | [`AgentCommand`](#agentcommand) | singular | Part of oneof `message`. |
| `challenge_dispatch` | `challengeDispatch` | [`ChallengeDispatch`](#challengedispatch) | singular | Part of oneof `message`. |
| `ping` | `ping` | [`Ping`](#ping) | singular | Part of oneof `message`. |
| `go_away` | `goAway` | [`GoAway`](#goaway) | singular | Part of oneof `message`. |
| `batch_ack` | `batchAck` | [`BatchAck`](#batchack) | singular | Part of oneof `message`. |
| `gap_notice_ack` | `gapNoticeAck` | [`GapNoticeAck`](#gapnoticeack) | singular | Part of oneof `message`. |
| `serving_grant` | `servingGrant` | [`SignedServingGrant`](#signedservinggrant) | singular | Part of oneof `message`. |

### EvidenceUploadService.Upload

- **Procedure** `POST /tiyi.v1.EvidenceUploadService/Upload`
- **Kind** bidi stream — bidirectional stream (gRPC or Connect streaming transport required)
- **Auth** **public** (no token)

**Request** — `tiyi.v1.UploadRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `hello` | `hello` | [`EvidenceUploadHello`](#evidenceuploadhello) | singular | Part of oneof `message`. |
| `manifest` | `manifest` | [`EvidenceManifest`](#evidencemanifest) | singular | Part of oneof `message`. |
| `chunk` | `chunk` | [`EvidenceChunk`](#evidencechunk) | singular | Part of oneof `message`. |
| `commit` | `commit` | [`EvidenceCommit`](#evidencecommit) | singular | Part of oneof `message`. |

**Response** — `tiyi.v1.UploadResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `durable_ack` | `durableAck` | [`EvidenceDurableAck`](#evidencedurableack) | singular | — |

## Messages

### Agent

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `fingerprint` | `fingerprint` | `string` | singular | — |
| `hostname` | `hostname` | `string` | singular | — |
| `ip` | `ip` | `string` | singular | — |
| `os` | `os` | `string` | singular | — |
| `arch` | `arch` | `string` | singular | — |
| `version` | `version` | `string` | singular | — |
| `tags` | `tags` | `string` | repeated | — |
| `status` | `status` | [`AgentStatus`](#agentstatus) | singular | — |
| `config_hash` | `configHash` | `string` | singular | — |
| `config_revision` | `configRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `last_heartbeat` | `lastHeartbeat` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `registered_at` | `registeredAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `deleted_at` | `deletedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `metrics` | `metrics` | [`AgentMetrics`](#agentmetrics) | singular | Latest runtime metrics snapshot reported by the agent. |
| `metrics_updated_at` | `metricsUpdatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AgentApplyResult

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `correlation_id` | `correlationId` | `string` | singular | — |
| `success` | `success` | `bool` | singular | — |
| `error` | `error` | `string` | singular | — |
| `target_revision` | `targetRevision` | `int64` | singular | Exact attempted signed envelope identity, required even on failure. _JSON string (64-bit ints are quoted)._ |
| `artifact_sha256` | `artifactSha256` | `string` | singular | — |

### AgentCapabilities

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `version` | `version` | `uint32` | singular | — |
| `artifact_format` | `artifactFormat` | `string` | singular | — |
| `resolver_version` | `resolverVersion` | `uint32` | singular | — |
| `control_format` | `controlFormat` | `string` | singular | — |
| `body_modes` | `bodyModes` | `string` | repeated | — |
| `schema_irs` | `schemaIrs` | `string` | repeated | — |
| `metric_payload_version` | `metricPayloadVersion` | `uint32` | singular | — |

### AgentCommand

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `kind` | `kind` | [`AgentCommandKind`](#agentcommandkind) | singular | — |
| `payload` | `payload` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `status` | `status` | [`AgentCommandStatus`](#agentcommandstatus) | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `completed_at` | `completedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AgentCommandResult

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `command_id` | `commandId` | `string` | singular | — |
| `success` | `success` | `bool` | singular | — |
| `error` | `error` | `string` | singular | — |
| `output` | `output` | `google.protobuf.Struct` | singular | _free-form JSON object._ |

### AgentEvent

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent_id` | `agentId` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `payload` | `payload` | `google.protobuf.Struct` | singular | _free-form JSON object._ |

### AgentGroup

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `selector` | `selector` | [`AgentGroupSelector`](#agentgroupselector) | singular | — |
| `member_count` | `memberCount` | `int32` | singular | Complete current member count, never a truncated page count. |

### AgentGroupSelector

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `match_tags` | `matchTags` | `string` | repeated | — |
| `match_agent_ids` | `matchAgentIds` | `string` | repeated | — |

### AgentHello

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent_id` | `agentId` | `string` | singular | — |
| `version` | `version` | `string` | singular | — |
| `config_hash` | `configHash` | `string` | singular | — |
| `stream_token` | `streamToken` | `string` | singular | — |
| `observation_protocol_version` | `observationProtocolVersion` | `uint32` | singular | observation_protocol_version is an exact, breaking protocol version. The server does not negotiate or downgrade observation batches. |
| `capabilities` | `capabilities` | [`AgentCapabilities`](#agentcapabilities) | singular | Required exact executable contracts. Missing/unknown capabilities do not inherit a previous connection's report or a product-version assumption. |

### AgentMetrics

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cpu_percent` | `cpuPercent` | `double` | singular | — |
| `memory_percent` | `memoryPercent` | `double` | singular | — |
| `active_connections` | `activeConnections` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `requests_per_second` | `requestsPerSecond` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked_per_second` | `blockedPerSecond` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bandwidth_in_bps` | `bandwidthInBps` | `int64` | singular | Network bandwidth in bytes per second (sum of all interfaces). _JSON string (64-bit ints are quoted)._ |
| `bandwidth_out_bps` | `bandwidthOutBps` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `memory_total_bytes` | `memoryTotalBytes` | `int64` | singular | Total memory in bytes (for absolute display alongside percent). _JSON string (64-bit ints are quoted)._ |
| `memory_used_bytes` | `memoryUsedBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `goroutines` | `goroutines` | `int32` | singular | Goroutine count (Go-specific but useful for diagnostics). |
| `waf_agent_cpu_percent` | `wafAgentCpuPercent` | `double` | singular | Process CPU and Coraza phase-demand signals used by the node-local WAF overload controller. These are distinct from host-wide cpu_percent. |
| `waf_coraza_demand_percent` | `wafCorazaDemandPercent` | `double` | singular | — |
| `waf_phase_p99_millis` | `wafPhaseP99Millis` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `waf_overload_state` | `wafOverloadState` | `string` | singular | — |
| `waf_overload_action` | `wafOverloadAction` | `string` | singular | — |
| `waf_probe_percent` | `wafProbePercent` | `int32` | singular | — |
| `observation_health` | `observationHealth` | [`AgentObservationHealth`](#agentobservationhealth) | singular | Remote observation transport health rides the existing 15-second health report. It is diagnostic state, never an overload-decision input. |

### AgentMetricsPush

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent_id` | `agentId` | `string` | singular | — |
| `metrics` | `metrics` | [`AgentMetrics`](#agentmetrics) | singular | — |
| `observed_at` | `observedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `upstream_health` | `upstreamHealth` | [`UpstreamHealthState`](upstream.md#upstreamhealthstate) | repeated | — |
| `upstream_health_config_generation` | `upstreamHealthConfigGeneration` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `upstream_health_artifact_sha256` | `upstreamHealthArtifactSha256` | `string` | singular | — |

### AgentObservationHealth

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `state` | `state` | `string` | singular | healthy \| backlog \| coverage_gap \| quarantined |
| `pending_batches` | `pendingBatches` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `pending_bytes` | `pendingBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `evicted_batches` | `evictedBatches` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `gap_notices` | `gapNotices` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `quarantined_streams` | `quarantinedStreams` | `string` | repeated | — |
| `last_ack_age_millis` | `lastAckAgeMillis` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `coverage_incomplete` | `coverageIncomplete` | `bool` | singular | — |

### AgentServingGrantAck

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `grant_sha256` | `grantSha256` | `string` | singular | — |

### AgentStateReport

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent_id` | `agentId` | `string` | singular | — |
| `config_hash` | `configHash` | `string` | singular | — |
| `status` | `status` | [`AgentStatus`](#agentstatus) | singular | — |
| `metrics` | `metrics` | [`AgentMetrics`](#agentmetrics) | singular | — |

### AgentWelcome

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `server_id` | `serverId` | `string` | singular | — |
| `bundle_signing_public_key` | `bundleSigningPublicKey` | `bytes` | singular | _base64-encoded JSON string._ |
| `metric_payload_version` | `metricPayloadVersion` | `uint32` | singular | Exact coordinated metric payload version, matching capabilities. Current identity v9 rejects older producers/spools; no downgrade exists. It does not advertise qualified body/schema evidence completeness. |
| `capabilities` | `capabilities` | [`AgentCapabilities`](#agentcapabilities) | singular | — |

### BatchAck

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `boot_id` | `bootId` | `bytes` | singular | _base64-encoded JSON string._ |
| `stream_kind` | `streamKind` | [`ObservationStreamKind`](#observationstreamkind) | singular | — |
| `batch_seq` | `batchSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `ack_through_batch_seq` | `ackThroughBatchSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `status` | `status` | [`ObservationBatchAckStatus`](#observationbatchackstatus) | singular | — |
| `durability` | `durability` | [`ObservationAckDurability`](#observationackdurability) | singular | — |
| `error_code` | `errorCode` | [`ObservationAckErrorCode`](#observationackerrorcode) | singular | — |

### ChallengeDispatch

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `token` | `token` | `string` | singular | — |
| `key_authorization` | `keyAuthorization` | `string` | singular | — |

### ChallengeResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `token` | `token` | `string` | singular | — |
| `served` | `served` | `bool` | singular | — |
| `error` | `error` | `string` | singular | — |

### ConfigBundle

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bundle_sha256` | `bundleSha256` | `string` | singular | — |
| `bundle` | `bundle` | `bytes` | singular | _base64-encoded JSON string._ |
| `signature` | `signature` | `bytes` | singular | _base64-encoded JSON string._ |
| `emitted_at` | `emittedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `delivered_at` | `deliveredAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `applied_at` | `appliedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `apply_result` | `applyResult` | `string` | singular | — |
| `apply_error` | `applyError` | `string` | singular | — |

### ConfigBundleSummary

Metadata-only list item; GetConfigBundle returns the artifact on demand.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bundle_sha256` | `bundleSha256` | `string` | singular | — |
| `emitted_at` | `emittedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `delivered_at` | `deliveredAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `applied_at` | `appliedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `apply_result` | `applyResult` | `string` | singular | — |
| `apply_error` | `applyError` | `string` | singular | — |

### ConfigUpdate

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `correlation_id` | `correlationId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bundle` | `bundle` | `bytes` | singular | _base64-encoded JSON string._ |
| `signature` | `signature` | `bytes` | singular | _base64-encoded JSON string._ |
| `bundle_sha256` | `bundleSha256` | `string` | singular | — |
| `bundle_signing_public_key` | `bundleSigningPublicKey` | `bytes` | singular | _base64-encoded JSON string._ |

### EvidenceChunk

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `offset` | `offset` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `data` | `data` | `bytes` | singular | _base64-encoded JSON string._ |
| `crc32c` | `crc32c` | `fixed32` | singular | — |

### EvidenceCommit

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `total_bytes` | `totalBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `body_crc32c` | `bodyCrc32c` | `fixed32` | singular | — |

### EvidenceDurableAck

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `evidence_id` | `evidenceId` | `string` | singular | — |
| `status` | `status` | [`EvidenceAckStatus`](#evidenceackstatus) | singular | — |
| `durable_through_offset` | `durableThroughOffset` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `error` | `error` | `string` | singular | — |

### EvidenceManifest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `metadata` | `metadata` | [`RequestEvidenceMetadata`](log.md#requestevidencemetadata) | singular | — |
| `headers` | `headers` | [`RequestEvidenceHeader`](log.md#requestevidenceheader) | repeated | — |
| `body_size` | `bodySize` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `body_crc32c` | `bodyCrc32c` | `fixed32` | singular | — |
| `retention` | `retention` | [`EvidenceRetentionContext`](#evidenceretentioncontext) | singular | — |

### EvidenceReservoirReference

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `feature_key_hex` | `featureKeyHex` | `string` | singular | — |
| `capacity` | `capacity` | `uint32` | singular | — |
| `score` | `score` | `bytes` | singular | _base64-encoded JSON string._ |

### EvidenceRetentionContext

EvidenceRetentionContext lets the Controller merge provisional Agent exemplars with the same deterministic min-K order as retained Access detail. It is authenticated by the Agent upload channel and validated before persistence.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `security_anchor` | `securityAnchor` | `bool` | singular | — |
| `access_full_anchor` | `accessFullAnchor` | `bool` | singular | — |
| `access_record_id` | `accessRecordId` | `string` | singular | — |
| `access_sample_window` | `accessSampleWindow` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `candidate_settle_at` | `candidateSettleAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `access_reservoir_refs` | `accessReservoirRefs` | [`EvidenceReservoirReference`](#evidencereservoirreference) | repeated | — |

### EvidenceUploadHello

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent_id` | `agentId` | `string` | singular | — |
| `stream_token` | `streamToken` | `string` | singular | — |

### GapNotice

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `boot_id` | `bootId` | `bytes` | singular | _base64-encoded JSON string._ |
| `stream_kind` | `streamKind` | [`ObservationStreamKind`](#observationstreamkind) | singular | — |
| `first_batch_seq` | `firstBatchSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `last_batch_seq` | `lastBatchSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `first_item_seq` | `firstItemSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `last_item_seq` | `lastItemSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `reason` | `reason` | [`ObservationGapReason`](#observationgapreason) | singular | — |

### GapNoticeAck

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `boot_id` | `bootId` | `bytes` | singular | _base64-encoded JSON string._ |
| `stream_kind` | `streamKind` | [`ObservationStreamKind`](#observationstreamkind) | singular | — |
| `ack_through_batch_seq` | `ackThroughBatchSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `first_batch_seq` | `firstBatchSeq` | `uint64` | singular | first_batch_seq identifies the exact tombstone and is required. _JSON string (64-bit ints are quoted)._ |
| `status` | `status` | [`ObservationGapAckStatus`](#observationgapackstatus) | singular | — |
| `error_code` | `errorCode` | [`ObservationAckErrorCode`](#observationackerrorcode) | singular | — |

### GoAway

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `reason` | `reason` | `string` | singular | — |
| `message` | `message` | `string` | singular | — |

### Node

Node is the role-free read model used by the Nodes page. The built-in local runtime and enrolled remote Agents share one shape but remain distinct in storage and lifecycle.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `placement` | `placement` | `string` | singular | LOCAL \| REMOTE |
| `runtime` | `runtime` | `string` | singular | BUILT_IN \| AGENT |
| `connection_status` | `connectionStatus` | `string` | singular | LOCAL \| CONNECTED \| DEGRADED \| OFFLINE |
| `proxy_status` | `proxyStatus` | `string` | singular | HEALTHY \| DEGRADED \| STOPPED \| UNKNOWN |
| `config_hash` | `configHash` | `string` | singular | — |
| `config_revision` | `configRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `last_seen_at` | `lastSeenAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `version` | `version` | `string` | singular | — |
| `addresses` | `addresses` | `string` | repeated | — |
| `tags` | `tags` | `string` | repeated | — |
| `metrics` | `metrics` | [`AgentMetrics`](#agentmetrics) | singular | — |
| `os` | `os` | `string` | singular | — |
| `arch` | `arch` | `string` | singular | — |
| `remote_agent` | `remoteAgent` | [`Agent`](#agent) | singular | set only for REMOTE rows |
| `apply_result` | `applyResult` | `string` | singular | Latest desired configuration outcome, independent of connection status: unknown \| pending \| success \| failure \| rolled_back. Applies to both local and remote nodes. The active revision remains the last successful apply. |
| `apply_error` | `applyError` | `string` | singular | — |
| `applied_at` | `appliedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `metrics_updated_at` | `metricsUpdatedAt` | `google.protobuf.Timestamp` | singular | When `metrics` was last refreshed. Distinct from last_seen_at, which falls back to applied_at while no sample has been collected yet. _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `attempt_config_revision` | `attemptConfigRevision` | `int64` | singular | The most recent attempted bundle. These fields can advance while config_revision/config_hash remain on the last successfully applied bundle. _JSON string (64-bit ints are quoted)._ |
| `attempt_config_hash` | `attemptConfigHash` | `string` | singular | — |
| `attempted_at` | `attemptedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### NodeMetricSample

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `observed_at` | `observedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `metrics` | `metrics` | [`AgentMetrics`](#agentmetrics) | singular | — |

### ObservationBatch

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `header` | `header` | [`ObservationBatchHeader`](#observationbatchheader) | singular | — |
| `payload` | `payload` | `bytes` | singular | _base64-encoded JSON string._ |

### ObservationBatchHeader

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `boot_id` | `bootId` | `bytes` | singular | _base64-encoded JSON string._ |
| `stream_kind` | `streamKind` | [`ObservationStreamKind`](#observationstreamkind) | singular | — |
| `batch_seq` | `batchSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `first_item_seq` | `firstItemSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `last_item_seq` | `lastItemSeq` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `item_count` | `itemCount` | `uint32` | singular | — |
| `retention_tier` | `retentionTier` | [`ObservationRetentionTier`](#observationretentiontier) | singular | — |
| `partition_utc_day` | `partitionUtcDay` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `payload_schema_version` | `payloadSchemaVersion` | `uint32` | singular | — |
| `crc32c` | `crc32c` | `fixed32` | singular | — |

### Ping

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `nonce` | `nonce` | `string` | singular | — |

### PingAck

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `nonce` | `nonce` | `string` | singular | — |
| `metric_boot_id` | `metricBootId` | `string` | singular | — |
| `received_at` | `receivedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `sent_at` | `sentAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### SignedServingGrant

Domain-separated, canonical tiyi.serving_grant.v1 JSON. Binds an authenticated node and site set to one exact successfully applied config deployment.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `grant` | `grant` | `bytes` | singular | _base64-encoded JSON string._ |
| `signature` | `signature` | `bytes` | singular | _base64-encoded JSON string._ |

## Enums

### AgentCommandKind

| Value | Number | Description |
|---|---|---|
| `AGENT_COMMAND_KIND_UNSPECIFIED` | 0 | — |
| `AGENT_COMMAND_KIND_APPLY_BINARY` | 4 | APPLY_BINARY tells the agent to download a binary release from the control-plane bootstrap endpoint, verify its SHA-256, swap it into place atomically, and exit so its supervisor (systemd, Docker, Kubernetes) restarts the process into the new binary. Payload carries `release_id`, `version`, `sha256`, and `download_path` (server-relative, e.g. "/bootstrap/binary"). |

### AgentCommandStatus

| Value | Number | Description |
|---|---|---|
| `AGENT_COMMAND_STATUS_UNSPECIFIED` | 0 | — |
| `AGENT_COMMAND_STATUS_PENDING` | 1 | — |
| `AGENT_COMMAND_STATUS_SENT` | 2 | — |
| `AGENT_COMMAND_STATUS_SUCCEEDED` | 3 | — |
| `AGENT_COMMAND_STATUS_FAILED` | 4 | — |

### AgentStatus

| Value | Number | Description |
|---|---|---|
| `AGENT_STATUS_UNSPECIFIED` | 0 | — |
| `AGENT_STATUS_ONLINE` | 1 | — |
| `AGENT_STATUS_OFFLINE` | 2 | — |
| `AGENT_STATUS_ERROR` | 3 | — |

### EvidenceAckStatus

| Value | Number | Description |
|---|---|---|
| `EVIDENCE_ACK_STATUS_UNSPECIFIED` | 0 | — |
| `EVIDENCE_ACK_STATUS_CONTINUE` | 1 | — |
| `EVIDENCE_ACK_STATUS_DURABLE` | 2 | — |
| `EVIDENCE_ACK_STATUS_RETRYABLE` | 3 | — |
| `EVIDENCE_ACK_STATUS_FATAL` | 4 | — |

### ObservationAckDurability

| Value | Number | Description |
|---|---|---|
| `OBSERVATION_ACK_DURABILITY_UNSPECIFIED` | 0 | — |
| `OBSERVATION_ACK_DURABILITY_MEMORY` | 1 | — |
| `OBSERVATION_ACK_DURABILITY_FSYNC` | 2 | — |

### ObservationAckErrorCode

| Value | Number | Description |
|---|---|---|
| `OBSERVATION_ACK_ERROR_CODE_UNSPECIFIED` | 0 | — |
| `OBSERVATION_ACK_ERROR_CODE_NONE` | 1 | — |
| `OBSERVATION_ACK_ERROR_CODE_QUEUE_FULL` | 2 | — |
| `OBSERVATION_ACK_ERROR_CODE_DB_BUSY` | 3 | — |
| `OBSERVATION_ACK_ERROR_CODE_TEMPORARY_IO` | 4 | — |
| `OBSERVATION_ACK_ERROR_CODE_LATE_BEYOND_RETENTION` | 5 | — |
| `OBSERVATION_ACK_ERROR_CODE_CRC` | 6 | — |
| `OBSERVATION_ACK_ERROR_CODE_SCHEMA` | 7 | — |
| `OBSERVATION_ACK_ERROR_CODE_IDENTITY` | 8 | — |
| `OBSERVATION_ACK_ERROR_CODE_RANGE` | 9 | — |
| `OBSERVATION_ACK_ERROR_CODE_PARTITION_MISMATCH` | 10 | — |

### ObservationBatchAckStatus

| Value | Number | Description |
|---|---|---|
| `OBSERVATION_BATCH_ACK_STATUS_UNSPECIFIED` | 0 | — |
| `OBSERVATION_BATCH_ACK_STATUS_ACCEPTED` | 1 | — |
| `OBSERVATION_BATCH_ACK_STATUS_ACCEPTED_MEMORY` | 2 | — |
| `OBSERVATION_BATCH_ACK_STATUS_RETRYABLE` | 3 | — |
| `OBSERVATION_BATCH_ACK_STATUS_TERMINAL_GAP` | 4 | — |
| `OBSERVATION_BATCH_ACK_STATUS_FATAL_PROTOCOL` | 5 | — |

### ObservationGapAckStatus

| Value | Number | Description |
|---|---|---|
| `OBSERVATION_GAP_ACK_STATUS_UNSPECIFIED` | 0 | — |
| `OBSERVATION_GAP_ACK_STATUS_ACCEPTED` | 1 | — |
| `OBSERVATION_GAP_ACK_STATUS_FATAL_PROTOCOL` | 2 | — |

### ObservationGapReason

| Value | Number | Description |
|---|---|---|
| `OBSERVATION_GAP_REASON_UNSPECIFIED` | 0 | — |
| `OBSERVATION_GAP_REASON_SPOOL_EVICTED` | 1 | — |
| `OBSERVATION_GAP_REASON_SPOOL_CORRUPT` | 2 | — |
| `OBSERVATION_GAP_REASON_DISK_FULL` | 3 | — |
| `OBSERVATION_GAP_REASON_OPERATOR_DISCARD` | 4 | — |

### ObservationRetentionTier

| Value | Number | Description |
|---|---|---|
| `OBSERVATION_RETENTION_TIER_UNSPECIFIED` | 0 | — |
| `OBSERVATION_RETENTION_TIER_FULL` | 1 | — |
| `OBSERVATION_RETENTION_TIER_EVIDENCE` | 2 | — |

### ObservationStreamKind

| Value | Number | Description |
|---|---|---|
| `OBSERVATION_STREAM_KIND_UNSPECIFIED` | 0 | — |
| `OBSERVATION_STREAM_KIND_METRIC` | 1 | — |
| `OBSERVATION_STREAM_KIND_SECURITY_FACT` | 2 | — |
| `OBSERVATION_STREAM_KIND_ACCESS_DETAIL_FULL` | 3 | — |
| `OBSERVATION_STREAM_KIND_ACCESS_DETAIL_EVIDENCE` | 4 | — |
| `OBSERVATION_STREAM_KIND_SECURITY_DETAIL_FULL` | 5 | — |
| `OBSERVATION_STREAM_KIND_SECURITY_DETAIL_EVIDENCE` | 6 | — |
| `OBSERVATION_STREAM_KIND_ACCESS_SIEM` | 7 | — |
| `OBSERVATION_STREAM_KIND_SECURITY_SIEM` | 8 | — |
| `OBSERVATION_STREAM_KIND_ERROR_DETAIL` | 9 | — |
| `OBSERVATION_STREAM_KIND_ERROR_SIEM` | 10 | — |
