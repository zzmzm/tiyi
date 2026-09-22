<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# api_schema.proto — api_schema

Schema: `tiyi.v1` · `api_schema.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### ApiSchemaService

| RPC | Kind | Required permission |
|---|---|---|
| [`GetSchemaValidation`](#apischemaservicegetschemavalidation) | unary | `telemetry:read` and `site:read` |
| [`StageApiCatalogChange`](#apischemaservicestageapicatalogchange) | unary | `api_inventory:write` and `site:write` |
| [`GetSchemaLearning`](#apischemaservicegetschemalearning) | unary | `telemetry:read` and `site:read` |
| [`ChangeSchemaLearning`](#apischemaservicechangeschemalearning) | unary | `api_inventory:write` and `site:write` |
| [`SnapshotSchemaLearning`](#apischemaservicesnapshotschemalearning) | unary | `api_inventory:write` and `site:write` |
| [`StageLearnedDocument`](#apischemaservicestagelearneddocument) | unary | `api_inventory:write` and `site:write` |
| [`ExportLearnedDocument`](#apischemaserviceexportlearneddocument) | unary | `telemetry:read` and `site:read` |
| [`GetApiRequestDocument`](#apischemaservicegetapirequestdocument) | unary | `telemetry:read` and `site:read` |
| [`StageApiRequestDocument`](#apischemaservicestageapirequestdocument) | unary | `api_inventory:write` and `site:write` |
| [`StageSchemaSource`](#apischemaservicestageschemasource) | unary | `api_inventory:write` and `site:write` |
| [`ListSchemaSources`](#apischemaservicelistschemasources) | unary | `telemetry:read` and `site:read` |
| [`GetSchemaSource`](#apischemaservicegetschemasource) | unary | `api_inventory:write` and `site:write` |
| [`ListApiDocumentReports`](#apischemaservicelistapidocumentreports) | unary | `telemetry:read` and `site:read` |
| [`GetApiDocumentReport`](#apischemaservicegetapidocumentreport) | unary | `telemetry:read` and `site:read` |
| [`StageSchemaProfile`](#apischemaservicestageschemaprofile) | unary | `api_inventory:write` and `site:write` |
| [`ListSchemaProfiles`](#apischemaservicelistschemaprofiles) | unary | `telemetry:read` and `site:read` |
| [`GetSchemaProfile`](#apischemaservicegetschemaprofile) | unary | `telemetry:read` and `site:read` |
| [`PreviewApiDeclaration`](#apischemaservicepreviewapideclaration) | unary | `telemetry:read` and `site:read` |
| [`StageApiDeclaration`](#apischemaservicestageapideclaration) | unary | `api_inventory:write` and `site:write` |
| [`ListSchemaContracts`](#apischemaservicelistschemacontracts) | unary | `telemetry:read` and `site:read` |
| [`GetSchemaContract`](#apischemaservicegetschemacontract) | unary | `telemetry:read` and `site:read` |
| [`PreviewSchemaControl`](#apischemaservicepreviewschemacontrol) | unary | `telemetry:read` and `site:read` |
| [`ChangeSchemaControl`](#apischemaservicechangeschemacontrol) | unary | `api_inventory:write` and `site:write` and `policy:write` |
| [`StageSchemaBindings`](#apischemaservicestageschemabindings) | unary | `api_inventory:write` and `site:write` |
| [`GetSchemaBindings`](#apischemaservicegetschemabindings) | unary | `telemetry:read` and `site:read` |
| [`ListSchemaBindings`](#apischemaservicelistschemabindings) | unary | `telemetry:read` and `site:read` |
| [`GetSchemaDetection`](#apischemaservicegetschemadetection) | unary | `telemetry:read` and `site:read` |

## RPCs

### ApiSchemaService.GetSchemaValidation

Saved request-validation modes and compiler capabilities for the current catalog.

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetSchemaValidation`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetSchemaValidationRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSchemaValidationResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `validation_json` | `validationJson` | `bytes` | singular | tiyi.api_validation.v1; tied to one immutable desired control snapshot. _base64-encoded JSON string._ |

### ApiSchemaService.StageApiCatalogChange

Prepares adding/removing an observed endpoint in the current API catalog. No confirmation step or traffic learning is required. Publication uses the existing reviewed declaration/control lifecycle.

