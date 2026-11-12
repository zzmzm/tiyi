<!-- v3.8.1 public API reference, derived from the protobuf contract. -->

# ai.proto — AI copilot and advisory proposals

Schema: `tiyi.v1` · `ai.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### AIService

| RPC | Kind | Required permission |
|---|---|---|
| [`GetAIScheduleCapabilities`](#aiservicegetaischedulecapabilities) | unary | `ai:read` and `ai:schedule:read` |
| [`PrepareAISchedule`](#aiserviceprepareaischedule) | unary | `ai:read` and `ai:schedule:read` and `ai:schedule:write` |
| [`CreateAISchedule`](#aiservicecreateaischedule) | unary | `ai:read` and `ai:schedule:read` and `ai:schedule:write` |
| [`UpdateAISchedule`](#aiserviceupdateaischedule) | unary | `ai:read` and `ai:schedule:read` and `ai:schedule:write` |
| [`ListAISchedules`](#aiservicelistaischedules) | unary | `ai:read` and `ai:schedule:read` |
| [`GetAISchedule`](#aiservicegetaischedule) | unary | `ai:read` and `ai:schedule:read` |
| [`SetAIScheduleState`](#aiservicesetaischedulestate) | unary | `ai:read` and `ai:schedule:read` |
| [`RunAIScheduleNow`](#aiservicerunaischedulenow) | unary | `ai:read` and `ai:schedule:read` and `ai:schedule:write` |
| [`PreviewAIScheduleRun`](#aiservicepreviewaischedulerun) | unary | `ai:read` and `ai:schedule:read` and `ai:schedule:write` |
| [`RetryAIScheduleRun`](#aiserviceretryaischedulerun) | unary | `ai:read` and `ai:schedule:read` and `ai:schedule:write` |
| [`CancelAIScheduleRun`](#aiservicecancelaischedulerun) | unary | `ai:read` and `ai:schedule:read` |
| [`ListAIScheduleRuns`](#aiservicelistaischeduleruns) | unary | `ai:read` and `ai:schedule:read` |
| [`GetAIScheduleRun`](#aiservicegetaischedulerun) | unary | `ai:read` and `ai:schedule:read` |
| [`SetAIScheduleRunRead`](#aiservicesetaischedulerunread) | unary | `ai:read` and `ai:schedule:read` |
| [`ContinueAIScheduleRun`](#aiservicecontinueaischedulerun) | unary | `ai:read` and `ai:schedule:read` |
| [`ManageAISchedule`](#aiservicemanageaischedule) | unary | `ai:read` and `ai:schedule:manage` |
| [`RetryAIScheduleEffect`](#aiserviceretryaischeduleeffect) | unary | `ai:read` and `ai:schedule:read` and `ai:schedule:write` |
| [`ListAIProposals`](#aiservicelistaiproposals) | unary | (`ai:read`) |
| [`GetAIProposal`](#aiservicegetaiproposal) | unary | (`ai:read`) |
| [`GetAIStatus`](#aiservicegetaistatus) | unary | (`ai:read`) |
| [`GetAIConversationContext`](#aiservicegetaiconversationcontext) | unary | (`ai:read`) |
| [`SubmitAIAnalysisFeedback`](#aiservicesubmitaianalysisfeedback) | unary | (`ai:read`) |
| [`ListAIAnalysisFeedback`](#aiservicelistaianalysisfeedback) | unary | `ai:read` and `system:write` |
| [`GetAIAnalysisFeedback`](#aiservicegetaianalysisfeedback) | unary | `ai:read` and `system:write` |
| [`ReviewAIAnalysisFeedback`](#aiservicereviewaianalysisfeedback) | unary | `ai:read` and `system:write` |
| [`DraftCustomRule`](#aiservicedraftcustomrule) | unary | `ai:read` and `ai:propose` and `policy:read` |
| [`PrepareAIIPDisposition`](#aiserviceprepareaiipdisposition) | unary | `ai:read` and `ai:propose` and `policy:read` and `site:read` and `log:read` and `telemetry:read` |
| [`TestAIProposal`](#aiservicetestaiproposal) | unary | `ai:read` and `policy:preview` and `policy:read` |
| [`PrepareAITuning`](#aiserviceprepareaituning) | unary | `ai:propose` and `policy:read` and `site:read` and `log:read` |
| [`GetAITuningReview`](#aiservicegetaituningreview) | unary | `ai:read` and `policy:read` and `site:read` and `log:read` |
| [`ReplayAITuning`](#aiservicereplayaituning) | unary | `ai:read` and `policy:preview` and `policy:read` and `site:read` and `log:read` |
| [`StreamAITuningAnalysis`](#aiservicestreamaituninganalysis) | server stream | `ai:read` and `policy:read` and `site:read` and `log:read` |
| [`TranslateLogQuery`](#aiservicetranslatelogquery) | unary | (`ai:read`) |
| [`StreamAnalysis`](#aiservicestreamanalysis) | server stream | `ai:read` and `log:read` |
| [`StreamAPIContractAnalysis`](#aiservicestreamapicontractanalysis) | server stream | `ai:read` and `site:read` and `telemetry:read` |
| [`StreamRuleImpactAnalysis`](#aiservicestreamruleimpactanalysis) | server stream | `ai:read` and `policy:read` and `log:read` and `telemetry:read` |
| [`StreamOperationsAnalysis`](#aiservicestreamoperationsanalysis) | server stream | `ai:read` and `system:read` |
| [`StreamAlertAnalysis`](#aiservicestreamalertanalysis) | server stream | `ai:read` and `alert:read` |
| [`CompareAIAlertRule`](#aiservicecompareaialertrule) | unary | `ai:read` and `alert:write` and `alert:read` |
| [`StreamAlertTuningAnalysis`](#aiservicestreamalerttuninganalysis) | server stream | `ai:read` and `alert:write` and `alert:read` |
| [`PrepareAISecurityReport`](#aiserviceprepareaisecurityreport) | unary | `ai:read` and `log:read` and `telemetry:read` and `site:read` |
| [`StreamSecurityReportAnalysis`](#aiservicestreamsecurityreportanalysis) | server stream | `ai:read` and `log:read` and `telemetry:read` and `site:read` |
| [`StreamConfigurationReview`](#aiservicestreamconfigurationreview) | server stream | `ai:read` and `system:apply` and `site:read` and `policy:read` |
| [`StreamCrsUpgradeReview`](#aiservicestreamcrsupgradereview) | server stream | `ai:read` and `policy:preview` and `policy:read` and `site:read` |
| [`StreamChat`](#aiservicestreamchat) | server stream | `ai:read` |
| [`ApplyAIProposal`](#aiserviceapplyaiproposal) | unary | (`ai:apply`) |
| [`ReviseAIProposal`](#aiservicereviseaiproposal) | unary | `ai:read` and `ai:propose` and `policy:read` |
| [`RejectAIProposal`](#aiservicerejectaiproposal) | unary | (`ai:propose`) |
| [`SetAIProviderSecret`](#aiservicesetaiprovidersecret) | unary | (`system:write`) |

## RPCs

### AIService.GetAIScheduleCapabilities

Durable owner-bound analysis plans. Each source and effect is reauthorized.

- **Procedure** `POST /tiyi.v1.AIService/GetAIScheduleCapabilities`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.GetAIScheduleCapabilitiesRequest`

