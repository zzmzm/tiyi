<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# operation_control.proto — operation_control

Schema: `tiyi.v1` · `operation_control.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### OperationControlService

| RPC | Kind | Required permission |
|---|---|---|
| [`GetRequestInspection`](#operationcontrolservicegetrequestinspection) | unary | `telemetry:read` and `site:read` and `policy:read` |
| [`PreviewBodyControl`](#operationcontrolservicepreviewbodycontrol) | unary | `api_inventory:write` and `site:write` |
| [`ApplyBodyControl`](#operationcontrolserviceapplybodycontrol) | unary | `api_inventory:write` and `site:write` |
| [`PreviewBodyChange`](#operationcontrolservicepreviewbodychange) | unary | `api_inventory:write` and `site:write` |
| [`ChangeBodyControl`](#operationcontrolservicechangebodycontrol) | unary | `api_inventory:write` and `site:write` |
| [`GetOperationControlState`](#operationcontrolservicegetoperationcontrolstate) | unary | `telemetry:read` and `site:read` |
| [`ListOperationControlHistory`](#operationcontrolservicelistoperationcontrolhistory) | unary | `telemetry:read` and `site:read` |
| [`ReplaceOperationControls`](#operationcontrolservicereplaceoperationcontrols) | unary | `api_inventory:write` and `site:write` and `policy:write` |
| [`RollbackOperationControls`](#operationcontrolservicerollbackoperationcontrols) | unary | `api_inventory:write` and `site:write` and `policy:write` |

## RPCs

### OperationControlService.GetRequestInspection

Saved site policy and API validation requirements from one read snapshot; not a node ACK.

- **Procedure** `POST /tiyi.v1.OperationControlService/GetRequestInspection`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read` and `policy:read`