- **Procedure** `POST /tiyi.v1.ApiSchemaService/StageApiCatalogChange`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.StageApiCatalogChangeRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `asset_id` | `assetId` | `string` | singular | — |
| `expected_asset_revision` | `expectedAssetRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `expected_contract_id` | `expectedContractId` | `string` | singular | — |
| `action` | `action` | `string` | singular | add or remove; endpoint identity is derived from the retained asset. |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.StageApiCatalogChangeResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source` | `source` | [`SchemaSource`](#schemasource) | singular | — |
| `mappings_json` | `mappingsJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `affected_operation_keys` | `affectedOperationKeys` | `string` | repeated | — |
| `selected_operation_key` | `selectedOperationKey` | `string` | singular | — |

### ApiSchemaService.GetSchemaLearning

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetSchemaLearning`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetSchemaLearningRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `asset_id` | `assetId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSchemaLearningResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `state_json` | `stateJson` | `bytes` | singular | Versioned bounded field/type/presence evidence and seven immutable drafts. _base64-encoded JSON string._ |

### ApiSchemaService.ChangeSchemaLearning

Enabling authorizes bounded field-name collection. Purge also stops it.

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ChangeSchemaLearning`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.ChangeSchemaLearningRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `asset_id` | `assetId` | `string` | singular | — |
| `enabled` | `enabled` | `bool` | singular | — |
| `purge` | `purge` | `bool` | singular | — |
| `expected_revision` | `expectedRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.ChangeSchemaLearningResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `state_json` | `stateJson` | `bytes` | singular | _base64-encoded JSON string._ |

### ApiSchemaService.SnapshotSchemaLearning

- **Procedure** `POST /tiyi.v1.ApiSchemaService/SnapshotSchemaLearning`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.SnapshotSchemaLearningRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `asset_id` | `assetId` | `string` | singular | — |

**Response** — `tiyi.v1.SnapshotSchemaLearningResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `revision_json` | `revisionJson` | `bytes` | singular | _base64-encoded JSON string._ |

### ApiSchemaService.StageLearnedDocument

- **Procedure** `POST /tiyi.v1.ApiSchemaService/StageLearnedDocument`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.StageLearnedDocumentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `asset_id` | `assetId` | `string` | singular | — |
| `revision_id` | `revisionId` | `string` | singular | — |
| `expected_contract_id` | `expectedContractId` | `string` | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.StageLearnedDocumentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source` | `source` | [`SchemaSource`](#schemasource) | singular | — |

### ApiSchemaService.ExportLearnedDocument

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ExportLearnedDocument`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.ExportLearnedDocumentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `asset_id` | `assetId` | `string` | singular | — |
| `revision_id` | `revisionId` | `string` | singular | — |

**Response** — `tiyi.v1.ExportLearnedDocumentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `document_json` | `documentJson` | `bytes` | singular | _base64-encoded JSON string._ |

### ApiSchemaService.GetApiRequestDocument

Request previews remain available when detection is disabled.

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetApiRequestDocument`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetApiRequestDocumentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `contract_id` | `contractId` | `string` | singular | — |
| `operation_key` | `operationKey` | `string` | singular | — |

**Response** — `tiyi.v1.GetApiRequestDocumentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source` | `source` | [`SchemaSource`](#schemasource) | singular | — |
| `request_json` | `requestJson` | `bytes` | singular | Request-only JSON: summary, description, effective parameters, requestBody, or Swagger consumes/body/formData. Local schemas may be expanded. _base64-encoded JSON string._ |
| `draft` | `draft` | [`SchemaSource`](#schemasource) | singular | Saved drafts are returned only to document writers. |
| `draft_request_json` | `draftRequestJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `affected_operation_keys` | `affectedOperationKeys` | `string` | repeated | The same source operation can be mapped to multiple endpoints. |

### ApiSchemaService.StageApiRequestDocument

Saves an immutable document draft; never activates detection or routing.

- **Procedure** `POST /tiyi.v1.ApiSchemaService/StageApiRequestDocument`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.StageApiRequestDocumentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `contract_id` | `contractId` | `string` | singular | — |
| `operation_key` | `operationKey` | `string` | singular | — |
| `request_json` | `requestJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `expected_draft_source_id` | `expectedDraftSourceId` | `string` | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.StageApiRequestDocumentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source` | `source` | [`SchemaSource`](#schemasource) | singular | — |

### ApiSchemaService.StageSchemaSource

- **Procedure** `POST /tiyi.v1.ApiSchemaService/StageSchemaSource`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.StageSchemaSourceRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `format` | `format` | `string` | singular | json or yaml. Source is strict, bounded UTF-8; URLs are never fetched. |
| `source` | `source` | `bytes` | singular | _base64-encoded JSON string._ |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.StageSchemaSourceResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source` | `source` | [`SchemaSource`](#schemasource) | singular | — |

### ApiSchemaService.ListSchemaSources

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ListSchemaSources`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.ListSchemaSourcesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.ListSchemaSourcesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `sources` | `sources` | [`SchemaSource`](#schemasource) | repeated | — |
| `max_revisions` | `maxRevisions` | `uint32` | singular | — |
| `retention_limit_bytes` | `retentionLimitBytes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |

### ApiSchemaService.GetSchemaSource

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetSchemaSource`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.GetSchemaSourceRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSchemaSourceResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source` | `source` | [`SchemaSource`](#schemasource) | singular | — |
| `source_bytes` | `sourceBytes` | `bytes` | singular | _base64-encoded JSON string._ |

### ApiSchemaService.ListApiDocumentReports

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ListApiDocumentReports`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.ListApiDocumentReportsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `before_id` | `beforeId` | `string` | singular | — |

**Response** — `tiyi.v1.ListApiDocumentReportsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `reports` | `reports` | [`ApiDocumentReportMetadata`](#apidocumentreportmetadata) | repeated | — |
| `next_before_id` | `nextBeforeId` | `string` | singular | — |

### ApiSchemaService.GetApiDocumentReport

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetApiDocumentReport`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetApiDocumentReportRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `report_id` | `reportId` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | operations or diagnostics. The immutable report ID fixes paging order. |
| `offset` | `offset` | `uint32` | singular | — |
| `page_size` | `pageSize` | `uint32` | singular | 1..100; zero uses 100. |

**Response** — `tiyi.v1.GetApiDocumentReportResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `report_id` | `reportId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `report_sha256` | `reportSha256` | `string` | singular | — |
| `report_format` | `reportFormat` | `string` | singular | — |
| `stage` | `stage` | `string` | singular | — |
| `input_sha256` | `inputSha256` | `string` | singular | — |
| `producer_version` | `producerVersion` | `string` | singular | — |
| `size_bytes` | `sizeBytes` | `uint32` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |
| `page_json` | `pageJson` | `bytes` | singular | Compact operation/unit states or detailed diagnostics, referenced pointers, total/omitted counts and next offset. Never contains the uploaded source. _base64-encoded JSON string._ |

### ApiSchemaService.StageSchemaProfile

- **Procedure** `POST /tiyi.v1.ApiSchemaService/StageSchemaProfile`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.StageSchemaProfileRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `mappings` | `mappings` | [`SchemaMapping`](#schemamapping) | repeated | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.StageSchemaProfileResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `profile` | `profile` | [`SchemaProfile`](#schemaprofile) | singular | — |
| `report_id` | `reportId` | `string` | singular | — |
| `report_sha256` | `reportSha256` | `string` | singular | — |
| `has_checks` | `hasChecks` | `bool` | singular | — |

### ApiSchemaService.ListSchemaProfiles

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ListSchemaProfiles`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.ListSchemaProfilesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | Optional source filter; zero before_revision starts at the newest row. |
| `before_revision` | `beforeRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.ListSchemaProfilesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `profiles` | `profiles` | [`SchemaProfile`](#schemaprofile) | repeated | — |
| `next_before_revision` | `nextBeforeRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### ApiSchemaService.GetSchemaProfile

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetSchemaProfile`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetSchemaProfileRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `profile_id` | `profileId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSchemaProfileResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `profile` | `profile` | [`SchemaProfile`](#schemaprofile) | singular | — |
| `profile_json` | `profileJson` | `bytes` | singular | tiyi.schema_profile.v2 metadata. This does not contain the Agent program. _base64-encoded JSON string._ |

### ApiSchemaService.PreviewApiDeclaration

- **Procedure** `POST /tiyi.v1.ApiSchemaService/PreviewApiDeclaration`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.PreviewApiDeclarationRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `mappings` | `mappings` | [`SchemaMapping`](#schemamapping) | repeated | — |

**Response** — `tiyi.v1.PreviewApiDeclarationResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `source` | `source` | [`SchemaSource`](#schemasource) | singular | — |
| `declaration_json` | `declarationJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `report_sha256` | `reportSha256` | `string` | singular | — |
| `report_json` | `reportJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `reconciliation_json` | `reconciliationJson` | `bytes` | singular | Value-free current asset identities/revisions and declaration matches. _base64-encoded JSON string._ |
| `catalog_sha256` | `catalogSha256` | `string` | singular | — |

### ApiSchemaService.StageApiDeclaration

- **Procedure** `POST /tiyi.v1.ApiSchemaService/StageApiDeclaration`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.StageApiDeclarationRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `mappings` | `mappings` | [`SchemaMapping`](#schemamapping) | repeated | — |
| `report_sha256` | `reportSha256` | `string` | singular | — |
| `catalog_sha256` | `catalogSha256` | `string` | singular | — |
| `decisions` | `decisions` | [`SchemaReconciliationDecision`](#schemareconciliationdecision) | repeated | — |
| `coverage` | `coverage` | [`SchemaCoverageDecision`](#schemacoveragedecision) | repeated | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.StageApiDeclarationResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `contract` | `contract` | [`SchemaContract`](#schemacontract) | singular | — |

### ApiSchemaService.ListSchemaContracts

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ListSchemaContracts`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.ListSchemaContractsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `before_revision` | `beforeRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

**Response** — `tiyi.v1.ListSchemaContractsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `contracts` | `contracts` | [`SchemaContract`](#schemacontract) | repeated | — |
| `next_before_revision` | `nextBeforeRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### ApiSchemaService.GetSchemaContract

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetSchemaContract`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetSchemaContractRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `contract_id` | `contractId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSchemaContractResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `contract` | `contract` | [`SchemaContract`](#schemacontract) | singular | — |
| `contract_json` | `contractJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `changes_json` | `changesJson` | `bytes` | singular | Deterministic difference from the immutable previous contract, if any. _base64-encoded JSON string._ |

### ApiSchemaService.PreviewSchemaControl

- **Procedure** `POST /tiyi.v1.ApiSchemaService/PreviewSchemaControl`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

<a id="previewschemacontrolrequest"></a>
**Request** — `tiyi.v1.PreviewSchemaControlRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `undeclared_action` | `undeclaredAction` | `string` | singular | Empty preserves the current policy; allow, observe or block changes it. |
| `site_id` | `siteId` | `string` | singular | — |
| `action` | `action` | `string` | singular | activate selects a retained draft; deactivate removes the current contract; rollback restores only Schema from an earlier approved, applied intent. |
| `contract_id` | `contractId` | `string` | singular | — |
| `source_intent_id` | `sourceIntentId` | `string` | singular | — |
| `source_config_revision_id` | `sourceConfigRevisionId` | `string` | singular | — |
| `binding_id` | `bindingId` | `string` | singular | Empty explicitly selects declaration-only publication. |

**Response** — `tiyi.v1.PreviewSchemaControlResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `approval` | `approval` | [`SchemaControlApproval`](#schemacontrolapproval) | singular | — |
| `snapshot_json` | `snapshotJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `changes_json` | `changesJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `resources_json` | `resourcesJson` | `bytes` | singular | _base64-encoded JSON string._ |
| `execution_supported` | `executionSupported` | `bool` | singular | — |

### ApiSchemaService.ChangeSchemaControl

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ChangeSchemaControl`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write` and `policy:write`

**Request** — `tiyi.v1.ChangeSchemaControlRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `approval` | `approval` | [`SchemaControlApproval`](#schemacontrolapproval) | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |
| `reason` | `reason` | `string` | singular | — |
| `impact_acknowledged` | `impactAcknowledged` | `bool` | singular | — |
| `resource_acknowledged` | `resourceAcknowledged` | `bool` | singular | — |
| `type_only_acknowledged` | `typeOnlyAcknowledged` | `bool` | singular | Phase 2 is type-only detection and cannot approve enforcement. |
| `accept_partial` | `acceptPartial` | `bool` | singular | — |

**Response** — `tiyi.v1.ChangeSchemaControlResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `intent` | `intent` | [`OperationControlIntent`](operation_control.md#operationcontrolintent) | singular | — |
| `state` | `state` | `string` | singular | — |

### ApiSchemaService.StageSchemaBindings

- **Procedure** `POST /tiyi.v1.ApiSchemaService/StageSchemaBindings`
- **Kind** unary
- **Auth** `api_inventory:write` and `site:write`

**Request** — `tiyi.v1.StageSchemaBindingsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enforce_operation_keys` | `enforceOperationKeys` | `string` | repeated | Subset of operation_keys requiring complete fail-closed validation. |
| `site_id` | `siteId` | `string` | singular | — |
| `declaration_id` | `declarationId` | `string` | singular | — |
| `profile_id` | `profileId` | `string` | singular | — |
| `operation_keys` | `operationKeys` | `string` | repeated | — |
| `accept_partial` | `acceptPartial` | `bool` | singular | — |
| `idempotency_key` | `idempotencyKey` | `string` | singular | — |

**Response** — `tiyi.v1.StageSchemaBindingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `bindings` | `bindings` | [`SchemaBindings`](#schemabindings) | singular | — |

### ApiSchemaService.GetSchemaBindings

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetSchemaBindings`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetSchemaBindingsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `binding_id` | `bindingId` | `string` | singular | — |

**Response** — `tiyi.v1.GetSchemaBindingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `bindings` | `bindings` | [`SchemaBindings`](#schemabindings) | singular | — |
| `bindings_json` | `bindingsJson` | `bytes` | singular | _base64-encoded JSON string._ |

### ApiSchemaService.ListSchemaBindings

- **Procedure** `POST /tiyi.v1.ApiSchemaService/ListSchemaBindings`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.ListSchemaBindingsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `declaration_id` | `declarationId` | `string` | singular | — |
| `before_id` | `beforeId` | `string` | singular | — |

**Response** — `tiyi.v1.ListSchemaBindingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `bindings` | `bindings` | [`SchemaBindings`](#schemabindings) | repeated | — |
| `next_before_id` | `nextBeforeId` | `string` | singular | — |

### ApiSchemaService.GetSchemaDetection

- **Procedure** `POST /tiyi.v1.ApiSchemaService/GetSchemaDetection`
- **Kind** unary
- **Auth** `telemetry:read` and `site:read`

**Request** — `tiyi.v1.GetSchemaDetectionRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `contract_id` | `contractId` | `string` | singular | — |
| `fingerprint` | `fingerprint` | `string` | singular | Optional selection from this contract's authenticated historical sources. |
| `window_start` | `windowStart` | `string` | singular | — |
| `window_end` | `windowEnd` | `string` | singular | — |
| `offset` | `offset` | `uint32` | singular | Immutable contract order; at most 100 operations plus fixed fallback rows. |
| `page_size` | `pageSize` | `uint32` | singular | — |
| `inventory_summary` | `inventorySummary` | `bool` | singular | Whole-contract compact counters for inventory filters. Offset/page_size must be zero. Component/client details remain in the paged report. |
| `include_violation_details` | `includeViolationDetails` | `bool` | singular | Bounded, source-verified samples for exactly one ordinary operation. Requires explicit fingerprint, page_size=1 and inventory_summary=false. |
| `detail_cursor` | `detailCursor` | `string` | singular | — |
| `binding_id` | `bindingId` | `string` | singular | Optional immutable binding selection; empty uses the current binding. |
| `lookback_seconds` | `lookbackSeconds` | `uint32` | singular | Initial automatic query: 3600 (1h), 86400 (24h), or 604800 (7d). Mutually exclusive with window_start/window_end. The server aligns the end to the latest completed 10-second interval and clips the start to its retained UTC days. Offset must be zero and details are not allowed. Pagination and details use the returned query_start/query_end instead. |

**Response** — `tiyi.v1.GetSchemaDetectionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `detection_json` | `detectionJson` | `bytes` | singular | tiyi.schema_detection.v3. Every successful response includes the resolved query_start/query_end, including disabled and no-evidence responses. Counters are lossless decimal strings. Missing evidence is explicit; reports alone never authorize request enforcement. _base64-encoded JSON string._ |

## Messages

### ApiDocumentReportMetadata

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `stage` | `stage` | `string` | singular | — |
| `report_sha256` | `reportSha256` | `string` | singular | — |
| `producer_version` | `producerVersion` | `string` | singular | — |
| `size_bytes` | `sizeBytes` | `uint32` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |

### SchemaBindings

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `declaration_id` | `declarationId` | `string` | singular | — |
| `profile_id` | `profileId` | `string` | singular | — |
| `sha256` | `sha256` | `string` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |

### SchemaContract

A reviewed immutable draft. Only an approved deployment changes inventory and request evaluation; staging does not claim activation or observations.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `report_id` | `reportId` | `string` | singular | — |
| `report_sha256` | `reportSha256` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `sha256` | `sha256` | `string` | singular | — |
| `catalog_sha256` | `catalogSha256` | `string` | singular | — |
| `previous_contract_sha256` | `previousContractSha256` | `string` | singular | — |
| `size_bytes` | `sizeBytes` | `uint32` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |

### SchemaControlApproval

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `selection` | `selection` | [`PreviewSchemaControlRequest`](#previewschemacontrolrequest) | singular | — |
| `review` | `review` | [`OperationControlReview`](operation_control.md#operationcontrolreview) | singular | — |
| `contract_sha256` | `contractSha256` | `string` | singular | — |
| `catalog_sha256` | `catalogSha256` | `string` | singular | — |
| `previous_contract_sha256` | `previousContractSha256` | `string` | singular | — |
| `policy_files_sha256` | `policyFilesSha256` | `string` | singular | — |
| `preview_runtime_sha256` | `previewRuntimeSha256` | `string` | singular | Private validation projection, never an applied artifact identity. |
| `snapshot_sha256` | `snapshotSha256` | `string` | singular | — |
| `before_snapshot_sha256` | `beforeSnapshotSha256` | `string` | singular | — |
| `requires_partial_acceptance` | `requiresPartialAcceptance` | `bool` | singular | — |
| `recovery_artifact_sha256` | `recoveryArtifactSha256` | `string` | singular | — |
| `recovery_artifact_generation` | `recoveryArtifactGeneration` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `recovery_applied_targets_sha256` | `recoveryAppliedTargetsSha256` | `string` | singular | — |
| `recovery_applied_targets` | `recoveryAppliedTargets` | [`OperationControlTarget`](operation_control.md#operationcontroltarget) | repeated | Historical application, never the new rollback's convergence. |
| `binding_sha256` | `bindingSha256` | `string` | singular | — |
| `previous_binding_sha256` | `previousBindingSha256` | `string` | singular | — |

### SchemaCoverageDecision

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `scope_sha256` | `scopeSha256` | `string` | singular | — |
| `state` | `state` | `string` | singular | partial or authoritative_complete, independently reviewed per scope. |
| `acknowledged` | `acknowledged` | `bool` | singular | — |

### SchemaMapping

Explicit source-to-site mapping. Variables never come from request input.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `host` | `host` | `string` | singular | — |
| `base_path` | `basePath` | `string` | singular | — |
| `methods` | `methods` | `string` | repeated | — |
| `variables` | `variables` | map&lt;`string`, `string`&gt; | map | — |
| `server_url` | `serverUrl` | `string` | singular | — |
| `approved` | `approved` | `bool` | singular | — |

### SchemaProfile

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `source_id` | `sourceId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `profile_sha256` | `profileSha256` | `string` | singular | — |
| `artifact_sha256` | `artifactSha256` | `string` | singular | — |
| `operation_count` | `operationCount` | `uint32` | singular | — |
| `size_bytes` | `sizeBytes` | `uint32` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |
| `report_id` | `reportId` | `string` | singular | — |
| `report_sha256` | `reportSha256` | `string` | singular | — |

### SchemaReconciliationDecision

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `key` | `key` | `string` | singular | — |
| `asset_id` | `assetId` | `string` | singular | Existing eligible preview candidate. New UUIDs are minted by the server. |
| `create_new` | `createNew` | `bool` | singular | — |
| `attach_aliases` | `attachAliases` | `string` | repeated | — |
| `acknowledged` | `acknowledged` | `bool` | singular | — |

### SchemaSource

Immutable upload provenance. This resource is staged, never evidence that a profile, declaration, control or runtime artifact has been activated.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `revision` | `revision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `name` | `name` | `string` | singular | — |
| `format` | `format` | `string` | singular | — |
| `source_sha256` | `sourceSha256` | `string` | singular | — |
| `size_bytes` | `sizeBytes` | `uint32` | singular | — |
| `warnings` | `warnings` | `uint32` | singular | — |
| `created_at` | `createdAt` | `string` | singular | — |
| `document_family` | `documentFamily` | `string` | singular | — |
| `document_version` | `documentVersion` | `string` | singular | — |
| `parser_version` | `parserVersion` | `string` | singular | — |
| `parse_report_id` | `parseReportId` | `string` | singular | — |
| `parse_report_sha256` | `parseReportSha256` | `string` | singular | — |
| `manually_edited` | `manuallyEdited` | `bool` | singular | — |
| `learned_revision_id` | `learnedRevisionId` | `string` | singular | — |
| `learned_sha256` | `learnedSha256` | `string` | singular | — |
| `learned_mappings_json` | `learnedMappingsJson` | `bytes` | singular | _base64-encoded JSON string._ |