[`GetAIScheduleCapabilitiesRequest`](ai_schedule.md#getaischedulecapabilitiesrequest)

**Response** — `tiyi.v1.GetAIScheduleCapabilitiesResponse`

[`GetAIScheduleCapabilitiesResponse`](ai_schedule.md#getaischedulecapabilitiesresponse)

### AIService.PrepareAISchedule

- **Procedure** `POST /tiyi.v1.AIService/PrepareAISchedule`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read` and `ai:schedule:write`

**Request** — `tiyi.v1.PrepareAIScheduleRequest`

[`PrepareAIScheduleRequest`](ai_schedule.md#prepareaischedulerequest)

**Response** — `tiyi.v1.PrepareAIScheduleResponse`

[`PrepareAIScheduleResponse`](ai_schedule.md#prepareaischeduleresponse)

### AIService.CreateAISchedule

- **Procedure** `POST /tiyi.v1.AIService/CreateAISchedule`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read` and `ai:schedule:write`

**Request** — `tiyi.v1.CreateAIScheduleRequest`

[`CreateAIScheduleRequest`](ai_schedule.md#createaischedulerequest)

**Response** — `tiyi.v1.CreateAIScheduleResponse`

[`CreateAIScheduleResponse`](ai_schedule.md#createaischeduleresponse)

### AIService.UpdateAISchedule

- **Procedure** `POST /tiyi.v1.AIService/UpdateAISchedule`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read` and `ai:schedule:write`

**Request** — `tiyi.v1.UpdateAIScheduleRequest`

[`UpdateAIScheduleRequest`](ai_schedule.md#updateaischedulerequest)

**Response** — `tiyi.v1.UpdateAIScheduleResponse`

[`UpdateAIScheduleResponse`](ai_schedule.md#updateaischeduleresponse)

### AIService.ListAISchedules

- **Procedure** `POST /tiyi.v1.AIService/ListAISchedules`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.ListAISchedulesRequest`

[`ListAISchedulesRequest`](ai_schedule.md#listaischedulesrequest)

**Response** — `tiyi.v1.ListAISchedulesResponse`

[`ListAISchedulesResponse`](ai_schedule.md#listaischedulesresponse)

### AIService.GetAISchedule

- **Procedure** `POST /tiyi.v1.AIService/GetAISchedule`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.GetAIScheduleRequest`

[`GetAIScheduleRequest`](ai_schedule.md#getaischedulerequest)

**Response** — `tiyi.v1.GetAIScheduleResponse`

[`GetAIScheduleResponse`](ai_schedule.md#getaischeduleresponse)

### AIService.SetAIScheduleState

- **Procedure** `POST /tiyi.v1.AIService/SetAIScheduleState`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.SetAIScheduleStateRequest`

[`SetAIScheduleStateRequest`](ai_schedule.md#setaischedulestaterequest)

**Response** — `tiyi.v1.SetAIScheduleStateResponse`

[`SetAIScheduleStateResponse`](ai_schedule.md#setaischedulestateresponse)

### AIService.RunAIScheduleNow

- **Procedure** `POST /tiyi.v1.AIService/RunAIScheduleNow`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read` and `ai:schedule:write`

**Request** — `tiyi.v1.RunAIScheduleNowRequest`

[`RunAIScheduleNowRequest`](ai_schedule.md#runaischedulenowrequest)

**Response** — `tiyi.v1.RunAIScheduleNowResponse`

[`RunAIScheduleNowResponse`](ai_schedule.md#runaischedulenowresponse)

### AIService.PreviewAIScheduleRun

- **Procedure** `POST /tiyi.v1.AIService/PreviewAIScheduleRun`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read` and `ai:schedule:write`

**Request** — `tiyi.v1.PreviewAIScheduleRunRequest`

[`PreviewAIScheduleRunRequest`](ai_schedule.md#previewaischedulerunrequest)

**Response** — `tiyi.v1.PreviewAIScheduleRunResponse`

[`PreviewAIScheduleRunResponse`](ai_schedule.md#previewaischedulerunresponse)

### AIService.RetryAIScheduleRun

- **Procedure** `POST /tiyi.v1.AIService/RetryAIScheduleRun`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read` and `ai:schedule:write`

**Request** — `tiyi.v1.RetryAIScheduleRunRequest`

[`RetryAIScheduleRunRequest`](ai_schedule.md#retryaischedulerunrequest)

**Response** — `tiyi.v1.RetryAIScheduleRunResponse`

[`RetryAIScheduleRunResponse`](ai_schedule.md#retryaischedulerunresponse)

### AIService.CancelAIScheduleRun

- **Procedure** `POST /tiyi.v1.AIService/CancelAIScheduleRun`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.CancelAIScheduleRunRequest`

[`CancelAIScheduleRunRequest`](ai_schedule.md#cancelaischedulerunrequest)

**Response** — `tiyi.v1.CancelAIScheduleRunResponse`

[`CancelAIScheduleRunResponse`](ai_schedule.md#cancelaischedulerunresponse)

### AIService.ListAIScheduleRuns

- **Procedure** `POST /tiyi.v1.AIService/ListAIScheduleRuns`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.ListAIScheduleRunsRequest`

[`ListAIScheduleRunsRequest`](ai_schedule.md#listaischedulerunsrequest)

**Response** — `tiyi.v1.ListAIScheduleRunsResponse`

[`ListAIScheduleRunsResponse`](ai_schedule.md#listaischedulerunsresponse)

### AIService.GetAIScheduleRun

- **Procedure** `POST /tiyi.v1.AIService/GetAIScheduleRun`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.GetAIScheduleRunRequest`

[`GetAIScheduleRunRequest`](ai_schedule.md#getaischedulerunrequest)

**Response** — `tiyi.v1.GetAIScheduleRunResponse`

[`GetAIScheduleRunResponse`](ai_schedule.md#getaischedulerunresponse)

### AIService.SetAIScheduleRunRead

- **Procedure** `POST /tiyi.v1.AIService/SetAIScheduleRunRead`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.SetAIScheduleRunReadRequest`

[`SetAIScheduleRunReadRequest`](ai_schedule.md#setaischedulerunreadrequest)

**Response** — `tiyi.v1.SetAIScheduleRunReadResponse`

[`SetAIScheduleRunReadResponse`](ai_schedule.md#setaischedulerunreadresponse)

### AIService.ContinueAIScheduleRun

- **Procedure** `POST /tiyi.v1.AIService/ContinueAIScheduleRun`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read`

**Request** — `tiyi.v1.ContinueAIScheduleRunRequest`

[`ContinueAIScheduleRunRequest`](ai_schedule.md#continueaischedulerunrequest)

**Response** — `tiyi.v1.ContinueAIScheduleRunResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `context` | `context` | [`AIConversationContext`](#aiconversationcontext) | singular | — |
| `title` | `title` | `string` | singular | — |
| `body` | `body` | `string` | singular | — |
| `run_id` | `runId` | `string` | singular | — |

### AIService.ManageAISchedule

- **Procedure** `POST /tiyi.v1.AIService/ManageAISchedule`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:manage`

**Request** — `tiyi.v1.ManageAIScheduleRequest`

[`ManageAIScheduleRequest`](ai_schedule.md#manageaischedulerequest)

**Response** — `tiyi.v1.ManageAIScheduleResponse`

[`ManageAIScheduleResponse`](ai_schedule.md#manageaischeduleresponse)

### AIService.RetryAIScheduleEffect

- **Procedure** `POST /tiyi.v1.AIService/RetryAIScheduleEffect`
- **Kind** unary
- **Auth** `ai:read` and `ai:schedule:read` and `ai:schedule:write`

**Request** — `tiyi.v1.RetryAIScheduleEffectRequest`

[`RetryAIScheduleEffectRequest`](ai_schedule.md#retryaischeduleeffectrequest)

**Response** — `tiyi.v1.RetryAIScheduleEffectResponse`

[`RetryAIScheduleEffectResponse`](ai_schedule.md#retryaischeduleeffectresponse)

### AIService.ListAIProposals

- **Procedure** `POST /tiyi.v1.AIService/ListAIProposals`
- **Kind** unary
- **Auth** (`ai:read`)

**Request** — `tiyi.v1.ListAIProposalsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`CursorRequest`](common.md#cursorrequest) | singular | — |
| `status` | `status` | [`AIProposalStatus`](#aiproposalstatus) | singular | optional filter; UNSPECIFIED = any |

**Response** — `tiyi.v1.ListAIProposalsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AIProposal`](#aiproposal) | repeated | — |
| `page` | `page` | [`CursorResponse`](common.md#cursorresponse) | singular | — |

### AIService.GetAIProposal

- **Procedure** `POST /tiyi.v1.AIService/GetAIProposal`
- **Kind** unary
- **Auth** (`ai:read`)

**Request** — `tiyi.v1.GetAIProposalRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAIProposalResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | — |

### AIService.GetAIStatus

GetAIStatus reports whether the layer is enabled/configured and the provider settings — drives the UI "AI Advisor" availability banner.

- **Procedure** `POST /tiyi.v1.AIService/GetAIStatus`
- **Kind** unary
- **Auth** (`ai:read`)

**Request** — `tiyi.v1.GetAIStatusRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetAIStatusResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enabled` | `enabled` | `bool` | singular | ai.enabled |
| `configured` | `configured` | `bool` | singular | recognized provider + base URL + model; not a connection test |
| `provider` | `provider` | `string` | singular | openai_compatible \| azure_openai \| disabled |
| `model_summary` | `modelSummary` | `string` | singular | — |

### AIService.GetAIConversationContext

Resolve an owner-bound short-lived evidence reference, rechecking every source permission and freshness. No provider call or configuration change.

- **Procedure** `POST /tiyi.v1.AIService/GetAIConversationContext`
- **Kind** unary
- **Auth** (`ai:read`)

**Request** — `tiyi.v1.GetAIConversationContextRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAIConversationContextResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `context` | `context` | [`AIConversationContext`](#aiconversationcontext) | singular | — |

### AIService.SubmitAIAnalysisFeedback

Explicit feedback saves a bounded redacted copy of a completed answer and its evidence for 90-day review access. It is not a training label or approval.

- **Procedure** `POST /tiyi.v1.AIService/SubmitAIAnalysisFeedback`
- **Kind** unary
- **Auth** (`ai:read`)

**Request** — `tiyi.v1.SubmitAIAnalysisFeedbackRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `context_id` | `contextId` | `string` | singular | — |
| `issue` | `issue` | `string` | singular | — |
| `comment` | `comment` | `string` | singular | — |

**Response** — `tiyi.v1.SubmitAIAnalysisFeedbackResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `feedback` | `feedback` | [`AIAnalysisFeedback`](#aianalysisfeedback) | singular | — |

### AIService.ListAIAnalysisFeedback

Feedback administration also rechecks the original source permissions.

- **Procedure** `POST /tiyi.v1.AIService/ListAIAnalysisFeedback`
- **Kind** unary
- **Auth** `ai:read` and `system:write`

**Request** — `tiyi.v1.ListAIAnalysisFeedbackRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `status` | `status` | `string` | singular | — |
| `before_id` | `beforeId` | `string` | singular | — |

**Response** — `tiyi.v1.ListAIAnalysisFeedbackResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AIAnalysisFeedback`](#aianalysisfeedback) | repeated | — |
| `next_before_id` | `nextBeforeId` | `string` | singular | — |

### AIService.GetAIAnalysisFeedback

- **Procedure** `POST /tiyi.v1.AIService/GetAIAnalysisFeedback`
- **Kind** unary
- **Auth** `ai:read` and `system:write`

**Request** — `tiyi.v1.GetAIAnalysisFeedbackRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAIAnalysisFeedbackResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `feedback` | `feedback` | [`AIAnalysisFeedback`](#aianalysisfeedback) | singular | — |

### AIService.ReviewAIAnalysisFeedback

- **Procedure** `POST /tiyi.v1.AIService/ReviewAIAnalysisFeedback`
- **Kind** unary
- **Auth** `ai:read` and `system:write`

**Request** — `tiyi.v1.ReviewAIAnalysisFeedbackRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `status` | `status` | `string` | singular | — |
| `note` | `note` | `string` | singular | — |

**Response** — `tiyi.v1.ReviewAIAnalysisFeedbackResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `feedback` | `feedback` | [`AIAnalysisFeedback`](#aianalysisfeedback) | singular | — |

### AIService.DraftCustomRule

Proposal generation (require ai:propose). Returns drafts; mutates no policy. The generated proposal is stored as a draft ai_proposal the operator later applies through ApplyAIProposal.

- **Procedure** `POST /tiyi.v1.AIService/DraftCustomRule`
- **Kind** unary
- **Auth** `ai:read` and `ai:propose` and `policy:read`

**Request** — `tiyi.v1.DraftCustomRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent` | `intent` | `string` | singular | intent is the operator's natural-language description / CVE / threat intel ("block requests with X-Debug header to /admin"). |
| `policy_id` | `policyId` | `string` | singular | — |

**Response** — `tiyi.v1.DraftCustomRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | proposal is a stored draft of kind CUSTOM_RULE (patch carries the visualrule.Spec JSON). Apply it via ApplyAIProposal. |
| `seclang_preview` | `seclangPreview` | `string` | singular | seclang_preview is the compiled SecLang for the drafted rule. An explicit blocking request may produce action=block; otherwise action=log. Drafting and testing never apply the rule to live configuration. |
| `warnings` | `warnings` | `string` | repeated | — |

### AIService.PrepareAIIPDisposition

Explicit UI preview: refresh the selected IP investigation and save a concrete draft. Never applies configuration; ApplyAIProposal approves it.

- **Procedure** `POST /tiyi.v1.AIService/PrepareAIIPDisposition`
- **Kind** unary
- **Auth** `ai:read` and `ai:propose` and `policy:read` and `site:read` and `log:read` and `telemetry:read`

**Request** — `tiyi.v1.PrepareAIIPDispositionRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `context_id` | `contextId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `ip` | `ip` | `string` | singular | — |
| `action` | `action` | `string` | singular | deny, monitor, unblock |
| `ttl_seconds` | `ttlSeconds` | `int64` | singular | additions only: 3600, 86400 or 604800 _JSON string (64-bit ints are quoted)._ |
| `list_id` | `listId` | `string` | singular | empty = select a compatible group or create a dedicated one |
| `request_id` | `requestId` | `string` | singular | — |
| `proposal_id` | `proposalId` | `string` | singular | Adjust this pending plan instead of a conversation source. |
| `review_id` | `reviewId` | `string` | singular | Exact plan being replaced; replacement is atomic. |
| `ips` | `ips` | `string` | repeated | Revision only: nonempty subset of original IPs. |
| `new_list_name` | `newListName` | `string` | singular | Revision only: explicit new compatible group. |
| `reason` | `reason` | `string` | singular | Revision only: operator's disposition rationale. |

**Response** — `tiyi.v1.PrepareAIIPDispositionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | — |

### AIService.TestAIProposal

Replay one operator-supplied request against the current policy and an in-memory copy containing the draft. No provider, upstream request, persistent rule, audit mutation, or configuration publication is created.

- **Procedure** `POST /tiyi.v1.AIService/TestAIProposal`
- **Kind** unary
- **Auth** `ai:read` and `policy:preview` and `policy:read`

**Request** — `tiyi.v1.TestAIProposalRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `sample` | `sample` | [`TestPolicyRequest`](policy.md#testpolicyrequest) | singular | policy_id must be empty or match the proposal |

**Response** — `tiyi.v1.TestAIProposalResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `baseline` | `baseline` | [`TestPolicyResponse`](policy.md#testpolicyresponse) | singular | — |
| `candidate` | `candidate` | [`TestPolicyResponse`](policy.md#testpolicyresponse) | singular | — |
| `rule_matched` | `ruleMatched` | `bool` | singular | — |
| `policy_revision` | `policyRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AIService.PrepareAITuning

Prepare a literal field-exclusion candidate from retained match evidence and an operator's business annotation. Does not call a model or change WAF.

- **Procedure** `POST /tiyi.v1.AIService/PrepareAITuning`
- **Kind** unary
- **Auth** `ai:propose` and `policy:read` and `site:read` and `log:read`

**Request** — `tiyi.v1.PrepareAITuningRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `event_id` | `eventId` | `string` | singular | — |
| `rule_id` | `ruleId` | `string` | singular | — |
| `target` | `target` | `string` | singular | — |
| `business_reason` | `businessReason` | `string` | singular | Operator explanation of the field's legitimate business use. |

**Response** — `tiyi.v1.PrepareAITuningResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | — |

### AIService.GetAITuningReview

- **Procedure** `POST /tiyi.v1.AIService/GetAITuningReview`
- **Kind** unary
- **Auth** `ai:read` and `policy:read` and `site:read` and `log:read`

**Request** — `tiyi.v1.GetAITuningReviewRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetAITuningReviewResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | — |
| `report` | `report` | [`AITuningReport`](#aituningreport) | singular | — |
| `verification` | `verification` | [`AITuningReport`](#aituningreport) | singular | — |
| `configuration_current` | `configurationCurrent` | `bool` | singular | — |
| `applied_at` | `appliedAt` | `string` | singular | persisted time, not fleet-wide apply time |
| `apply_error` | `applyError` | `string` | singular | — |
| `before` | `before` | [`AITuningTrafficWindow`](#aituningtrafficwindow) | singular | — |
| `after` | `after` | [`AITuningTrafficWindow`](#aituningtrafficwindow) | singular | — |
| `deployments` | `deployments` | [`AITuningDeployment`](#aituningdeployment) | repeated | — |
| `deployment_state` | `deploymentState` | `string` | singular | available \| unavailable \| permission_required |

### AIService.ReplayAITuning

Labelled requests remain transient. Stores only hashes and replay results. Accepted proposals rerun the identical batch against current desired state.

- **Procedure** `POST /tiyi.v1.AIService/ReplayAITuning`
- **Kind** unary
- **Auth** `ai:read` and `policy:preview` and `policy:read` and `site:read` and `log:read`

**Request** — `tiyi.v1.ReplayAITuningRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `samples` | `samples` | [`AITuningSample`](#aituningsample) | repeated | — |

**Response** — `tiyi.v1.ReplayAITuningResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `report` | `report` | [`AITuningReport`](#aituningreport) | singular | — |

### AIService.StreamAITuningAnalysis

- **Procedure** `POST /tiyi.v1.AIService/StreamAITuningAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `policy:read` and `site:read` and `log:read`

**Request** — `tiyi.v1.StreamAITuningAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.StreamAITuningAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.TranslateLogQuery

Read/advisory (require ai:read). NL->typed query never emits raw SQL.

- **Procedure** `POST /tiyi.v1.AIService/TranslateLogQuery`
- **Kind** unary
- **Auth** (`ai:read`)

**Request** — `tiyi.v1.TranslateLogQueryRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | `string` | singular | e.g. "SQLi from CN in the last 6h that weren't blocked" |

**Response** — `tiyi.v1.TranslateLogQueryResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | [`SecurityEventQuery`](#securityeventquery) | singular | — |
| `notes` | `notes` | `string` | singular | notes carries any caveat the translator wants surfaced (e.g. a term it could not map to a typed field). |
| `complete` | `complete` | `bool` | singular | false means constraints remain unmapped; do not execute as an exact query |
| `unmapped_terms` | `unmappedTerms` | `string` | repeated | original excerpts, rendered alongside a localized warning |

### AIService.StreamAnalysis

StreamAnalysis streams a plain-text (markdown) explanation for one subject: a single retained log event or the current log table. Advisory only; it never mutates state. Requires ai:read (middleware) AND the subject's log:read permission, enforced in the handler so it can never be a side channel to logs. Provider deltas are forwarded as chunks; the final chunk sets done=true + token_cost. The call is bound by the shared rate limit, an input cap, and ai.timeout; a client disconnect cancels the provider call (docs/design/ai-copilot-analysis.md).

- **Procedure** `POST /tiyi.v1.AIService/StreamAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `log:read`

**Request** — `tiyi.v1.StreamAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `log_event` | `logEvent` | [`LogEventRef`](#logeventref) | singular | Part of oneof `subject`. |
| `log_table` | `logTable` | [`LogTable`](#logtable) | singular | Part of oneof `subject`. |

**Response** — `tiyi.v1.StreamAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | Task assistants send server-authored evidence scope before model text. |

### AIService.StreamAPIContractAnalysis

Analyze the selected API's current saved request definition and value-free learned field evidence. No document, binding or runtime change is made.

- **Procedure** `POST /tiyi.v1.AIService/StreamAPIContractAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `site:read` and `telemetry:read`

**Request** — `tiyi.v1.StreamAPIContractAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `api_asset_id` | `apiAssetId` | `string` | singular | — |

**Response** — `tiyi.v1.StreamAPIContractAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.StreamRuleImpactAnalysis

Review a saved custom rule against bounded historical findings and independent received counters. This is not a counterfactual replay or a measured false-positive rate. The selected policy/rule binding is checked.

- **Procedure** `POST /tiyi.v1.AIService/StreamRuleImpactAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `policy:read` and `log:read` and `telemetry:read`

**Request** — `tiyi.v1.StreamRuleImpactAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `custom_rule_id` | `customRuleId` | `string` | singular | — |
| `lookback_seconds` | `lookbackSeconds` | `int64` | singular | default 3600, maximum 604800 (7 days) _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.StreamRuleImpactAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.StreamOperationsAnalysis

Diagnose the Controller's current health and local observation queues. No raw error logs, secrets, configuration writes or shell execution.

- **Procedure** `POST /tiyi.v1.AIService/StreamOperationsAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `system:read`

**Request** — `tiyi.v1.StreamOperationsAnalysisRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.StreamOperationsAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.StreamAlertAnalysis

Explain a saved alert's frozen matching evidence and current lifecycle.

- **Procedure** `POST /tiyi.v1.AIService/StreamAlertAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `alert:read`

**Request** — `tiyi.v1.StreamAlertAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `alert_id` | `alertId` | `string` | singular | — |

**Response** — `tiyi.v1.StreamAlertAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.CompareAIAlertRule

Compare saved and unsaved security thresholds on the same received series. No provider or persistent alert/configuration/notification mutation.

- **Procedure** `POST /tiyi.v1.AIService/CompareAIAlertRule`
- **Kind** unary
- **Auth** `ai:read` and `alert:write` and `alert:read`

**Request** — `tiyi.v1.CompareAIAlertRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule_id` | `ruleId` | `string` | singular | — |
| `candidate_expression` | `candidateExpression` | `string` | singular | bounded unsaved editor condition |

**Response** — `tiyi.v1.CompareAIAlertRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule_name` | `ruleName` | `string` | singular | — |
| `baseline_expression` | `baselineExpression` | `string` | singular | — |
| `candidate_expression` | `candidateExpression` | `string` | singular | — |
| `baseline` | `baseline` | [`ReplayAlertRuleResponse`](alert.md#replayalertruleresponse) | singular | — |
| `candidate` | `candidate` | [`ReplayAlertRuleResponse`](alert.md#replayalertruleresponse) | singular | — |
| `context` | `context` | [`AIConversationContext`](#aiconversationcontext) | singular | — |
| `rule_updated_at` | `ruleUpdatedAt` | `string` | singular | — |

### AIService.StreamAlertTuningAnalysis

Explain an owned, still-current comparison. Does not generate or apply a rule.

- **Procedure** `POST /tiyi.v1.AIService/StreamAlertTuningAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `alert:write` and `alert:read`

**Request** — `tiyi.v1.StreamAlertTuningAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `context_id` | `contextId` | `string` | singular | — |

**Response** — `tiyi.v1.StreamAlertTuningAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.PrepareAISecurityReport

Freeze a bounded investigation: received counters and retained examples. Requires explicit absolute bounds; page/cursor selection is not supported. No provider call, persistent report or configuration change.

- **Procedure** `POST /tiyi.v1.AIService/PrepareAISecurityReport`
- **Kind** unary
- **Auth** `ai:read` and `log:read` and `telemetry:read` and `site:read`

**Request** — `tiyi.v1.PrepareAISecurityReportRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `query` | `query` | [`QuerySecurityEventsRequest`](log.md#querysecurityeventsrequest) | singular | — |
| `timezone` | `timezone` | `string` | singular | IANA timezone used to display the absolute bounds |

**Response** — `tiyi.v1.PrepareAISecurityReportResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `report` | `report` | [`AISecurityReport`](#aisecurityreport) | singular | — |
| `context` | `context` | [`AIConversationContext`](#aiconversationcontext) | singular | — |

### AIService.StreamSecurityReportAnalysis

Explain an owner-bound report snapshot without repeating its source reads.

- **Procedure** `POST /tiyi.v1.AIService/StreamSecurityReportAnalysis`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `log:read` and `telemetry:read` and `site:read`

**Request** — `tiyi.v1.StreamSecurityReportAnalysisRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `context_id` | `contextId` | `string` | singular | — |

**Response** — `tiyi.v1.StreamSecurityReportAnalysisResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.StreamConfigurationReview

Recompute a previewed manifest against the same desired configuration. Raw manifest bytes and secret-bearing spec values never enter AI evidence.

- **Procedure** `POST /tiyi.v1.AIService/StreamConfigurationReview`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `system:apply` and `site:read` and `policy:read`

**Request** — `tiyi.v1.StreamConfigurationReviewRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `manifest_yaml` | `manifestYaml` | `bytes` | singular | _base64-encoded JSON string._ |
| `review_token` | `reviewToken` | `string` | singular | — |

**Response** — `tiyi.v1.StreamConfigurationReviewResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.StreamCrsUpgradeReview

Explain the server's CRS catalog diff and policy compile result. Read-only.

- **Procedure** `POST /tiyi.v1.AIService/StreamCrsUpgradeReview`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `policy:preview` and `policy:read` and `site:read`

**Request** — `tiyi.v1.StreamCrsUpgradeReviewRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `crs_ruleset_id` | `crsRulesetId` | `string` | singular | — |
| `review_token` | `reviewToken` | `string` | singular | — |

**Response** — `tiyi.v1.StreamCrsUpgradeReviewResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `context` | `context` | [`AIAnalysisContext`](#aianalysiscontext) | singular | — |

### AIService.StreamChat

StreamChat is the conversational Copilot ability: a free-talk, multi-turn assistant that answers open-ended operator questions by driving the EXISTING log query/filter/summary capabilities itself (docs/design/ai-copilot-analysis.md § Chat agent). It adds NO new log query surface — the model calls read-only tools that are thin in-process wrappers over the same tenant-scoped queries the Log pages already use (security/access summaries + filtered event lookups + site resolution), then summarizes the results to answer questions like "top 10 attackers in the last hour", "is 1.1.1.5 evil?", or "was www.test.com attacked today, from which IP and what attack type?". The client replays prose in history and an optional opaque context_id references owner-bound evidence. Investigation tools are tenant-scoped and read-only. With ai:propose the model may save typed IP or security-rule drafts; it cannot approve a proposal, change configuration or block traffic. Requires ai:read plus ALL snapshot source permissions in the handler. Unscoped chat exposes only capabilities permitted by the caller. Rule drafting requires policy:read, site:read and ai:propose, without log evidence. Counter/report tools require telemetry:read and their sources. IP tools also require policy:read. Report and security/ access log snapshots become extensible investigations; other task snapshots remain tool-less. Reports are delivered as typed artifacts with immutable server-resolved sources, never as executable HTML. The call is bound by the shared rate limit, a per-turn tool-step cap, and ai.timeout; a client disconnect cancels the in-flight provider call.

- **Procedure** `POST /tiyi.v1.AIService/StreamChat`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read`

**Request** — `tiyi.v1.StreamChatRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `history` | `history` | [`ChatTurn`](#chatturn) | repeated | history is the prior conversation (oldest first), capped server-side. |
| `message` | `message` | `string` | singular | message is the new operator question (free text). |
| `site_id` | `siteId` | `string` | singular | site_id is an optional UI scope hint (the site the operator is currently viewing); the model may use it to bias tool calls but can still ask about any tenant-visible site. |
| `context_id` | `contextId` | `string` | singular | A server-owned evidence reference. Each returned reference is immutable; chat can collect new evidence and return a new reference. An invalid/expired reference fails closed; it never degrades into an unscoped conversation. |
| `history_omitted` | `historyOmitted` | `uint32` | singular | client-side prose budget omissions |
| `history_clipped` | `historyClipped` | `uint32` | singular | — |
| `timezone` | `timezone` | `string` | singular | IANA timezone for natural calendar queries; defaults to UTC. |
| `client_ip_diagnostic` | `clientIpDiagnostic` | [`AIClientIPDiagnosticRequest`](#aiclientipdiagnosticrequest) | singular | Explicit UI handoff: collect server evidence before model text. |
| `request_id` | `requestId` | `string` | singular | Stable client preparation token: unix_milliseconds.UUID; valid for 24 hours. |
| `report_source_ids` | `reportSourceIds` | `string` | repeated | Selected report sources from context_id, never reconstructed from prose. |
| `refresh_ip_source_id` | `refreshIpSourceId` | `string` | singular | Requery the exact captured IP investigation. |
| `ip_investigation` | `ipInvestigation` | [`AIIPInvestigationQuery`](#aiipinvestigationquery) | singular | Explicit structured handoff; never injected into visible prose. |
| `page_context` | `pageContext` | `string` | singular | Raw, user-visible page state supplied by the enabled Tiya companion. It is kept separate from the operator's question so the UI can explain exactly what is shared. The server treats it as untrusted page data and does not redact it; callers must obtain the operator's consent before enabling it. |

**Response** — `tiyi.v1.StreamChatResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `tool_activity` | `toolActivity` | `string` | singular | — |
| `context` | `context` | [`AIConversationContext`](#aiconversationcontext) | singular | — |
| `report` | `report` | [`AIReportArtifact`](#aireportartifact) | singular | Complete immutable report; chat may continue refining it. |
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | Saved draft only; approval is a separate authenticated RPC. |
| `ip_disposition_state` | `ipDispositionState` | `string` | singular | Server-observed result for this turn: no_new_draft or draft_saved. Empty outside IP investigations. Model prose is never a persistence receipt. |
| `client_ip_diagnosis_json` | `clientIpDiagnosisJson` | `string` | singular | Bounded server-computed projections, independent of model prose. Schemas are the ClientIPDiagnosis/ClientIPSimulation contracts; no raw headers. |
| `client_ip_simulation_json` | `clientIpSimulationJson` | `string` | singular | — |
| `ip_investigation_json` | `ipInvestigationJson` | `string` | singular | Server-computed saved decision, evidence and preview capabilities. |

### AIService.ApplyAIProposal

Apply (require ai:apply). Validates the typed patch, then calls an AUDITED typed rule/tuning/IP mutation and writes a normal audit_event. IP disposition additionally checks all investigation permissions and policy:iplist:write, the exact displayed review ID and current configuration. It commits group membership/binding and acceptance atomically. Accepted IP retries republish without changing membership or expiry. Rejects free-form patches and unsupported proposal kinds.

- **Procedure** `POST /tiyi.v1.AIService/ApplyAIProposal`
- **Kind** unary
- **Auth** (`ai:apply`)

**Request** — `tiyi.v1.ApplyAIProposalRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `review_id` | `reviewId` | `string` | singular | Required for false-positive tuning: the exact passing report reviewed. For IP disposition: the review_id of the concrete plan shown in the UI. |

**Response** — `tiyi.v1.ApplyAIProposalResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | updated to ACCEPTED with applied_audit_id |
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | the underlying audited mutation result |

### AIService.ReviseAIProposal

Save operator adjustments as a new immutable draft and supersede the old draft atomically. No provider call or live configuration mutation. Source permissions are rechecked; tuning revisions require a new passing replay.

- **Procedure** `POST /tiyi.v1.AIService/ReviseAIProposal`
- **Kind** unary
- **Auth** `ai:read` and `ai:propose` and `policy:read`

**Request** — `tiyi.v1.ReviseAIProposalRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `request_id` | `requestId` | `string` | singular | Required stable preparation ID for retry recovery. |
| `custom_rule` | `customRule` | [`AICustomRuleRevision`](#aicustomrulerevision) | singular | Part of oneof `revision`. |
| `tuning` | `tuning` | [`AITuningRevision`](#aituningrevision) | singular | Part of oneof `revision`. |

**Response** — `tiyi.v1.ReviseAIProposalResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | — |

### AIService.RejectAIProposal

RejectAIProposal marks a draft proposal rejected (operator dismissal).

- **Procedure** `POST /tiyi.v1.AIService/RejectAIProposal`
- **Kind** unary
- **Auth** (`ai:propose`)

**Request** — `tiyi.v1.RejectAIProposalRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.RejectAIProposalResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | — |

### AIService.SetAIProviderSecret

SetAIProviderSecret stores the provider API key under the shared KEK/DEK envelope (requires system:write — the key is the secret half of the ai.* provider config set via SystemService.UpdateSystemSettings). The key is write-only: it is never returned by any RPC. An empty value is a no-op that preserves the stored key.

- **Procedure** `POST /tiyi.v1.AIService/SetAIProviderSecret`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.SetAIProviderSecretRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `api_key` | `apiKey` | `string` | singular | write-only; empty = no-op (preserve stored key) |

**Response** — `tiyi.v1.SetAIProviderSecretResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `key_set` | `keySet` | `bool` | singular | true when a non-empty key is now stored |

## Messages

### AIAnalysisContext

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `captured_at` | `capturedAt` | `string` | singular | RFC3339 UTC |
| `window_start` | `windowStart` | `string` | singular | — |
| `window_end` | `windowEnd` | `string` | singular | — |
| `sources` | `sources` | [`AIAnalysisSource`](#aianalysissource) | repeated | — |
| `comparison_scope` | `comparisonScope` | `string` | singular | top_level_json_object \| unavailable |
| `field_comparisons` | `fieldComparisons` | [`AIFieldComparison`](#aifieldcomparison) | repeated | — |
| `conversation` | `conversation` | [`AIConversationContext`](#aiconversationcontext) | singular | — |
| `change_review` | `changeReview` | [`AIChangeReviewSummary`](#aichangereviewsummary) | singular | — |

### AIAnalysisFeedback

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `issue` | `issue` | `string` | singular | incorrect \| insufficient_evidence; operator assertion |
| `comment` | `comment` | `string` | singular | — |
| `status` | `status` | `string` | singular | pending \| confirmed \| dismissed; human review only |
| `answer_excerpt` | `answerExcerpt` | `string` | singular | — |
| `answer_truncated` | `answerTruncated` | `bool` | singular | — |
| `evidence_json` | `evidenceJson` | `string` | singular | only returned by Get, not the queue |
| `answer_hash` | `answerHash` | `string` | singular | — |
| `model_id` | `modelId` | `string` | singular | configured model at admission, not provider identity proof |
| `prompt_version` | `promptVersion` | `string` | singular | — |
| `review_note` | `reviewNote` | `string` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |
| `updated_at` | `updatedAt` | `string` | singular | — |

### AIAnalysisSource

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | request_definition \| learned_fields \| rule \| findings \| counters \| health \| pipeline |
| `state` | `state` | `string` | singular | available \| empty \| unavailable \| truncated |
| `included` | `included` | `uint32` | singular | included items, not full traffic totals |

### AIChangeIPListConsumer

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `list_name` | `listName` | `string` | singular | — |
| `role` | `role` | `string` | singular | access_control \| rule_operand \| trusted_proxy_peer \| bot_trusted_client |
| `scope` | `scope` | `string` | singular | global \| policy \| site \| custom_rule |
| `policy_name` | `policyName` | `string` | singular | — |
| `site_name` | `siteName` | `string` | singular | — |
| `rule_name` | `ruleName` | `string` | singular | — |
| `disabled` | `disabled` | `bool` | singular | — |

### AIChangeReviewSummary

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `changed_resources` | `changedResources` | `uint32` | singular | — |
| `unchanged_resources` | `unchangedResources` | `uint32` | singular | — |
| `affected_sites` | `affectedSites` | `string` | repeated | — |
| `site_coverage_complete` | `siteCoverageComplete` | `bool` | singular | — |
| `validation_state` | `validationState` | `string` | singular | planned_only \| policy_compiled \| compile_failed |
| `ip_list_consumers` | `ipListConsumers` | [`AIChangeIPListConsumer`](#aichangeiplistconsumer) | repeated | — |
| `consumer_coverage_complete` | `consumerCoverageComplete` | `bool` | singular | — |
| `has_ip_list_changes` | `hasIpListChanges` | `bool` | singular | — |
| `coverage_limits` | `coverageLimits` | `string` | repeated | site_scan_limit \| affected_site_limit \| consumer_limit |

### AIClientIPDiagnosticRequest

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `analysis_id` | `analysisId` | `string` | singular | Optional existing local sample session; never starts sampling. |

### AIConversationContext

Metadata only. Redacted evidence is retained in bounded server memory for 30 minutes, never returned as a client-editable trusted evidence payload.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `captured_at` | `capturedAt` | `string` | singular | — |
| `expires_at` | `expiresAt` | `string` | singular | — |
| `state` | `state` | `string` | singular | snapshot \| configuration_changed \| source_changed \| unavailable |
| `scope` | `scope` | [`AIViewScope`](#aiviewscope) | singular | — |
| `evidence_ids` | `evidenceIds` | `string` | repeated | — |
| `omitted_tool_results` | `omittedToolResults` | `uint32` | singular | — |
| `history_omitted` | `historyOmitted` | `uint32` | singular | — |
| `history_clipped` | `historyClipped` | `uint32` | singular | — |
| `snapshot_only` | `snapshotOnly` | `bool` | singular | — |
| `required_permissions` | `requiredPermissions` | `string` | repeated | — |
| `source_id` | `sourceId` | `string` | singular | selected event, rule, asset or proposal; details only |
| `feedback_available` | `feedbackAvailable` | `bool` | singular | completed server-captured answer only |

### AICustomRuleRevision

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `spec_json` | `specJson` | `string` | singular | Strict visualrule.Spec, at most 32 KiB; log/block only. |
| `policy_ids` | `policyIds` | `string` | repeated | Nonempty subset of the original policies; site restrictions are retained. |

### AIFieldComparison

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `field` | `field` | `string` | singular | — |
| `state` | `state` | `string` | singular | type_match \| type_difference \| not_listed \| unknown |
| `declared_types` | `declaredTypes` | `string` | repeated | — |
| `observed_types` | `observedTypes` | `string` | repeated | — |

### AIIPInvestigationQuery

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `ips` | `ips` | `string` | repeated | — |
| `request_path` | `requestPath` | `string` | singular | — |
| `peer_ip` | `peerIp` | `string` | singular | — |

### AIProposal

AIProposal is a typed, schema-validated change proposal. Applying one calls an existing audited mutation RPC; this record never mutates live config itself.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `kind` | `kind` | [`AIProposalKind`](#aiproposalkind) | singular | — |
| `patch_json` | `patchJson` | `string` | singular | typed payload for the target mutation RPC |
| `evidence_ids` | `evidenceIds` | `string` | repeated | — |
| `confidence` | `confidence` | `double` | singular | — |
| `model_id` | `modelId` | `string` | singular | — |
| `prompt_version` | `promptVersion` | `string` | singular | — |
| `status` | `status` | [`AIProposalStatus`](#aiproposalstatus) | singular | — |
| `applied_audit_id` | `appliedAuditId` | `string` | singular | audit_event id once applied |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AIReportArtifact

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `title` | `title` | `string` | singular | — |
| `summary` | `summary` | `string` | singular | — |
| `sections` | `sections` | [`AIReportSection`](#aireportsection) | repeated | — |
| `sources` | `sources` | [`AIReportSource`](#aireportsource) | repeated | At most two independently scoped sources. |
| `captured_at` | `capturedAt` | `string` | singular | — |

### AIReportSection

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `heading` | `heading` | `string` | singular | — |
| `body` | `body` | `string` | singular | — |
| `visual` | `visual` | `string` | singular | none \| trend \| evidence |
| `source_id` | `sourceId` | `string` | singular | Must reference one of this artifact's sources. |

### AIReportSource

Model-authored presentation with server-resolved, immutable evidence sources. No executable HTML or model-provided chart numbers are accepted.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `report` | `report` | [`AISecurityReport`](#aisecurityreport) | singular | — |

### AISecurityReport

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `captured_at` | `capturedAt` | `string` | singular | — |
| `scope` | `scope` | [`AISecurityReportScope`](#aisecurityreportscope) | singular | — |
| `counter_state` | `counterState` | `string` | singular | available \| unavailable \| unsupported_filters \| incomplete |
| `counters` | `counters` | [`AISecurityReportCounters`](#aisecurityreportcounters) | singular | absent when not available |
| `trend` | `trend` | [`AISecurityReportPoint`](#aisecurityreportpoint) | repeated | at most 24 aggregated buckets |
| `examples_state` | `examplesState` | `string` | singular | available \| empty \| unavailable \| truncated |
| `examples` | `examples` | [`AISecurityReportExample`](#aisecurityreportexample) | repeated | newest 20 retained examples |
| `limitations` | `limitations` | `string` | repeated | stable codes; never model-generated |

### AISecurityReportCounters

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `passed` | `passed` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AISecurityReportExample

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `occurred_at` | `occurredAt` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `client_ip` | `clientIp` | `string` | singular | — |
| `method` | `method` | `string` | singular | — |
| `path` | `path` | `string` | singular | — |
| `attack_type` | `attackType` | `string` | singular | — |
| `severity` | `severity` | `string` | singular | — |
| `rule_ids` | `ruleIds` | `string` | repeated | — |
| `blocked` | `blocked` | `bool` | singular | — |
| `truncated` | `truncated` | `bool` | singular | — |

### AISecurityReportPoint

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `start` | `start` | `string` | singular | — |
| `end` | `end` | `string` | singular | — |
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### AISecurityReportScope

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `window_start` | `windowStart` | `string` | singular | — |
| `window_end` | `windowEnd` | `string` | singular | — |
| `timezone` | `timezone` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `site_name` | `siteName` | `string` | singular | — |
| `agent_id` | `agentId` | `string` | singular | — |
| `request_id` | `requestId` | `string` | singular | — |
| `client_ip_cidrs` | `clientIpCidrs` | `string` | repeated | — |
| `rule_ids` | `ruleIds` | `string` | repeated | — |
| `attack_types` | `attackTypes` | `string` | repeated | — |
| `target_identity` | `targetIdentity` | `string` | singular | — |
| `minimum_severity` | `minimumSeverity` | `string` | singular | — |
| `outcome` | `outcome` | `string` | singular | — |

### AITuningCaseResult

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `label` | `label` | `string` | singular | — |
| `baseline_blocked` | `baselineBlocked` | `bool` | singular | — |
| `candidate_blocked` | `candidateBlocked` | `bool` | singular | — |
| `baseline_rule_matched` | `baselineRuleMatched` | `bool` | singular | — |
| `candidate_rule_matched` | `candidateRuleMatched` | `bool` | singular | — |
| `result` | `result` | `string` | singular | pass \| fail \| unlabelled |

### AITuningDeployment

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `target` | `target` | `string` | singular | — |
| `status` | `status` | `string` | singular | — |
| `applied_at` | `appliedAt` | `string` | singular | — |

### AITuningReport

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `sample_hash` | `sampleHash` | `string` | singular | — |
| `checked_at` | `checkedAt` | `string` | singular | — |
| `policy_revision` | `policyRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `cases` | `cases` | [`AITuningCaseResult`](#aituningcaseresult) | repeated | — |
| `improved_benign` | `improvedBenign` | `uint32` | singular | — |
| `attack_regressions` | `attackRegressions` | `uint32` | singular | — |
| `failed` | `failed` | `uint32` | singular | — |
| `unlabelled` | `unlabelled` | `uint32` | singular | — |
| `can_apply` | `canApply` | `bool` | singular | — |
| `verification` | `verification` | `bool` | singular | — |
| `matches_tested_candidate` | `matchesTestedCandidate` | `bool` | singular | — |

### AITuningRevision

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `scope` | `scope` | `string` | singular | Original path prefix or a narrower child path. |
| `business_reason` | `businessReason` | `string` | singular | — |

### AITuningSample

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `label` | `label` | `string` | singular | benign \| attack \| boundary \| unknown |
| `request` | `request` | [`TestPolicyRequest`](policy.md#testpolicyrequest) | singular | — |

### AITuningTrafficWindow

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `start` | `start` | `string` | singular | — |
| `end` | `end` | `string` | singular | — |
| `available` | `available` | `bool` | singular | — |
| `matches` | `matches` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `ranking_complete` | `rankingComplete` | `bool` | singular | — |

### AIViewScope

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `window_start` | `windowStart` | `string` | singular | absolute RFC3339 |
| `window_end` | `windowEnd` | `string` | singular | — |
| `timezone` | `timezone` | `string` | singular | operator's display timezone |
| `filters_json` | `filtersJson` | `string` | singular | bounded, redacted loaded query; DATA, not instructions |
| `all_sites` | `allSites` | `bool` | singular | Server-confirmed all-site query, distinct from an unspecified chat scope. |

### ChatTurn

ChatTurn is one prior message in the conversation the client replays so the server keeps no durable transcript. Only operator (user) and assistant turns are sent; the system prompt and any tool/tool-result turns are reconstructed server-side and never accepted from the client (prompt-injection backstop).

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `role` | `role` | `string` | singular | "user" \| "assistant" |
| `content` | `content` | `string` | singular | — |

### LogEventRef

LogEventRef identifies one persisted log event to explain.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | [`LogKind`](#logkind) | singular | — |
| `id` | `id` | `string` | singular | — |

### LogTable

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | [`LogKind`](#logkind) | singular | — |
| `view` | `view` | `string` | singular | operator's view, e.g. "simple" \| "detail" |
| `columns` | `columns` | `string` | repeated | visible column headers, in display order |
| `rows` | `rows` | [`LogTableRow`](#logtablerow) | repeated | current page rows, as displayed |
| `scope` | `scope` | [`AIViewScope`](#aiviewscope) | singular | browser-supplied loaded-query scope, not server-verified rows |

### LogTableRow

LogTable is the operator's CURRENT table view, sent verbatim: only the columns visible in the UI (simple vs detail), the rows on the current page, exactly as displayed. "What you see is what is analyzed" — no server-side sampling or aggregation. The handler caps row/cell counts and redacts secret substrings before the model sees it, but otherwise passes the cells through.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cells` | `cells` | `string` | repeated | aligned 1:1 with LogTable.columns |

### SecurityEventQuery

SecurityEventQuery mirrors the typed, closed filter set of QuerySecurityEventsRequest (no free-form predicate, no SQL).

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `client_ip_cidrs` | `clientIpCidrs` | `string` | repeated | — |
| `rule_ids` | `ruleIds` | `string` | repeated | — |
| `lookback_seconds` | `lookbackSeconds` | `int64` | singular | relative time window the NL implied _JSON string (64-bit ints are quoted)._ |
| `outcome` | `outcome` | [`SecurityEventOutcome`](common.md#securityeventoutcome) | singular | — |
| `attack_types` | `attackTypes` | `string` | repeated | canonical types from the existing security-log classifier |

## Enums

### AIProposalKind

| Value | Number | Description |
|---|---|---|
| `AI_PROPOSAL_KIND_UNSPECIFIED` | 0 | — |
| `AI_PROPOSAL_KIND_CUSTOM_RULE` | 3 | -> CustomRuleService (Phase 3) |
| `AI_PROPOSAL_KIND_FALSE_POSITIVE_TUNING` | 4 | — |
| `AI_PROPOSAL_KIND_IP_DISPOSITION` | 5 | — |

### AIProposalStatus

| Value | Number | Description |
|---|---|---|
| `AI_PROPOSAL_STATUS_UNSPECIFIED` | 0 | — |
| `AI_PROPOSAL_STATUS_DRAFT` | 1 | — |
| `AI_PROPOSAL_STATUS_ACCEPTED` | 2 | — |
| `AI_PROPOSAL_STATUS_REJECTED` | 3 | — |
| `AI_PROPOSAL_STATUS_SUPERSEDED` | 4 | — |

### LogKind

LogKind selects which detail-log stream a log subject refers to.

| Value | Number | Description |
|---|---|---|
| `LOG_KIND_UNSPECIFIED` | 0 | — |
| `LOG_KIND_SECURITY` | 1 | — |
| `LOG_KIND_ACCESS` | 2 | — |
| `LOG_KIND_ERROR` | 3 | — |

<a id="aianalysiscontext"></a>

<a id="aianalysisfeedback"></a>

<a id="aianalysissource"></a>

<a id="aichangeiplistconsumer"></a>

<a id="aichangereviewsummary"></a>

<a id="aiclientipdiagnosticrequest"></a>

<a id="aiconversationcontext"></a>

<a id="aicustomrulerevision"></a>

<a id="aifieldcomparison"></a>

<a id="aiipinvestigationquery"></a>

<a id="aiproposal"></a>

<a id="aiproposalkind"></a>

<a id="aiproposalstatus"></a>

<a id="aireportartifact"></a>

<a id="aireportsection"></a>

<a id="aireportsource"></a>

<a id="aisecurityreport"></a>

<a id="aisecurityreportcounters"></a>

<a id="aisecurityreportexample"></a>

<a id="aisecurityreportpoint"></a>

<a id="aisecurityreportscope"></a>

<a id="aiserviceapplyaiproposal"></a>

<a id="aiservicecancelaischedulerun"></a>

<a id="aiservicecompareaialertrule"></a>

<a id="aiservicecontinueaischedulerun"></a>

<a id="aiservicecreateaischedule"></a>

<a id="aiservicedraftcustomrule"></a>

<a id="aiservicegetaianalysisfeedback"></a>

<a id="aiservicegetaiconversationcontext"></a>

<a id="aiservicegetaiproposal"></a>

<a id="aiservicegetaischedule"></a>

<a id="aiservicegetaischedulecapabilities"></a>

<a id="aiservicegetaischedulerun"></a>

<a id="aiservicegetaistatus"></a>

<a id="aiservicegetaituningreview"></a>

<a id="aiservicelistaianalysisfeedback"></a>

<a id="aiservicelistaiproposals"></a>

<a id="aiservicelistaischeduleruns"></a>

<a id="aiservicelistaischedules"></a>

<a id="aiservicemanageaischedule"></a>

<a id="aiserviceprepareaiipdisposition"></a>

<a id="aiserviceprepareaischedule"></a>

<a id="aiserviceprepareaisecurityreport"></a>

<a id="aiserviceprepareaituning"></a>

<a id="aiservicepreviewaischedulerun"></a>

<a id="aiservicerejectaiproposal"></a>

<a id="aiservicereplayaituning"></a>

<a id="aiserviceretryaischeduleeffect"></a>

<a id="aiserviceretryaischedulerun"></a>

<a id="aiservicereviewaianalysisfeedback"></a>

<a id="aiservicereviseaiproposal"></a>

<a id="aiservicerunaischedulenow"></a>

<a id="aiservicesetaiprovidersecret"></a>

<a id="aiservicesetaischedulerunread"></a>

<a id="aiservicesetaischedulestate"></a>

<a id="aiservicestreamaituninganalysis"></a>

<a id="aiservicestreamalertanalysis"></a>

<a id="aiservicestreamalerttuninganalysis"></a>

<a id="aiservicestreamanalysis"></a>

<a id="aiservicestreamapicontractanalysis"></a>

<a id="aiservicestreamchat"></a>

<a id="aiservicestreamconfigurationreview"></a>

<a id="aiservicestreamcrsupgradereview"></a>

<a id="aiservicestreamoperationsanalysis"></a>

<a id="aiservicestreamruleimpactanalysis"></a>

<a id="aiservicestreamsecurityreportanalysis"></a>

<a id="aiservicesubmitaianalysisfeedback"></a>

<a id="aiservicetestaiproposal"></a>

<a id="aiservicetranslatelogquery"></a>

<a id="aiserviceupdateaischedule"></a>

<a id="aituningcaseresult"></a>

<a id="aituningdeployment"></a>

<a id="aituningreport"></a>

<a id="aituningrevision"></a>

<a id="aituningsample"></a>

<a id="aituningtrafficwindow"></a>

<a id="aiviewscope"></a>

<a id="chatturn"></a>

<a id="logeventref"></a>

<a id="logkind"></a>

<a id="logtable"></a>

<a id="logtablerow"></a>

<a id="securityeventquery"></a>
