<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# alert.proto — Alerting: rules, channels, alerts, silences

Schema: `tiyi.v1` · `alert.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### AlertService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListAlerts`](#alertservicelistalerts) | unary | (`alert:read`) |
| [`GetAlert`](#alertservicegetalert) | unary | (`alert:read`) |
| [`AckAlert`](#alertserviceackalert) | unary | (`alert:ack`) |
| [`ResolveAlert`](#alertserviceresolvealert) | unary | (`alert:resolve`) |
| [`ListAlertRules`](#alertservicelistalertrules) | unary | (`alert:read`) |
| [`GetAlertRule`](#alertservicegetalertrule) | unary | (`alert:read`) |
| [`UpsertAlertRule`](#alertserviceupsertalertrule) | unary | (`alert:write`) |
| [`ReplayAlertRule`](#alertservicereplayalertrule) | unary | (`alert:write`) |
| [`DeleteAlertRule`](#alertservicedeletealertrule) | unary | (`alert:write`) |
| [`ListAlertChannels`](#alertservicelistalertchannels) | unary | (`alert:read`) |
| [`GetAlertChannel`](#alertservicegetalertchannel) | unary | (`alert:read`) |
| [`UpsertAlertChannel`](#alertserviceupsertalertchannel) | unary | (`alert:write`) |
| [`DeleteAlertChannel`](#alertservicedeletealertchannel) | unary | (`alert:write`) |
| [`TestAlertChannel`](#alertservicetestalertchannel) | unary | (`alert:write`) |
| [`PreviewAlertRuleNotification`](#alertservicepreviewalertrulenotification) | unary | (`alert:write`) |
| [`ApplyAlertChannelToRules`](#alertserviceapplyalertchanneltorules) | unary | (`alert:write`) |
| [`ListAlertNotes`](#alertservicelistalertnotes) | unary | (`alert:read`) |
| [`ListAlertSilences`](#alertservicelistalertsilences) | unary | (`alert:read`) |
| [`CreateAlertSilence`](#alertservicecreatealertsilence) | unary | (`alert:write`) |
| [`DeleteAlertSilence`](#alertservicedeletealertsilence) | unary | (`alert:write`) |
| [`PreviewAlertSilence`](#alertservicepreviewalertsilence) | unary | (`alert:write`) |

## RPCs

### AlertService.ListAlerts

- **Procedure** `POST /tiyi.v1.AlertService/ListAlerts`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.ListAlertsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `status` | `status` | [`AlertStatus`](#alertstatus) | singular | — |
| `severity` | `severity` | [`AlertSeverity`](#alertseverity) | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `active_only` | `activeOnly` | `bool` | singular | Unresolved occurrences: both OPEN and ACKED. Mutually exclusive with status. |
| `rule_id` | `ruleId` | `string` | singular | — |
| `query` | `query` | `string` | singular | — |
| `start` | `start` | `google.protobuf.Timestamp` | singular | Filters occurrence opening time in [start, end). _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `end` | `end` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

**Response** — `tiyi.v1.ListAlertsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Alert`](#alert) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### AlertService.GetAlert

- **Procedure** `POST /tiyi.v1.AlertService/GetAlert`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.GetAlertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAlertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `alert` | `alert` | [`Alert`](#alert) | singular | — |

### AlertService.AckAlert

- **Procedure** `POST /tiyi.v1.AlertService/AckAlert`
- **Kind** unary
- **Auth** (`alert:ack`)

**Request** — `tiyi.v1.AckAlertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `note` | `note` | `string` | singular | — |

**Response** — `tiyi.v1.AckAlertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `alert` | `alert` | [`Alert`](#alert) | singular | — |

### AlertService.ResolveAlert

- **Procedure** `POST /tiyi.v1.AlertService/ResolveAlert`
- **Kind** unary
- **Auth** (`alert:resolve`)

**Request** — `tiyi.v1.ResolveAlertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `note` | `note` | `string` | singular | — |

**Response** — `tiyi.v1.ResolveAlertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `alert` | `alert` | [`Alert`](#alert) | singular | — |

### AlertService.ListAlertRules

- **Procedure** `POST /tiyi.v1.AlertService/ListAlertRules`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.ListAlertRulesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListAlertRulesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AlertRule`](#alertrule) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### AlertService.GetAlertRule

- **Procedure** `POST /tiyi.v1.AlertService/GetAlertRule`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.GetAlertRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAlertRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`AlertRule`](#alertrule) | singular | — |

### AlertService.UpsertAlertRule

- **Procedure** `POST /tiyi.v1.AlertService/UpsertAlertRule`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.UpsertAlertRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`AlertRule`](#alertrule) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpsertAlertRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`AlertRule`](#alertrule) | singular | — |

### AlertService.ReplayAlertRule

Replays an unsaved security-threshold condition against immutable facts from the preceding 24 hours. The response is read-only and does not create alerts, lifecycle events, or notification jobs.

- **Procedure** `POST /tiyi.v1.AlertService/ReplayAlertRule`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.ReplayAlertRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `expression` | `expression` | `string` | singular | The same JSON condition expression accepted by AlertRule.expression. |

**Response** — `tiyi.v1.ReplayAlertRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `started_at` | `startedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `ended_at` | `endedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `matching_event_count` | `matchingEventCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `trigger_count` | `triggerCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `resolved_count` | `resolvedCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `firing_notification_count` | `firingNotificationCount` | `int64` | singular | Logical lifecycle notification events before channel fan-out, silencing, channel severity floors, retries, or delivery failures. _JSON string (64-bit ints are quoted)._ |
| `resolved_notification_count` | `resolvedNotificationCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `open_at_end` | `openAtEnd` | `bool` | singular | — |

### AlertService.DeleteAlertRule

- **Procedure** `POST /tiyi.v1.AlertService/DeleteAlertRule`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.DeleteAlertRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteAlertRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### AlertService.ListAlertChannels

- **Procedure** `POST /tiyi.v1.AlertService/ListAlertChannels`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.ListAlertChannelsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListAlertChannelsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AlertChannel`](#alertchannel) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### AlertService.GetAlertChannel

- **Procedure** `POST /tiyi.v1.AlertService/GetAlertChannel`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.GetAlertChannelRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAlertChannelResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `channel` | `channel` | [`AlertChannel`](#alertchannel) | singular | — |

### AlertService.UpsertAlertChannel

- **Procedure** `POST /tiyi.v1.AlertService/UpsertAlertChannel`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.UpsertAlertChannelRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `channel` | `channel` | [`AlertChannel`](#alertchannel) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpsertAlertChannelResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `channel` | `channel` | [`AlertChannel`](#alertchannel) | singular | — |

### AlertService.DeleteAlertChannel

- **Procedure** `POST /tiyi.v1.AlertService/DeleteAlertChannel`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.DeleteAlertChannelRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteAlertChannelResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### AlertService.TestAlertChannel

- **Procedure** `POST /tiyi.v1.AlertService/TestAlertChannel`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.TestAlertChannelRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `channel` | `channel` | [`AlertChannel`](#alertchannel) | singular | — |

**Response** — `tiyi.v1.TestAlertChannelResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `success` | `success` | `bool` | singular | — |
| `message` | `message` | `string` | singular | — |

### AlertService.PreviewAlertRuleNotification

Renders an unsaved rule for a saved destination and lifecycle event, without delivery.

- **Procedure** `POST /tiyi.v1.AlertService/PreviewAlertRuleNotification`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.PreviewAlertRuleNotificationRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`AlertRule`](#alertrule) | singular | The complete, potentially unsaved rule, including condition and content. |
| `channel_id` | `channelId` | `string` | singular | A saved destination in the authenticated tenant. No secrets are hydrated. |
| `lifecycle_event` | `lifecycleEvent` | `string` | singular | — |

**Response** — `tiyi.v1.PreviewAlertRuleNotificationResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `title` | `title` | `string` | singular | — |
| `message` | `message` | `string` | singular | — |
| `markdown` | `markdown` | `string` | singular | — |
| `locale` | `locale` | `string` | singular | — |
| `timezone` | `timezone` | `string` | singular | — |

### AlertService.ApplyAlertChannelToRules

- **Procedure** `POST /tiyi.v1.AlertService/ApplyAlertChannelToRules`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.ApplyAlertChannelToRulesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `channel_id` | `channelId` | `string` | singular | — |
| `rule_ids` | `ruleIds` | `string` | repeated | — |

**Response** — `tiyi.v1.ApplyAlertChannelToRulesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `channel` | `channel` | [`AlertChannel`](#alertchannel) | singular | — |
| `rules` | `rules` | [`AlertRule`](#alertrule) | repeated | — |
| `changed_count` | `changedCount` | `int32` | singular | — |

### AlertService.ListAlertNotes

- **Procedure** `POST /tiyi.v1.AlertService/ListAlertNotes`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.ListAlertNotesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `alert_id` | `alertId` | `string` | singular | — |

**Response** — `tiyi.v1.ListAlertNotesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AlertNote`](#alertnote) | repeated | — |

### AlertService.ListAlertSilences

- **Procedure** `POST /tiyi.v1.AlertService/ListAlertSilences`
- **Kind** unary
- **Auth** (`alert:read`)

**Request** — `tiyi.v1.ListAlertSilencesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `active_only` | `activeOnly` | `bool` | singular | — |
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListAlertSilencesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AlertSilence`](#alertsilence) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### AlertService.CreateAlertSilence

- **Procedure** `POST /tiyi.v1.AlertService/CreateAlertSilence`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.CreateAlertSilenceRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `matchers` | `matchers` | map&lt;`string`, `string`&gt; | map | — |
| `starts_at` | `startsAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `ends_at` | `endsAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `reason` | `reason` | `string` | singular | — |

**Response** — `tiyi.v1.CreateAlertSilenceResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `silence` | `silence` | [`AlertSilence`](#alertsilence) | singular | — |

### AlertService.DeleteAlertSilence

- **Procedure** `POST /tiyi.v1.AlertService/DeleteAlertSilence`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.DeleteAlertSilenceRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteAlertSilenceResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### AlertService.PreviewAlertSilence

- **Procedure** `POST /tiyi.v1.AlertService/PreviewAlertSilence`
- **Kind** unary
- **Auth** (`alert:write`)

**Request** — `tiyi.v1.PreviewAlertSilenceRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `matchers` | `matchers` | map&lt;`string`, `string`&gt; | map | — |

**Response** — `tiyi.v1.PreviewAlertSilenceResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `matching_count` | `matchingCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `items` | `items` | [`Alert`](#alert) | repeated | At most 20 currently unresolved occurrences; this does not predict future alerts. |

## Messages

### Alert

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `severity` | `severity` | [`AlertSeverity`](#alertseverity) | singular | — |
| `status` | `status` | [`AlertStatus`](#alertstatus) | singular | — |
| `title` | `title` | `string` | singular | — |
| `message` | `message` | `string` | singular | — |
| `payload` | `payload` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `opened_at` | `openedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `acked_at` | `ackedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `resolved_at` | `resolvedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `last_matched_at` | `lastMatchedAt` | `google.protobuf.Timestamp` | singular | Last evaluation at which the rule condition matched. The payload is the evidence snapshot captured at this time and remains frozen after clear. _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `rule_id` | `ruleId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `evaluation_state` | `evaluationState` | `string` | singular | Condition state is independent of operator acknowledgement. |
| `closed_reason` | `closedReason` | `string` | singular | condition_cleared, operator, rule_changed, rule_disabled, rule_deleted |
| `firing_at` | `firingAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AlertChannel

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `kind` | `kind` | [`AlertChannelKind`](#alertchannelkind) | singular | — |
| `enabled` | `enabled` | `bool` | singular | — |
| `config` | `config` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AlertNote

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `alert_id` | `alertId` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `body` | `body` | `string` | singular | — |
| `actor_user_id` | `actorUserId` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AlertNotificationLocale

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `templates` | `templates` | map&lt;`string`, [`AlertNotificationTemplate`](#alertnotificationtemplate)&gt; | map | Exact lifecycle event keys; missing events/fields retain built-in content. |
| `custom_fields` | `customFields` | map&lt;`string`, `string`&gt; | map | — |

### AlertNotificationTemplate

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `title` | `title` | `string` | singular | — |
| `message` | `message` | `string` | singular | — |

### AlertRule

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `enabled` | `enabled` | `bool` | singular | — |
| `severity` | `severity` | [`AlertSeverity`](#alertseverity) | singular | — |
| `expression` | `expression` | `string` | singular | — |
| `channel_ids` | `channelIds` | `string` | repeated | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `notification` | `notification` | [`AlertRuleNotification`](#alertrulenotification) | singular | — |

### AlertRuleNotification

Business content belongs to the rule; the destination selects the locale.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `locales` | `locales` | map&lt;`string`, [`AlertNotificationLocale`](#alertnotificationlocale)&gt; | map | Supported keys: zh-CN and en-US. Missing locales use built-in content. |

### AlertSilence

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `matchers` | `matchers` | map&lt;`string`, `string`&gt; | map | — |
| `starts_at` | `startsAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `ends_at` | `endsAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `created_by` | `createdBy` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

## Enums

### AlertChannelKind

| Value | Number | Description |
|---|---|---|
| `ALERT_CHANNEL_KIND_UNSPECIFIED` | 0 | — |
| `ALERT_CHANNEL_KIND_EMAIL` | 1 | — |
| `ALERT_CHANNEL_KIND_WEBHOOK` | 2 | — |
| `ALERT_CHANNEL_KIND_SLACK` | 3 | — |
| `ALERT_CHANNEL_KIND_PAGERDUTY` | 4 | — |
| `ALERT_CHANNEL_KIND_FEISHU` | 5 | — |
| `ALERT_CHANNEL_KIND_WECOM` | 6 | — |

### AlertSeverity

| Value | Number | Description |
|---|---|---|
| `ALERT_SEVERITY_UNSPECIFIED` | 0 | — |
| `ALERT_SEVERITY_INFO` | 1 | — |
| `ALERT_SEVERITY_WARNING` | 2 | — |
| `ALERT_SEVERITY_CRITICAL` | 3 | — |

### AlertStatus

| Value | Number | Description |
|---|---|---|
| `ALERT_STATUS_UNSPECIFIED` | 0 | — |
| `ALERT_STATUS_OPEN` | 1 | — |
| `ALERT_STATUS_ACKED` | 2 | — |
| `ALERT_STATUS_RESOLVED` | 3 | — |
