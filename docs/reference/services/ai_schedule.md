<!-- v3.8.1 public API reference, derived from the protobuf contract. -->

# ai_schedule.proto — ai_schedule

Schema: `tiyi.v1` · `ai_schedule.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Messages

### AISchedule

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `spec` | `spec` | [`AIScheduleSpec`](#aischedulespec) | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `state` | `state` | `string` | singular | — |
| `next_run_at` | `nextRunAt` | `string` | singular | — |
| `scheduled_count` | `scheduledCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `failure_count` | `failureCount` | `uint32` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |
| `updated_at` | `updatedAt` | `string` | singular | — |
| `unread` | `unread` | `bool` | singular | — |
| `content_available` | `contentAvailable` | `bool` | singular | — |

### AIScheduleAction

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | — |
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `scope` | `scope` | `string` | singular | — |
| `minimum` | `minimum` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `ttl_seconds` | `ttlSeconds` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AIScheduleChannel

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `destination` | `destination` | `string` | singular | — |

### AIScheduleEffect

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `target` | `target` | `string` | singular | — |
| `state` | `state` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `attempts` | `attempts` | `uint32` | singular | — |
| `saved_at` | `savedAt` | `string` | singular | — |
| `expires_at` | `expiresAt` | `string` | singular | — |

### AIScheduleNotify

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `mode` | `mode` | `string` | singular | — |
| `metric` | `metric` | `string` | singular | — |
| `minimum` | `minimum` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `increase_percent` | `increasePercent` | `double` | singular | — |
| `increase_minimum` | `increaseMinimum` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `channel_ids` | `channelIds` | `string` | repeated | — |
| `console_origin` | `consoleOrigin` | `string` | singular | Console origin shown in the task card; never contains credentials. |

