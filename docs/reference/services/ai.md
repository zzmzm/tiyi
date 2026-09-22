<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# ai.proto — AI copilot and advisory proposals

Schema: `tiyi.v1` · `ai.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### AIService

Read/advisory (require ai:read).

| RPC | Kind | Required permission |
|---|---|---|
| [`ListAIProposals`](#aiservicelistaiproposals) | unary | (`ai:read`) |
| [`GetAIProposal`](#aiservicegetaiproposal) | unary | (`ai:read`) |
| [`GetAIStatus`](#aiservicegetaistatus) | unary | (`ai:read`) |
| [`DraftCustomRule`](#aiservicedraftcustomrule) | unary | (`ai:propose`) |
| [`TranslateLogQuery`](#aiservicetranslatelogquery) | unary | (`ai:read`) |
| [`StreamAnalysis`](#aiservicestreamanalysis) | server stream | `ai:read` and `log:read` |
| [`StreamChat`](#aiservicestreamchat) | server stream | `ai:read` and `log:read` |
| [`ApplyAIProposal`](#aiserviceapplyaiproposal) | unary | (`ai:apply`) |
| [`RejectAIProposal`](#aiservicerejectaiproposal) | unary | (`ai:propose`) |
| [`SetAIProviderSecret`](#aiservicesetaiprovidersecret) | unary | (`system:write`) |

## RPCs

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

GetAIStatus reports whether the layer is enabled/configured and the worker counters — drives the UI "AI Advisor" availability banner.

- **Procedure** `POST /tiyi.v1.AIService/GetAIStatus`
- **Kind** unary
- **Auth** (`ai:read`)

**Request** — `tiyi.v1.GetAIStatusRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetAIStatusResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enabled` | `enabled` | `bool` | singular | ai.enabled |
| `configured` | `configured` | `bool` | singular | provider + model + key all set |
| `provider` | `provider` | `string` | singular | openai_compatible \| azure_openai \| disabled |
| `model_summary` | `modelSummary` | `string` | singular | — |

### AIService.DraftCustomRule

Proposal generation (require ai:propose). Returns drafts; mutates nothing. The generated proposal is stored as a draft ai_proposal the operator later applies through ApplyAIProposal.

- **Procedure** `POST /tiyi.v1.AIService/DraftCustomRule`
- **Kind** unary
- **Auth** (`ai:propose`)

**Request** — `tiyi.v1.DraftCustomRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent` | `intent` | `string` | singular | intent is the operator's natural-language description / CVE / threat intel ("block requests with X-Debug header to /admin"). |
| `policy_id` | `policyId` | `string` | singular | — |

**Response** — `tiyi.v1.DraftCustomRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | proposal is a stored draft of kind CUSTOM_RULE (patch carries the visualrule.Spec JSON). Apply it via ApplyAIProposal. |
| `seclang_preview` | `seclangPreview` | `string` | singular | seclang_preview is the compiled SecLang for the drafted rule. Every generated rule starts LOG-ONLY / canary (action=log), so the preview never blocks until the operator promotes it. |
| `warnings` | `warnings` | `string` | repeated | — |

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

### AIService.StreamChat

StreamChat is the conversational Copilot ability: a free-talk, multi-turn assistant that answers open-ended operator questions by driving the EXISTING log query/filter/summary capabilities itself (docs/design/ai-copilot-analysis.md § Chat agent). It adds NO new log query surface — the model calls read-only tools that are thin in-process wrappers over the same tenant-scoped queries the Log pages already use (security/access summaries + filtered event lookups + site resolution), then summarizes the results to answer questions like "top 10 attackers in the last hour", "is 1.1.1.5 evil?", or "was www.test.com attacked today, from which IP and what attack type?". The server is stateless: the client replays prior turns in `history` and appends the new `message`. Advisory only — every tool is read-only and tenant-scoped; the model never mutates state and never blocks traffic. Requires ai:read (middleware) AND log:read (enforced in the handler, since every tool reads logs — same dual-RBAC backstop as StreamAnalysis). The call is bound by the shared rate limit, a per-turn tool-step cap, and ai.timeout; a client disconnect cancels the in-flight provider call.

- **Procedure** `POST /tiyi.v1.AIService/StreamChat`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** `ai:read` and `log:read`

**Request** — `tiyi.v1.StreamChatRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `history` | `history` | [`ChatTurn`](#chatturn) | repeated | history is the prior conversation (oldest first), capped server-side. |
| `message` | `message` | `string` | singular | message is the new operator question (free text). |
| `site_id` | `siteId` | `string` | singular | site_id is an optional UI scope hint (the site the operator is currently viewing); the model may use it to bias tool calls but can still ask about any tenant-visible site. |

**Response** — `tiyi.v1.StreamChatResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `delta` | `delta` | `string` | singular | — |
| `done` | `done` | `bool` | singular | — |
| `token_cost` | `tokenCost` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `tool_activity` | `toolActivity` | `string` | singular | — |

### AIService.ApplyAIProposal

Apply (require ai:apply). Validates the typed patch, then calls an AUDITED mutation service (UpsertRuleOverride today) and writes a normal audit_event. Rejects any free-form patch and any unsupported proposal kind.

- **Procedure** `POST /tiyi.v1.AIService/ApplyAIProposal`
- **Kind** unary
- **Auth** (`ai:apply`)

**Request** — `tiyi.v1.ApplyAIProposalRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.ApplyAIProposalResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `proposal` | `proposal` | [`AIProposal`](#aiproposal) | singular | updated to ACCEPTED with applied_audit_id |
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | the underlying audited mutation result |

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

### ChatTurn

ChatTurn is one prior message in the conversation the client replays so the server stays stateless. Only operator (user) and assistant turns are sent; the system prompt and any tool/tool-result turns are reconstructed server-side and never accepted from the client (prompt-injection backstop).

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

## Enums

### AIProposalKind

| Value | Number | Description |
|---|---|---|
| `AI_PROPOSAL_KIND_UNSPECIFIED` | 0 | — |
| `AI_PROPOSAL_KIND_CUSTOM_RULE` | 3 | -> CustomRuleService (Phase 3) |

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