**Request** — `tiyi.v1.GetRequestInspectionRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `api_asset_id` | `apiAssetId` | `string` | singular | — |

**Response** — `tiyi.v1.GetRequestInspectionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `policy_name` | `policyName` | `string` | singular | — |
| `policy_revision` | `policyRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `crs_core` | `crsCore` | [`CrsCoreSettings`](policy.md#crscoresettings) | singular | — |
| `waf_enabled` | `wafEnabled` | `bool` | singular | — |
| `engine_state` | `engineState` | [`EngineState`](common.md#enginestate) | singular | — |
| `allowed_families` | `allowedFamilies` | `string` | repeated | — |
| `mismatch_action` | `mismatchAction` | `string` | singular | — |
| `mismatch_body_limit` | `mismatchBodyLimit` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `operation_path` | `operationPath` | `string` | singular | — |
| `candidate_present` | `candidatePresent` | `bool` | singular | — |
| `control_snapshot_sha256` | `controlSnapshotSha256` | `string` | singular | — |
| `schema_body_limit` | `schemaBodyLimit` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `arg_limits` | `argLimits` | [`ArgLimits`](policy.md#arglimits) | singular | — |
| `effective_spec_json` | `effectiveSpecJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `candidate_spec_json` | `candidateSpecJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `effective_scope_json` | `effectiveScopeJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `candidate_scope_json` | `candidateScopeJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `default_upload_json` | `defaultUploadJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `effective_upload_json` | `effectiveUploadJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `schema_parameter_limit` | `schemaParameterLimit` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### OperationControlService.PreviewBodyControl

Preview authored settings without depending on traffic evidence.

- **Procedure** `POST /tiyi.v1.OperationControlService/PreviewBodyControl`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.PreviewBodyControlRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `draft` | `draft` | [`BodyControlDraft`](#bodycontroldraft) | singular | — |

**Response** — `tiyi.v1.PreviewBodyControlResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `approval` | `approval` | [`BodyControlApproval`](#bodycontrolapproval) | singular | — |
| `spec_json` | `specJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `snapshot_json` | `snapshotJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `resources_json` | `resourcesJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `execution_supported` | `executionSupported` | `bool` | singular | — |

### OperationControlService.ApplyBodyControl

Enforcing changes additionally require api_inventory:block and policy:write.

- **Procedure** `POST /tiyi.v1.OperationControlService/ApplyBodyControl`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.ApplyBodyControlRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `approval` | `approval` | [`BodyControlApproval`](#bodycontrolapproval) | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |

**Response** — `tiyi.v1.ApplyBodyControlResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent` | `intent` | [`OperationControlIntent`](#operationcontrolintent) | singular | — |
| `state` | `state` | `string` | singular | Pending or superseded, never a fabricated node application acknowledgement. |

### OperationControlService.PreviewBodyChange

- **Procedure** `POST /tiyi.v1.OperationControlService/PreviewBodyChange`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

<a id="previewbodychangerequest"></a>
**Request** — `tiyi.v1.PreviewBodyChangeRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `api_asset_id` | `apiAssetId` | `string` | singular | — |
| `action` | `action` | `string` | singular | discard_candidate, remove_effective or rollback_effective. Only one body slot changes; other controls and a replacement candidate are preserved. |
| `source_intent_id` | `sourceIntentId` | `string` | singular | Required only for historical rollback; removal restores current defaults. |
| `source_config_revision_id` | `sourceConfigRevisionId` | `string` | singular | — |
| `approval_intent_id` | `approvalIntentId` | `string` | singular | Original authored approval of the historical effective body. |

**Response** — `tiyi.v1.PreviewBodyChangeResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `approval` | `approval` | [`BodyChangeApproval`](#bodychangeapproval) | singular | — |
| `before_snapshot_json` | `beforeSnapshotJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `after_snapshot_json` | `afterSnapshotJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `selected_spec_json` | `selectedSpecJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `execution_supported` | `executionSupported` | `bool` | singular | — |
| `recovery_eligible` | `recoveryEligible` | `bool` | singular | — |
| `current_impact_unverified` | `currentImpactUnverified` | `bool` | singular | Recovery uses retained approval; no new complete impact window is claimed. |

### OperationControlService.ChangeBodyControl

- **Procedure** `POST /tiyi.v1.OperationControlService/ChangeBodyControl`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.ChangeBodyControlRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `approval` | `approval` | [`BodyChangeApproval`](#bodychangeapproval) | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |

**Response** — `tiyi.v1.ChangeBodyControlResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent` | `intent` | [`OperationControlIntent`](#operationcontrolintent) | singular | — |
| `state` | `state` | `string` | singular | — |

### OperationControlService.GetOperationControlState

- **Procedure** `POST /tiyi.v1.OperationControlService/GetOperationControlState`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetOperationControlStateRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `intent_id` | `intentId` | `string` | singular | Empty selects the desired intent. Non-empty reads retained site history. |
| `config_revision_id` | `configRevisionId` | `string` | singular | Optional exact historical attempt. Requires intent_id; it cannot borrow a newer attempt's receipts or a different intent's artifact. |

**Response** — `tiyi.v1.GetOperationControlStateResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `review` | `review` | [`OperationControlReview`](#operationcontrolreview) | singular | — |
| `intent` | `intent` | [`OperationControlIntent`](#operationcontrolintent) | singular | — |
| `controller_active` | `controllerActive` | [`OperationControlAttempt`](#operationcontrolattempt) | singular | — |
| `controller_active_manifest` | `controllerActiveManifest` | [`OperationControlManifestEntry`](#operationcontrolmanifestentry) | singular | — |
| `latest_intent_attempt` | `latestIntentAttempt` | [`OperationControlAttempt`](#operationcontrolattempt) | singular | — |
| `deployment_state` | `deploymentState` | `string` | singular | Exact durable receipt convergence, NOT live reachability or traffic health. |
| `required_targets` | `requiredTargets` | `uint32` | singular | — |
| `applied_targets` | `appliedTargets` | `uint32` | singular | — |
| `failed_targets` | `failedTargets` | `uint32` | singular | — |
| `targets_current` | `targetsCurrent` | `bool` | singular | — |
| `review_current` | `reviewCurrent` | `bool` | singular | — |

### OperationControlService.ListOperationControlHistory

- **Procedure** `POST /tiyi.v1.OperationControlService/ListOperationControlHistory`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.ListOperationControlHistoryRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `before_revision` | `beforeRevision` | `int64` | singular | Exclusive site control revision; zero selects the newest 50 intents. _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.ListOperationControlHistoryResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`OperationControlHistoryItem`](#operationcontrolhistoryitem) | repeated | — |
| `next_before_revision` | `nextBeforeRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### OperationControlService.ReplaceOperationControls

- **Procedure** `POST /tiyi.v1.OperationControlService/ReplaceOperationControls`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write` and `policy:write`

**Request** — `tiyi.v1.ReplaceOperationControlsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `review` | `review` | [`OperationControlReview`](#operationcontrolreview) | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `snapshot_json` | `snapshotJson` | `bytes` | singular | Complete reference-only snapshot, including explicit removals. Populated body/schema slots remain unsupported until their separate runtime gates. _base64-encoded JSON string._ |

**Response** — `tiyi.v1.ReplaceOperationControlsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent` | `intent` | [`OperationControlIntent`](#operationcontrolintent) | singular | — |
| `state` | `state` | `string` | singular | Mutation is durable. This is not an applied/converged acknowledgement. |

### OperationControlService.RollbackOperationControls

- **Procedure** `POST /tiyi.v1.OperationControlService/RollbackOperationControls`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write` and `policy:write`

**Request** — `tiyi.v1.RollbackOperationControlsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `review` | `review` | [`OperationControlReview`](#operationcontrolreview) | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `source_intent_id` | `sourceIntentId` | `string` | singular | — |
| `source_config_revision_id` | `sourceConfigRevisionId` | `string` | singular | — |

**Response** — `tiyi.v1.RollbackOperationControlsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent` | `intent` | [`OperationControlIntent`](#operationcontrolintent) | singular | — |
| `state` | `state` | `string` | singular | — |

## Messages

### BodyChangeApproval

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `selection` | `selection` | [`PreviewBodyChangeRequest`](#previewbodychangerequest) | singular | — |
| `review` | `review` | [`OperationControlReview`](#operationcontrolreview) | singular | — |
| `asset_revision` | `assetRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `previous_intent_id` | `previousIntentId` | `string` | singular | — |
| `before_snapshot_sha256` | `beforeSnapshotSha256` | `string` | singular | — |
| `after_snapshot_sha256` | `afterSnapshotSha256` | `string` | singular | — |
| `baseline_sha256` | `baselineSha256` | `string` | singular | — |
| `serving_targets_sha256` | `servingTargetsSha256` | `string` | singular | — |
| `policy_files_sha256` | `policyFilesSha256` | `string` | singular | — |
| `change_fingerprint` | `changeFingerprint` | `string` | singular | Binds the reviewed transition; this is not a detection-evidence claim. |
| `before_raw_reservation_bytes` | `beforeRawReservationBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `after_raw_reservation_bytes` | `afterRawReservationBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `baseline_waf_enabled` | `baselineWafEnabled` | `bool` | singular | — |
| `baseline_request_body_limit` | `baselineRequestBodyLimit` | `int64` | singular | WAF policy threshold only; removal restores this baseline without a native per-operation hard cap. WAF mode/rules may process only part of the body. _JSON string (64-bit ints are quoted)._ |
| `recovery_approval_sha256` | `recoveryApprovalSha256` | `string` | singular | — |
| `recovery_artifact_sha256` | `recoveryArtifactSha256` | `string` | singular | — |
| `recovery_artifact_generation` | `recoveryArtifactGeneration` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `recovery_applied_targets_sha256` | `recoveryAppliedTargetsSha256` | `string` | singular | — |
| `recovery_applied_targets` | `recoveryAppliedTargets` | [`OperationControlTarget`](#operationcontroltarget) | repeated | Historical applied targets only, never the new recovery's convergence. |

### BodyControlApproval

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `draft` | `draft` | [`BodyControlDraft`](#bodycontroldraft) | singular | — |
| `review` | `review` | [`OperationControlReview`](#operationcontrolreview) | singular | — |
| `asset_revision` | `assetRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `spec_sha256` | `specSha256` | `string` | singular | — |
| `before_snapshot_sha256` | `beforeSnapshotSha256` | `string` | singular | — |
| `after_snapshot_sha256` | `afterSnapshotSha256` | `string` | singular | — |
| `policy_files_sha256` | `policyFilesSha256` | `string` | singular | — |
| `preview_runtime_sha256` | `previewRuntimeSha256` | `string` | singular | — |
| `raw_reservation_bytes` | `rawReservationBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### BodyControlDraft

Authored input; scope, executable support and resources are verified server-side.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `api_asset_id` | `apiAssetId` | `string` | singular | — |
| `spec_revision` | `specRevision` | `string` | singular | Empty only on initial preview; apply returns this exact reviewed UUID. |
| `profile` | `profile` | `string` | singular | — |
| `mismatch_action` | `mismatchAction` | `string` | singular | — |
| `allowed_families` | `allowedFamilies` | `string` | repeated | — |
| `scope_json` | `scopeJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `control_mode` | `controlMode` | `string` | singular | observe leaves effective settings unchanged; enforce applies immediately. |
| `schema_mode` | `schemaMode` | `string` | singular | Empty preserves this operation's current Schema mode. |
| `upload_requirements_json` | `uploadRequirementsJson` | `bytes` | singular | File requirements only; upload capacity is inherited from the site policy. _base64-encoded JSON string._ |
| `body_action` | `bodyAction` | `string` | singular | set (default), keep, or inherit. Keep/inherit do not require body input. |

### OperationControlAttempt

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `config_revision_id` | `configRevisionId` | `string` | singular | — |
| `generation` | `generation` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `artifact_sha256` | `artifactSha256` | `string` | singular | — |
| `status` | `status` | `string` | singular | — |
| `targets` | `targets` | [`OperationControlTarget`](#operationcontroltarget) | repeated | — |

### OperationControlHistoryItem

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent_id` | `intentId` | `string` | singular | — |
| `control_revision` | `controlRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `snapshot_sha256` | `snapshotSha256` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |
| `superseded_by_intent_id` | `supersededByIntentId` | `string` | singular | — |
| `domain` | `domain` | `string` | singular | Immutable review ownership, not runtime convergence. |
| `contract_id` | `contractId` | `string` | singular | — |
| `latest_config_revision_id` | `latestConfigRevisionId` | `string` | singular | — |
| `latest_status` | `latestStatus` | `string` | singular | — |
| `activated_config_revision_id` | `activatedConfigRevisionId` | `string` | singular | Latest historically activated attempt. Rollback preview independently verifies its signature, manifest, approval and exact application records. |
| `activated_generation` | `activatedGeneration` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `activated_artifact_sha256` | `activatedArtifactSha256` | `string` | singular | — |
| `activated_at` | `activatedAt` | `string` | singular | — |

### OperationControlIntent

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `control_revision` | `controlRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `snapshot_sha256` | `snapshotSha256` | `string` | singular | — |
| `snapshot_json` | `snapshotJson` | `bytes` | singular | Canonical tiyi.site_controls.v2 reference-only snapshot, not executable IR. _base64-encoded JSON string._ |
| `superseded_by_intent_id` | `supersededByIntentId` | `string` | singular | — |
| `apply_claimed` | `applyClaimed` | `bool` | singular | — |
| `rollback_source_intent_id` | `rollbackSourceIntentId` | `string` | singular | — |
| `rollback_source_config_revision_id` | `rollbackSourceConfigRevisionId` | `string` | singular | — |
| `reviewed` | `reviewed` | [`OperationControlReview`](#operationcontrolreview) | singular | — |
| `required_targets` | `requiredTargets` | [`OperationControlRequiredTarget`](#operationcontrolrequiredtarget) | repeated | — |
| `dependencies_json` | `dependenciesJson` | `bytes` | singular | Value-free per-resource fingerprint vector, retained as reviewed. _base64-encoded JSON string._ |
| `body_review_json` | `bodyReviewJson` | `bytes` | singular | Immutable, value-free domain review; absent for reference-only intents. _base64-encoded JSON string._ |

### OperationControlManifestEntry

Shared identity contract, not a Schema IR. A manifest entry associates an immutable site snapshot with an exact compiled artifact.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `control_revision` | `controlRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `control_snapshot_sha256` | `controlSnapshotSha256` | `string` | singular | — |
| `intent_id` | `intentId` | `string` | singular | — |

### OperationControlRequiredTarget

Immutable reviewed target identity; unrelated tenant and bootstrap nodes do not enter the site's required ACK denominator.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `capability_revision` | `capabilityRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `capabilities_sha256` | `capabilitiesSha256` | `string` | singular | — |

### OperationControlReview

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `control_revision` | `controlRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `base_generation` | `baseGeneration` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `input_revision` | `inputRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `topology_revision` | `topologyRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `targets_sha256` | `targetsSha256` | `string` | singular | — |
| `target_local` | `targetLocal` | `bool` | singular | Server-derived local runtime membership, not a client-selected target set. |
| `dependencies_sha256` | `dependenciesSha256` | `string` | singular | — |

### OperationControlTarget

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `node_id` | `nodeId` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `purpose` | `purpose` | `string` | singular | — |
| `deployment_id` | `deploymentId` | `string` | singular | — |
| `bundle_id` | `bundleId` | `string` | singular | — |
| `target_revision` | `targetRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `status` | `status` | `string` | singular | — |
| `superseded_by_revision_id` | `supersededByRevisionId` | `string` | singular | — |
| `applied_at` | `appliedAt` | `string` | singular | — |
