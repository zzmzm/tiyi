<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# policy.proto — WAF policies, rule overrides, custom rules, IP lists, rate limits, CRS

Schema: `tiyi.v1` · `policy.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### PolicyService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListPolicies`](#policyservicelistpolicies) | unary | (`policy:read`) |
| [`GetPolicy`](#policyservicegetpolicy) | unary | (`policy:read`) |
| [`CreatePolicy`](#policyservicecreatepolicy) | unary | (`policy:write`) |
| [`CreatePolicyFromTemplate`](#policyservicecreatepolicyfromtemplate) | unary | (`policy:write`) |
| [`UpdatePolicy`](#policyserviceupdatepolicy) | unary | (`policy:write`) |
| [`UpdatePolicyLayer`](#policyserviceupdatepolicylayer) | unary | (`policy:write`) |
| [`DeletePolicy`](#policyservicedeletepolicy) | unary | (`policy:delete`) |
| [`SetEngineState`](#policyservicesetenginestate) | unary | (`policy:write`) |
| [`SetActiveCrsRuleset`](#policyservicesetactivecrsruleset) | unary | (`policy:crs:write`) |
| [`PreviewSecLang`](#policyservicepreviewseclang) | unary | (`policy:preview`) |
| [`PreviewCrsImpact`](#policyservicepreviewcrsimpact) | unary | (`policy:preview`) |
| [`TestPolicy`](#policyservicetestpolicy) | unary | (`policy:test`) |
| [`ListPolicyTemplates`](#policyservicelistpolicytemplates) | unary | (`policy:read`) |
| [`ListPolicyVersions`](#policyservicelistpolicyversions) | unary | (`policy:read`) |
| [`GetPolicyVersion`](#policyservicegetpolicyversion) | unary | (`policy:read`) |
| [`RollbackPolicy`](#policyservicerollbackpolicy) | unary | (`policy:write`) |
| [`DiffPolicyVersions`](#policyservicediffpolicyversions) | unary | (`policy:read`) |

## RPCs

### PolicyService.ListPolicies

- **Procedure** `POST /tiyi.v1.PolicyService/ListPolicies`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListPoliciesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |
| `templates_only` | `templatesOnly` | `bool` | singular | — |

**Response** — `tiyi.v1.ListPoliciesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Policy`](#policy) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### PolicyService.GetPolicy

- **Procedure** `POST /tiyi.v1.PolicyService/GetPolicy`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetPolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetPolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.CreatePolicy

- **Procedure** `POST /tiyi.v1.PolicyService/CreatePolicy`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.CreatePolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

**Response** — `tiyi.v1.CreatePolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.CreatePolicyFromTemplate

- **Procedure** `POST /tiyi.v1.PolicyService/CreatePolicyFromTemplate`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.CreatePolicyFromTemplateRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `template_id` | `templateId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |

**Response** — `tiyi.v1.CreatePolicyFromTemplateResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.UpdatePolicy

- **Procedure** `POST /tiyi.v1.PolicyService/UpdatePolicy`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.UpdatePolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | Inspection saves accept crs_core or individual crs_core fields, http_policy, and arg_limits. The selected fields are compiled and persisted atomically as one version using a positive expected revision. An absent optional field named in the mask resets to inheritance. Metadata/plugins cannot be mixed into an inspection save; unselected fields are preserved. _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdatePolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.UpdatePolicyLayer

- **Procedure** `POST /tiyi.v1.PolicyService/UpdatePolicyLayer`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.UpdatePolicyLayerRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `layer` | `layer` | [`PolicyLayerKind`](#policylayerkind) | singular | — |
| `config` | `config` | `google.protobuf.Struct` | singular | _free-form JSON object._ |

**Response** — `tiyi.v1.UpdatePolicyLayerResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.DeletePolicy

- **Procedure** `POST /tiyi.v1.PolicyService/DeletePolicy`
- **Kind** unary
- **Auth** (`policy:delete`)

**Request** — `tiyi.v1.DeletePolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeletePolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### PolicyService.SetEngineState

- **Procedure** `POST /tiyi.v1.PolicyService/SetEngineState`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.SetEngineStateRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `engine_state` | `engineState` | [`EngineState`](common.md#enginestate) | singular | — |

**Response** — `tiyi.v1.SetEngineStateResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.SetActiveCrsRuleset

- **Procedure** `POST /tiyi.v1.PolicyService/SetActiveCrsRuleset`
- **Kind** unary
- **Auth** (`policy:crs:write`)

**Request** — `tiyi.v1.SetActiveCrsRulesetRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `crs_ruleset_id` | `crsRulesetId` | `string` | singular | — |

**Response** — `tiyi.v1.SetActiveCrsRulesetResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.PreviewSecLang

- **Procedure** `POST /tiyi.v1.PolicyService/PreviewSecLang`
- **Kind** unary
- **Auth** (`policy:preview`)

**Request** — `tiyi.v1.PreviewSecLangRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `candidate` | `candidate` | [`Policy`](#policy) | singular | — |
| `site_id` | `siteId` | `string` | singular | Optional site id: when set, the compiler layers the site's site_policy_override (if any) on top of the policy before rendering the SecLang bundle. Used by the "preview effective policy for this site" UI. See WAF_POLICY_DESIGN.md § 3.2. |

**Response** — `tiyi.v1.PreviewSecLangResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `seclang` | `seclang` | `string` | singular | — |
| `warnings` | `warnings` | `string` | repeated | — |

### PolicyService.PreviewCrsImpact

- **Procedure** `POST /tiyi.v1.PolicyService/PreviewCrsImpact`
- **Kind** unary
- **Auth** (`policy:preview`)

**Request** — `tiyi.v1.PreviewCrsImpactRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `crs_ruleset_id` | `crsRulesetId` | `string` | singular | — |

**Response** — `tiyi.v1.PreviewCrsImpactResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enabled_rule_count` | `enabledRuleCount` | `int32` | singular | — |
| `disabled_rule_count` | `disabledRuleCount` | `int32` | singular | — |
| `warnings` | `warnings` | `string` | repeated | — |
| `added_rule_ids` | `addedRuleIds` | `int32` | repeated | Rule ids present in the candidate ruleset but not in the currently bound one. Sorted ascending. |
| `removed_rule_ids` | `removedRuleIds` | `int32` | repeated | Rule ids present in the currently bound ruleset but not in the candidate. Sorted ascending. |
| `orphaned_overrides` | `orphanedOverrides` | [`PreviewCrsImpactOrphanedOverride`](#previewcrsimpactorphanedoverride) | repeated | Overrides whose CRS rule id no longer exists in the candidate ruleset. Sorted by crs_rule_id. |
| `changed_rules` | `changedRules` | [`PreviewCrsChangedRule`](#previewcrschangedrule) | repeated | — |

### PolicyService.TestPolicy

- **Procedure** `POST /tiyi.v1.PolicyService/TestPolicy`
- **Kind** unary
- **Auth** (`policy:test`)

**Request** — `tiyi.v1.TestPolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `method` | `method` | `string` | singular | — |
| `url` | `url` | `string` | singular | — |
| `headers` | `headers` | map&lt;`string`, `string`&gt; | map | — |
| `body` | `body` | `bytes` | singular | _base64-encoded JSON string._ |
| `protocol` | `protocol` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | Optional site overlay. Must reference this policy and have WAF enabled. |
| `client_ip` | `clientIp` | `string` | singular | Explicit simulation inputs; no trusted-proxy resolution is performed. |
| `peer_ip` | `peerIp` | `string` | singular | — |

**Response** — `tiyi.v1.TestPolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `blocked` | `blocked` | `bool` | singular | — |
| `status` | `status` | `int32` | singular | — |
| `matched_rule_ids` | `matchedRuleIds` | `string` | repeated | — |
| `transaction` | `transaction` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `matched_rules` | `matchedRules` | [`TestPolicyMatchedRule`](#testpolicymatchedrule) | repeated | Detailed per-rule breakdown including score contributions. Sorted by phase, then rule_id ascending for stable output. |
| `total_inbound_score` | `totalInboundScore` | `int32` | singular | Actual CRS blocking_inbound_anomaly_score from this transaction. Zero if evaluation did not reach the CRS blocking-score aggregation. |

### PolicyService.ListPolicyTemplates

- **Procedure** `POST /tiyi.v1.PolicyService/ListPolicyTemplates`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListPolicyTemplatesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListPolicyTemplatesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Policy`](#policy) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### PolicyService.ListPolicyVersions

- **Procedure** `POST /tiyi.v1.PolicyService/ListPolicyVersions`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListPolicyVersionsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListPolicyVersionsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`PolicyVersion`](#policyversion) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### PolicyService.GetPolicyVersion

- **Procedure** `POST /tiyi.v1.PolicyService/GetPolicyVersion`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetPolicyVersionRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetPolicyVersionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `version` | `version` | [`PolicyVersion`](#policyversion) | singular | — |

### PolicyService.RollbackPolicy

- **Procedure** `POST /tiyi.v1.PolicyService/RollbackPolicy`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.RollbackPolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `version_id` | `versionId` | `string` | singular | — |

**Response** — `tiyi.v1.RollbackPolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy` | `policy` | [`Policy`](#policy) | singular | — |

### PolicyService.DiffPolicyVersions

- **Procedure** `POST /tiyi.v1.PolicyService/DiffPolicyVersions`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.DiffPolicyVersionsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `left_version_id` | `leftVersionId` | `string` | singular | — |
| `right_version_id` | `rightVersionId` | `string` | singular | — |

**Response** — `tiyi.v1.DiffPolicyVersionsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `diff` | `diff` | [`JsonPatch`](common.md#jsonpatch) | singular | — |

## Messages

### ArgLimits

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `max_num_args` | `maxNumArgs` | `int32` | optional (explicit) | — |
| `arg_name_length` | `argNameLength` | `int32` | optional (explicit) | — |
| `arg_length` | `argLength` | `int32` | optional (explicit) | — |
| `total_arg_length` | `totalArgLength` | `int32` | optional (explicit) | — |
| `max_file_size` | `maxFileSize` | `int64` | optional (explicit) | _JSON string (64-bit ints are quoted)._ |
| `combined_file_sizes` | `combinedFileSizes` | `int64` | optional (explicit) | _JSON string (64-bit ints are quoted)._ |
| `argument_limit_action` | `argumentLimitAction` | [`ArgumentLimitAction`](#argumentlimitaction) | singular | Ordinary argument count/name/value/total excess: BLOCK returns 413; OBSERVE logs without blocking or contributing anomaly score. Unspecified selects BLOCK; the built-in Light template selects OBSERVE. Native multipart field and file limits always reject independently of this action. |

### BodyProcessorOverride

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `content_type_prefix` | `contentTypePrefix` | `string` | singular | Historical field name: the value is an exact media type. Matching accepts optional parameters after ';' but never adjacent subtype text. |
| `processor` | `processor` | [`BodyProcessor`](#bodyprocessor) | singular | — |

### CrsCoreSettings

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `blocking_paranoia_level` | `blockingParanoiaLevel` | `int32` | singular | — |
| `detection_paranoia_level` | `detectionParanoiaLevel` | `int32` | singular | — |
| `critical_anomaly_score` | `criticalAnomalyScore` | `int32` | singular | — |
| `error_anomaly_score` | `errorAnomalyScore` | `int32` | singular | — |
| `warning_anomaly_score` | `warningAnomalyScore` | `int32` | singular | — |
| `notice_anomaly_score` | `noticeAnomalyScore` | `int32` | singular | — |
| `inbound_anomaly_score_threshold` | `inboundAnomalyScoreThreshold` | `int32` | singular | — |
| `outbound_anomaly_score_threshold` | `outboundAnomalyScoreThreshold` | `int32` | singular | — |
| `reporting_level` | `reportingLevel` | `int32` | optional (explicit) | Presence is required because 0 is a valid value ("reporting disabled"), while an omitted field inherits the CRS default of 4. |
| `early_blocking` | `earlyBlocking` | `bool` | singular | — |
| `enforce_bodyproc_urlencoded` | `enforceBodyprocUrlencoded` | `bool` | singular | — |
| `crs_validate_utf8_encoding` | `crsValidateUtf8Encoding` | `bool` | singular | — |
| `crs_skip_response_analysis` | `crsSkipResponseAnalysis` | `bool` | optional (explicit) | — |
| `enable_default_collections` | `enableDefaultCollections` | `bool` | optional (explicit) | Tri-state: unset = inherit the CRS default (off), explicit true/false = force tx.enable_default_collections=1\|0. Presence tracking (proto3 optional) is required so an explicit "off" survives protojson's EmitUnpopulated=false round-trip. |
| `sampling_percentage` | `samplingPercentage` | `int32` | optional (explicit) | Presence is required because 0% is a valid emergency bypass value, while an omitted field inherits the CRS default of 100%. |
| `response_body_access` | `responseBodyAccess` | `bool` | optional (explicit) | — |
| `response_body_limit` | `responseBodyLimit` | `int64` | optional (explicit) | _JSON string (64-bit ints are quoted)._ |
| `response_body_mime_types` | `responseBodyMimeTypes` | `string` | repeated | — |
| `request_body_limit` | `requestBodyLimit` | `int64` | optional (explicit) | Ordinary body inspection budget: 1..4194304 bytes (default 64 KiB). Multipart uploads use independent limits. request_body_limit_action controls excess. _JSON string (64-bit ints are quoted)._ |
| `request_body_limit_enabled` | `requestBodyLimitEnabled` | `bool` | optional (explicit) | — |
| `crs_xml_attribute_inspection` | `crsXmlAttributeInspection` | `bool` | optional (explicit) | Enables CRS XML attribute inspection and avoids CRS 901181's expensive per-request dynamic target removals when enabled. |
| `request_body_limit_action` | `requestBodyLimitAction` | [`RequestBodyLimitAction`](#requestbodylimitaction) | singular | BLOCK rejects excess with 413. OBSERVE records excess, inspects at most the configured prefix and forwards the full body unless another rule blocks. Unspecified selects BLOCK; the built-in Light template selects OBSERVE. |

### HttpPolicy

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `allowed_methods` | `allowedMethods` | `string` | repeated | — |
| `allowed_request_content_types` | `allowedRequestContentTypes` | `string` | repeated | — |
| `allowed_request_content_charsets` | `allowedRequestContentCharsets` | `string` | repeated | — |
| `allowed_http_versions` | `allowedHttpVersions` | `string` | repeated | Canonical values: HTTP/1.0, HTTP/1.1, HTTP/2, HTTP/3. |
| `restricted_extensions` | `restrictedExtensions` | `string` | repeated | — |
| `restricted_headers_basic` | `restrictedHeadersBasic` | `string` | repeated | — |
| `restricted_headers_extended` | `restrictedHeadersExtended` | `string` | repeated | — |
| `body_processor_overrides` | `bodyProcessorOverrides` | [`BodyProcessorOverride`](#bodyprocessoroverride) | repeated | — |
| `allow_method_override_parameter` | `allowMethodOverrideParameter` | `bool` | singular | — |
| `disallowed_content_type_action` | `disallowedContentTypeAction` | [`HttpPolicyViolationAction`](#httppolicyviolationaction) | singular | Controls CRS 920420 when a syntactically valid Content-Type is outside allowed_request_content_types. Unspecified preserves the blocking CRS default so existing policies do not change during upgrades. |
| `request_body_parse_failure_action` | `requestBodyParseFailureAction` | [`HttpPolicyViolationAction`](#httppolicyviolationaction) | singular | Controls the generated REQBODY_ERROR guard after a selected JSON/XML parser rejects the body. Multipart strict validation and resource limits remain hard failures regardless of this compatibility setting. |

### Policy

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `crs_ruleset_id` | `crsRulesetId` | `string` | singular | — |
| `engine_state` | `engineState` | [`EngineState`](common.md#enginestate) | singular | — |
| `blocking_mode` | `blockingMode` | [`BlockingMode`](common.md#blockingmode) | singular | — |
| `is_template` | `isTemplate` | `bool` | singular | — |
| `is_default` | `isDefault` | `bool` | singular | — |
| `builtin` | `builtin` | `bool` | singular | — |
| `status` | `status` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bundle_sha256` | `bundleSha256` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `crs_core` | `crsCore` | [`CrsCoreSettings`](#crscoresettings) | singular | — |
| `http_policy` | `httpPolicy` | [`HttpPolicy`](#httppolicy) | singular | — |
| `arg_limits` | `argLimits` | [`ArgLimits`](#arglimits) | singular | — |
| `plugins` | `plugins` | [`PolicyPlugin`](#policyplugin) | repeated | — |

### PolicyPlugin

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `plugin_id` | `pluginId` | `string` | singular | — |
| `enabled` | `enabled` | `bool` | singular | — |
| `config` | `config` | `google.protobuf.Struct` | singular | _free-form JSON object._ |

### PolicyVersion

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bundle_sha256` | `bundleSha256` | `string` | singular | — |
| `snapshot` | `snapshot` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `created_by` | `createdBy` | `string` | singular | — |

### PreviewCrsChangedRule

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule_id` | `ruleId` | `int32` | singular | — |
| `changes` | `changes` | [`PreviewCrsRuleChange`](#previewcrsrulechange) | repeated | — |

### PreviewCrsImpactOrphanedOverride

PreviewCrsImpactOrphanedOverride describes a policy override that references a CRS rule id which does not exist in the candidate ruleset. These are the entries the operator must address (remove, remap, or convert to a custom rule) before promoting the ruleset.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override_id` | `overrideId` | `string` | singular | The override's own id in policy storage (rule_override.id). |
| `crs_rule_id` | `crsRuleId` | `int32` | singular | The CRS rule id the override targets. |
| `summary` | `summary` | `string` | singular | Short human-readable description, e.g. "disable rule 942100". |

### PreviewCrsRuleChange

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `field` | `field` | `string` | singular | phase \| targets \| condition \| transforms \| score \| action \| severity \| paranoia \| order \| source |
| `before` | `before` | `string` | singular | — |
| `after` | `after` | `string` | singular | — |

### TestPolicyMatchedRule

TestPolicyMatchedRule breaks down one rule that matched during a policy test. Closes WAF_POLICY_DESIGN § 7.14 / deep-review item #12 — operators can now see WHICH rules contributed to a block, their score contribution, and their tags (so they know whether the match was CRS critical/error/warning).

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule_id` | `ruleId` | `int32` | singular | The SecLang rule id. |
| `phase` | `phase` | `int32` | singular | CRS phase the rule ran in (1..5). |
| `message` | `message` | `string` | singular | Macro-expanded message (first MatchData message, or the rule's own message line). |
| `severity` | `severity` | `string` | singular | CRS severity ("CRITICAL", "ERROR", "WARNING", "NOTICE", …). |
| `tags` | `tags` | `string` | repeated | Rule tags, if any (e.g. "attack-sqli", "language-sql"). |
| `severity_score` | `severityScore` | `int32` | singular | Severity-based reference value, not the rule's measured contribution. The authoritative aggregate is TestPolicyResponse.total_inbound_score. |
| `disruptive` | `disruptive` | `bool` | singular | Whether this rule produced the transaction's final interruption. |
| `file` | `file` | `string` | singular | Source file + line for debugging. |
| `line` | `line` | `int32` | singular | — |

## Enums

### ArgumentLimitAction

| Value | Number | Description |
|---|---|---|
| `ARGUMENT_LIMIT_ACTION_UNSPECIFIED` | 0 | — |
| `ARGUMENT_LIMIT_ACTION_BLOCK` | 1 | — |
| `ARGUMENT_LIMIT_ACTION_OBSERVE` | 2 | — |

### BodyProcessor

| Value | Number | Description |
|---|---|---|
| `BODY_PROCESSOR_UNSPECIFIED` | 0 | — |
| `BODY_PROCESSOR_JSON` | 1 | — |
| `BODY_PROCESSOR_XML` | 2 | — |
| `BODY_PROCESSOR_URLENCODED` | 3 | — |
| `BODY_PROCESSOR_RAW` | 4 | — |

### HttpPolicyViolationAction

| Value | Number | Description |
|---|---|---|
| `HTTP_POLICY_VIOLATION_ACTION_UNSPECIFIED` | 0 | — |
| `HTTP_POLICY_VIOLATION_ACTION_BLOCK` | 1 | — |
| `HTTP_POLICY_VIOLATION_ACTION_OBSERVE` | 2 | — |

### PolicyLayerKind

| Value | Number | Description |
|---|---|---|
| `POLICY_LAYER_KIND_UNSPECIFIED` | 0 | — |
| `POLICY_LAYER_KIND_CRS_CORE` | 1 | — |
| `POLICY_LAYER_KIND_HTTP_POLICY` | 2 | — |
| `POLICY_LAYER_KIND_ARG_LIMITS` | 3 | — |
| `POLICY_LAYER_KIND_IP_LIST_BINDINGS` | 5 | — |
| `POLICY_LAYER_KIND_PLUGINS` | 6 | — |

### RequestBodyLimitAction

| Value | Number | Description |
|---|---|---|
| `REQUEST_BODY_LIMIT_ACTION_UNSPECIFIED` | 0 | — |
| `REQUEST_BODY_LIMIT_ACTION_BLOCK` | 1 | — |
| `REQUEST_BODY_LIMIT_ACTION_OBSERVE` | 2 | — |