### AIScheduleOccurrence

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `at` | `at` | `string` | singular | — |
| `start` | `start` | `string` | singular | — |
| `end` | `end` | `string` | singular | — |
| `seconds` | `seconds` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AIScheduleRun

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `schedule_id` | `scheduleId` | `string` | singular | — |
| `spec` | `spec` | [`AIScheduleSpec`](#aischedulespec) | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `trigger` | `trigger` | `string` | singular | — |
| `scheduled_at` | `scheduledAt` | `string` | singular | — |
| `window_start` | `windowStart` | `string` | singular | — |
| `window_end` | `windowEnd` | `string` | singular | — |
| `state` | `state` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `missed_count` | `missedCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `prior_run_id` | `priorRunId` | `string` | singular | — |
| `evidence_json` | `evidenceJson` | `string` | singular | — |
| `body` | `body` | `string` | singular | — |
| `comparison_json` | `comparisonJson` | `string` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `attempts` | `attempts` | `uint32` | singular | — |
| `started_at` | `startedAt` | `string` | singular | — |
| `completed_at` | `completedAt` | `string` | singular | — |
| `unread` | `unread` | `bool` | singular | — |
| `effects` | `effects` | [`AIScheduleEffect`](#aischeduleeffect) | repeated | — |

### AIScheduleScope

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `all_sites` | `allSites` | `bool` | singular | — |
| `ips` | `ips` | `string` | repeated | — |
| `path` | `path` | `string` | singular | — |
| `outcome` | `outcome` | `string` | singular | — |

### AIScheduleSpec

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `capability` | `capability` | `string` | singular | security_report, ip_investigation, operations, or alert_digest. Alert digests require alert:read and an explicit site or all-alert scope; no block action. |
| `scope` | `scope` | [`AIScheduleScope`](#aischedulescope) | singular | — |
| `timing` | `timing` | [`AIScheduleTiming`](#aischeduletiming) | singular | — |
| `window` | `window` | [`AIScheduleWindow`](#aischedulewindow) | singular | — |
| `instruction` | `instruction` | `string` | singular | — |
| `language` | `language` | `string` | singular | — |
| `end_at` | `endAt` | `string` | singular | — |
| `max_runs` | `maxRuns` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `notify` | `notify` | [`AIScheduleNotify`](#aischedulenotify) | singular | — |
| `action` | `action` | [`AIScheduleAction`](#aischeduleaction) | singular | — |

### AIScheduleTiming

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | — |
| `timezone` | `timezone` | `string` | singular | — |
| `time` | `time` | `string` | singular | — |
| `weekdays` | `weekdays` | `int32` | repeated | — |
| `start_at` | `startAt` | `string` | singular | — |
| `interval_seconds` | `intervalSeconds` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AIScheduleWindow

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | — |
| `hours` | `hours` | `int32` | singular | — |

### CancelAIScheduleRunRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

### CancelAIScheduleRunResponse

_No fields — send `{}`._

### ContinueAIScheduleRunRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

### CreateAIScheduleRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `spec` | `spec` | [`AIScheduleSpec`](#aischedulespec) | singular | — |
| `request_id` | `requestId` | `string` | singular | — |
| `paused` | `paused` | `bool` | singular | — |
| `channel_versions` | `channelVersions` | map&lt;`string`, `string`&gt; | map | — |

### CreateAIScheduleResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `schedule` | `schedule` | [`AISchedule`](#aischedule) | singular | — |

### GetAIScheduleCapabilitiesRequest

_No fields — send `{}`._

### GetAIScheduleCapabilitiesResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `capabilities` | `capabilities` | `string` | repeated | — |
| `max_owned_tasks` | `maxOwnedTasks` | `uint32` | singular | — |
| `max_enabled_tasks` | `maxEnabledTasks` | `uint32` | singular | — |
| `retention_days` | `retentionDays` | `uint32` | singular | — |
| `ai_enabled` | `aiEnabled` | `bool` | singular | — |
| `ai_configured` | `aiConfigured` | `bool` | singular | — |

### GetAIScheduleRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

### GetAIScheduleResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `schedule` | `schedule` | [`AISchedule`](#aischedule) | singular | — |

### GetAIScheduleRunRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

### GetAIScheduleRunResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`AIScheduleRun`](#aischedulerun) | singular | — |

### ListAIScheduleRunsRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `schedule_id` | `scheduleId` | `string` | singular | — |
| `offset` | `offset` | `uint32` | singular | — |

### ListAIScheduleRunsResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AIScheduleRun`](#aischedulerun) | repeated | — |
| `has_more` | `hasMore` | `bool` | singular | — |

### ListAISchedulesRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `state` | `state` | `string` | singular | — |
| `search` | `search` | `string` | singular | — |
| `offset` | `offset` | `uint32` | singular | — |

### ListAISchedulesResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AISchedule`](#aischedule) | repeated | — |
| `has_more` | `hasMore` | `bool` | singular | — |
| `unread_tasks` | `unreadTasks` | `uint32` | singular | — |

### ManageAIScheduleRequest

Context is returned by AIService's response in ai.proto to avoid a cycle.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `state` | `state` | `string` | singular | — |
| `expected_revision` | `expectedRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### ManageAIScheduleResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `state` | `state` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### PrepareAIScheduleRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `spec` | `spec` | [`AIScheduleSpec`](#aischedulespec) | singular | — |
| `description` | `description` | `string` | singular | Optional user-authored description. Never enables plans or effects. |

### PrepareAIScheduleResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `spec` | `spec` | [`AIScheduleSpec`](#aischedulespec) | singular | — |
| `upcoming` | `upcoming` | [`AIScheduleOccurrence`](#aischeduleoccurrence) | repeated | — |
| `required_permissions` | `requiredPermissions` | `string` | repeated | — |
| `can_enable` | `canEnable` | `bool` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `channel_versions` | `channelVersions` | map&lt;`string`, `string`&gt; | map | — |
| `recipients` | `recipients` | [`AIScheduleChannel`](#aischedulechannel) | repeated | — |

### PreviewAIScheduleRunRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `spec` | `spec` | [`AIScheduleSpec`](#aischedulespec) | singular | — |
| `request_id` | `requestId` | `string` | singular | — |

### PreviewAIScheduleRunResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`AIScheduleRun`](#aischedulerun) | singular | — |

### RetryAIScheduleEffectRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `run_id` | `runId` | `string` | singular | — |

### RetryAIScheduleEffectResponse

_No fields — send `{}`._

### RetryAIScheduleRunRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `request_id` | `requestId` | `string` | singular | — |

### RetryAIScheduleRunResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`AIScheduleRun`](#aischedulerun) | singular | — |

### RunAIScheduleNowRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `request_id` | `requestId` | `string` | singular | — |

### RunAIScheduleNowResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`AIScheduleRun`](#aischedulerun) | singular | — |

### SetAIScheduleRunReadRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

### SetAIScheduleRunReadResponse

_No fields — send `{}`._

### SetAIScheduleStateRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `state` | `state` | `string` | singular | — |
| `expected_revision` | `expectedRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### SetAIScheduleStateResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `schedule` | `schedule` | [`AISchedule`](#aischedule) | singular | — |

### UpdateAIScheduleRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `spec` | `spec` | [`AIScheduleSpec`](#aischedulespec) | singular | — |
| `expected_revision` | `expectedRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `channel_versions` | `channelVersions` | map&lt;`string`, `string`&gt; | map | — |

### UpdateAIScheduleResponse

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `schedule` | `schedule` | [`AISchedule`](#aischedule) | singular | — |

<a id="aischedule"></a>

<a id="aischeduleaction"></a>

<a id="aischedulechannel"></a>

<a id="aischeduleeffect"></a>

<a id="aischedulenotify"></a>

<a id="aischeduleoccurrence"></a>

<a id="aischedulerun"></a>

<a id="aischedulescope"></a>

<a id="aischedulespec"></a>

<a id="aischeduletiming"></a>

<a id="aischedulewindow"></a>
