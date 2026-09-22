<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# rule.proto — Rule primitives shared by policy services

Schema: `tiyi.v1` · `rule.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### RuleOverrideService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListRuleOverrides`](#ruleoverrideservicelistruleoverrides) | unary | (`policy:read`) |
| [`GetRuleOverride`](#ruleoverrideservicegetruleoverride) | unary | (`policy:read`) |
| [`UpsertRuleOverride`](#ruleoverrideserviceupsertruleoverride) | unary | (`policy:rule:override`) |
| [`DeleteRuleOverride`](#ruleoverrideservicedeleteruleoverride) | unary | (`policy:rule:override`) |
| [`BulkUpsertRuleOverrides`](#ruleoverrideservicebulkupsertruleoverrides) | unary | (`policy:rule:override`) |
| [`ListCrsRulesForPolicy`](#ruleoverrideservicelistcrsrulesforpolicy) | unary | (`policy:read`) |

### CustomRuleService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListCustomRules`](#customruleservicelistcustomrules) | unary | (`policy:read`) |
| [`GetCustomRule`](#customruleservicegetcustomrule) | unary | (`policy:read`) |
| [`CreateCustomRule`](#customruleservicecreatecustomrule) | unary | (`policy:custom:write`) |
| [`UpdateCustomRule`](#customruleserviceupdatecustomrule) | unary | (`policy:custom:write`) |
| [`DeleteCustomRule`](#customruleservicedeletecustomrule) | unary | (`policy:custom:write`) |
| [`ReorderCustomRules`](#customruleservicereordercustomrules) | unary | (`policy:custom:write`) |
| [`PreviewCustomRule`](#customruleservicepreviewcustomrule) | unary | (`policy:preview`) |
| [`ListCustomRuleTemplates`](#customruleservicelistcustomruletemplates) | unary | (`policy:read`) |
| [`CreateFromTemplate`](#customruleservicecreatefromtemplate) | unary | (`policy:custom:write`) |

### IpListService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListIpLists`](#iplistservicelistiplists) | unary | (`policy:read`) |
| [`GetIpList`](#iplistservicegetiplist) | unary | (`policy:read`) |
| [`ListIpListEntries`](#iplistservicelistiplistentries) | unary | (`policy:read`) |
| [`CreateIpList`](#iplistservicecreateiplist) | unary | (`policy:iplist:write`) |
| [`UpdateIpList`](#iplistserviceupdateiplist) | unary | (`policy:iplist:write`) |
| [`DeleteIpList`](#iplistservicedeleteiplist) | unary | (`policy:iplist:write`) |
| [`ReplaceIpListEntries`](#iplistservicereplaceiplistentries) | unary | (`policy:iplist:write`) |
| [`CloneIpList`](#iplistservicecloneiplist) | unary | (`policy:iplist:write`) |
| [`GetIpListEditImpact`](#iplistservicegetiplisteditimpact) | unary | (`policy:read`) |
| [`CreateIpListSubscription`](#iplistservicecreateiplistsubscription) | unary | (`policy:iplist:source:write`) |
| [`UpdateIpListSubscription`](#iplistserviceupdateiplistsubscription) | unary | (`policy:iplist:source:write`) |
| [`TestIpListSource`](#iplistservicetestiplistsource) | unary | (`policy:iplist:source:write`) |
| [`SyncIpListNow`](#iplistservicesynciplistnow) | unary | (`policy:iplist:sync`) |
| [`PauseIpListSync`](#iplistservicepauseiplistsync) | unary | (`policy:iplist:sync`) |
| [`ResumeIpListSync`](#iplistserviceresumeiplistsync) | unary | (`policy:iplist:sync`) |
| [`ListIpListSyncRuns`](#iplistservicelistiplistsyncruns) | unary | (`policy:read`) |
| [`AcceptHeldIpListUpdate`](#iplistserviceacceptheldiplistupdate) | unary | (`policy:iplist:sync`) |
| [`DiscardHeldIpListUpdate`](#iplistservicediscardheldiplistupdate) | unary | (`policy:iplist:sync`) |
| [`AddEntries`](#iplistserviceaddentries) | unary | (`policy:iplist:write`) |
| [`RemoveEntries`](#iplistserviceremoveentries) | unary | (`policy:iplist:write`) |
| [`ExportCsv`](#iplistserviceexportcsv) | unary | (`policy:read`) |
| [`LookupIp`](#iplistservicelookupip) | unary | (`policy:read`) |
| [`LookupIpScopes`](#iplistservicelookupipscopes) | unary | (`policy:read`) |
| [`ListIpListBindings`](#iplistservicelistiplistbindings) | unary | (`policy:read`) |
| [`UpsertIpListBinding`](#iplistserviceupsertiplistbinding) | unary | (`policy:iplist:write`) |
| [`DeleteIpListBinding`](#iplistservicedeleteiplistbinding) | unary | (`policy:iplist:write`) |
| [`ListGlobalIpListBindings`](#iplistservicelistglobaliplistbindings) | unary | (`policy:read`) |
| [`UpsertGlobalIpListBinding`](#iplistserviceupsertglobaliplistbinding) | unary | (`policy:iplist:write`) |
| [`DeleteGlobalIpListBinding`](#iplistservicedeleteglobaliplistbinding) | unary | (`policy:iplist:write`) |
| [`ListIpListReferences`](#iplistservicelistiplistreferences) | unary | (`policy:read`) |
| [`ApplyIpList`](#iplistserviceapplyiplist) | unary | (`policy:iplist:write`) |

### CountryAccessService

CountryAccessService owns jurisdiction-aware access decisions. Country codes are structured ISO values backed by the active Country MMDB; they are never encoded as synthetic IP-list entries.

| RPC | Kind | Required permission |
|---|---|---|
| [`ListCountryAccessRules`](#countryaccessservicelistcountryaccessrules) | unary | (`policy:read`) |
| [`GetCountryAccessRule`](#countryaccessservicegetcountryaccessrule) | unary | (`policy:read`) |
| [`GetCountryCatalog`](#countryaccessservicegetcountrycatalog) | unary | (`policy:read`) |
| [`UpsertCountryAccessRule`](#countryaccessserviceupsertcountryaccessrule) | unary | (`policy:country:write`) |
| [`DeleteCountryAccessRule`](#countryaccessservicedeletecountryaccessrule) | unary | (`policy:country:write`) |

### RateLimitService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListRateLimitEndpoints`](#ratelimitservicelistratelimitendpoints) | unary | (`policy:read`) |
| [`UpsertRateLimitEndpoint`](#ratelimitserviceupsertratelimitendpoint) | unary | (`policy:write`) |
| [`DeleteRateLimitEndpoint`](#ratelimitservicedeleteratelimitendpoint) | unary | (`policy:write`) |

### CrsService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListCrsRulesets`](#crsservicelistcrsrulesets) | unary | (`policy:read`) |
| [`GetCrsRuleset`](#crsservicegetcrsruleset) | unary | (`policy:read`) |
| [`ListCrsRules`](#crsservicelistcrsrules) | unary | (`policy:read`) |
| [`GetCrsRule`](#crsservicegetcrsrule) | unary | (`policy:read`) |
| [`ListCrsCategories`](#crsservicelistcrscategories) | unary | (`policy:read`) |
| [`ListCrsTags`](#crsservicelistcrstags) | unary | (`policy:read`) |
| [`ListCrsPlugins`](#crsservicelistcrsplugins) | unary | (`policy:read`) |
| [`GetCrsPluginConfigSchema`](#crsservicegetcrspluginconfigschema) | unary | (`policy:read`) |
| [`ListCrsExclusionPlugins`](#crsservicelistcrsexclusionplugins) | unary | (`policy:read`) |
| [`GetCrsExclusionPlugin`](#crsservicegetcrsexclusionplugin) | unary | (`policy:read`) |
| [`ImportCrsExclusionPlugin`](#crsserviceimportcrsexclusionplugin) | unary | (`system:update:write`) |
| [`ListUpstreamCrsExclusionPluginReleases`](#crsservicelistupstreamcrsexclusionpluginreleases) | unary | (`system:update:read`) |
| [`ListPolicyExclusionPlugins`](#crsservicelistpolicyexclusionplugins) | unary | (`policy:read`) |
| [`UpsertPolicyExclusionPlugin`](#crsserviceupsertpolicyexclusionplugin) | unary | (`policy:write`) |
| [`DeletePolicyExclusionPlugin`](#crsservicedeletepolicyexclusionplugin) | unary | (`policy:write`) |

## RPCs

### RuleOverrideService.ListRuleOverrides

- **Procedure** `POST /tiyi.v1.RuleOverrideService/ListRuleOverrides`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListRuleOverridesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListRuleOverridesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`RuleOverride`](#ruleoverride) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### RuleOverrideService.GetRuleOverride

- **Procedure** `POST /tiyi.v1.RuleOverrideService/GetRuleOverride`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetRuleOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetRuleOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override` | `override` | [`RuleOverride`](#ruleoverride) | singular | — |

### RuleOverrideService.UpsertRuleOverride

- **Procedure** `POST /tiyi.v1.RuleOverrideService/UpsertRuleOverride`
- **Kind** unary
- **Auth** (`policy:rule:override`)

**Request** — `tiyi.v1.UpsertRuleOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override` | `override` | [`RuleOverride`](#ruleoverride) | singular | — |

**Response** — `tiyi.v1.UpsertRuleOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `override` | `override` | [`RuleOverride`](#ruleoverride) | singular | — |

### RuleOverrideService.DeleteRuleOverride

- **Procedure** `POST /tiyi.v1.RuleOverrideService/DeleteRuleOverride`
- **Kind** unary
- **Auth** (`policy:rule:override`)

**Request** — `tiyi.v1.DeleteRuleOverrideRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteRuleOverrideResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### RuleOverrideService.BulkUpsertRuleOverrides

- **Procedure** `POST /tiyi.v1.RuleOverrideService/BulkUpsertRuleOverrides`
- **Kind** unary
- **Auth** (`policy:rule:override`)

**Request** — `tiyi.v1.BulkUpsertRuleOverridesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `overrides` | `overrides` | [`RuleOverride`](#ruleoverride) | repeated | — |

**Response** — `tiyi.v1.BulkUpsertRuleOverridesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `overrides` | `overrides` | [`RuleOverride`](#ruleoverride) | repeated | — |

### RuleOverrideService.ListCrsRulesForPolicy

- **Procedure** `POST /tiyi.v1.RuleOverrideService/ListCrsRulesForPolicy`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCrsRulesForPolicyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |

**Response** — `tiyi.v1.ListCrsRulesForPolicyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CrsRule`](#crsrule) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### CustomRuleService.ListCustomRules

- **Procedure** `POST /tiyi.v1.CustomRuleService/ListCustomRules`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCustomRulesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListCustomRulesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CustomRule`](#customrule) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### CustomRuleService.GetCustomRule

- **Procedure** `POST /tiyi.v1.CustomRuleService/GetCustomRule`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetCustomRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetCustomRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CustomRule`](#customrule) | singular | — |

### CustomRuleService.CreateCustomRule

- **Procedure** `POST /tiyi.v1.CustomRuleService/CreateCustomRule`
- **Kind** unary
- **Auth** (`policy:custom:write`)

**Request** — `tiyi.v1.CreateCustomRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CustomRule`](#customrule) | singular | — |

**Response** — `tiyi.v1.CreateCustomRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CustomRule`](#customrule) | singular | — |

### CustomRuleService.UpdateCustomRule

- **Procedure** `POST /tiyi.v1.CustomRuleService/UpdateCustomRule`
- **Kind** unary
- **Auth** (`policy:custom:write`)

**Request** — `tiyi.v1.UpdateCustomRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CustomRule`](#customrule) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdateCustomRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CustomRule`](#customrule) | singular | — |

### CustomRuleService.DeleteCustomRule

- **Procedure** `POST /tiyi.v1.CustomRuleService/DeleteCustomRule`
- **Kind** unary
- **Auth** (`policy:custom:write`)

**Request** — `tiyi.v1.DeleteCustomRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteCustomRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### CustomRuleService.ReorderCustomRules

- **Procedure** `POST /tiyi.v1.CustomRuleService/ReorderCustomRules`
- **Kind** unary
- **Auth** (`policy:custom:write`)

**Request** — `tiyi.v1.ReorderCustomRulesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `rule_ids` | `ruleIds` | `string` | repeated | — |

**Response** — `tiyi.v1.ReorderCustomRulesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rules` | `rules` | [`CustomRule`](#customrule) | repeated | — |

### CustomRuleService.PreviewCustomRule

- **Procedure** `POST /tiyi.v1.CustomRuleService/PreviewCustomRule`
- **Kind** unary
- **Auth** (`policy:preview`)

**Request** — `tiyi.v1.PreviewCustomRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CustomRule`](#customrule) | singular | — |

**Response** — `tiyi.v1.PreviewCustomRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `seclang` | `seclang` | `string` | singular | — |
| `warnings` | `warnings` | `string` | repeated | — |

### CustomRuleService.ListCustomRuleTemplates

- **Procedure** `POST /tiyi.v1.CustomRuleService/ListCustomRuleTemplates`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCustomRuleTemplatesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListCustomRuleTemplatesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CustomRuleTemplate`](#customruletemplate) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### CustomRuleService.CreateFromTemplate

- **Procedure** `POST /tiyi.v1.CustomRuleService/CreateFromTemplate`
- **Kind** unary
- **Auth** (`policy:custom:write`)

**Request** — `tiyi.v1.CreateFromTemplateRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `template_id` | `templateId` | `string` | singular | — |
| `parameters` | `parameters` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `site_id` | `siteId` | `string` | singular | Optional site id. When empty the rule is policy-wide; when set the resulting custom_rule row is scoped to that site. Matches CustomRule.site_id semantics (WAF_POLICY_DESIGN § 3.2). |

**Response** — `tiyi.v1.CreateFromTemplateResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CustomRule`](#customrule) | singular | — |

### IpListService.ListIpLists

- **Procedure** `POST /tiyi.v1.IpListService/ListIpLists`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListIpListsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |
| `management_mode` | `managementMode` | `string` | singular | — |

**Response** — `tiyi.v1.ListIpListsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`IpList`](#iplist) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### IpListService.GetIpList

- **Procedure** `POST /tiyi.v1.IpListService/GetIpList`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetIpListRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetIpListResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.ListIpListEntries

- **Procedure** `POST /tiyi.v1.IpListService/ListIpListEntries`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListIpListEntriesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `address_family` | `addressFamily` | `string` | singular | all \| ipv4 \| ipv6. Empty keeps both address families. |
| `query` | `query` | `string` | singular | Optional case-insensitive CIDR substring search. |
| `etag` | `etag` | `string` | singular | Optional concurrency token returned by a prior page. When current content changes between pages the server rejects the stale token. |

**Response** — `tiyi.v1.ListIpListEntriesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`IpListEntry`](#iplistentry) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |
| `ipv4_count` | `ipv4Count` | `int32` | singular | — |
| `ipv6_count` | `ipv6Count` | `int32` | singular | — |
| `etag` | `etag` | `string` | singular | — |

### IpListService.CreateIpList

- **Procedure** `POST /tiyi.v1.IpListService/CreateIpList`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.CreateIpListRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

**Response** — `tiyi.v1.CreateIpListResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.UpdateIpList

- **Procedure** `POST /tiyi.v1.IpListService/UpdateIpList`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.UpdateIpListRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdateIpListResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.DeleteIpList

- **Procedure** `POST /tiyi.v1.IpListService/DeleteIpList`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.DeleteIpListRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteIpListResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### IpListService.ReplaceIpListEntries

- **Procedure** `POST /tiyi.v1.IpListService/ReplaceIpListEntries`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.ReplaceIpListEntriesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `entries` | `entries` | [`IpListEntry`](#iplistentry) | repeated | — |
| `etag` | `etag` | `string` | singular | — |
| `exclusive_global_kind` | `exclusiveGlobalKind` | `string` | singular | For withdrawal of a dedicated quick action: requires empty replacement content and at most one global access-control reference of this kind. Checked in the content transaction so concurrent new references abort. |

**Response** — `tiyi.v1.ReplaceIpListEntriesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |
| `affected_consumers` | `affectedConsumers` | `int32` | singular | — |
| `rollout` | `rollout` | [`IpListRollout`](#iplistrollout) | singular | — |

### IpListService.CloneIpList

- **Procedure** `POST /tiyi.v1.IpListService/CloneIpList`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.CloneIpListRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |

**Response** — `tiyi.v1.CloneIpListResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.GetIpListEditImpact

- **Procedure** `POST /tiyi.v1.IpListService/GetIpListEditImpact`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetIpListEditImpactRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetIpListEditImpactResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `references` | `references` | [`IpListReference`](#iplistreference) | repeated | — |
| `affected_consumers` | `affectedConsumers` | `int32` | singular | — |

### IpListService.CreateIpListSubscription

- **Procedure** `POST /tiyi.v1.IpListService/CreateIpListSubscription`
- **Kind** unary
- **Auth** (`policy:iplist:source:write`)

**Request** — `tiyi.v1.CreateIpListSubscriptionRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `source` | `source` | [`IpListSourceInput`](#iplistsourceinput) | singular | — |
| `sync_now` | `syncNow` | `bool` | singular | — |

**Response** — `tiyi.v1.CreateIpListSubscriptionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |
| `sync_run` | `syncRun` | [`IpListSyncRun`](#iplistsyncrun) | singular | — |

### IpListService.UpdateIpListSubscription

- **Procedure** `POST /tiyi.v1.IpListService/UpdateIpListSubscription`
- **Kind** unary
- **Auth** (`policy:iplist:source:write`)

**Request** — `tiyi.v1.UpdateIpListSubscriptionRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `source` | `source` | [`IpListSourceInput`](#iplistsourceinput) | singular | — |
| `sync_now` | `syncNow` | `bool` | singular | — |

**Response** — `tiyi.v1.UpdateIpListSubscriptionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |
| `sync_run` | `syncRun` | [`IpListSyncRun`](#iplistsyncrun) | singular | — |

### IpListService.TestIpListSource

- **Procedure** `POST /tiyi.v1.IpListService/TestIpListSource`
- **Kind** unary
- **Auth** (`policy:iplist:source:write`)

**Request** — `tiyi.v1.TestIpListSourceRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `source` | `source` | [`IpListSourceInput`](#iplistsourceinput) | singular | optional draft source; omitted tests saved config |

**Response** — `tiyi.v1.TestIpListSourceResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `http_status` | `httpStatus` | `int32` | singular | — |
| `entry_count` | `entryCount` | `int32` | singular | — |
| `ipv4_count` | `ipv4Count` | `int32` | singular | — |
| `ipv6_count` | `ipv6Count` | `int32` | singular | — |
| `digest` | `digest` | `string` | singular | — |
| `not_modified` | `notModified` | `bool` | singular | — |

### IpListService.SyncIpListNow

- **Procedure** `POST /tiyi.v1.IpListService/SyncIpListNow`
- **Kind** unary
- **Auth** (`policy:iplist:sync`)

**Request** — `tiyi.v1.SyncIpListNowRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.SyncIpListNowResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `sync_run` | `syncRun` | [`IpListSyncRun`](#iplistsyncrun) | singular | — |

### IpListService.PauseIpListSync

- **Procedure** `POST /tiyi.v1.IpListService/PauseIpListSync`
- **Kind** unary
- **Auth** (`policy:iplist:sync`)

**Request** — `tiyi.v1.PauseIpListSyncRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.PauseIpListSyncResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.ResumeIpListSync

- **Procedure** `POST /tiyi.v1.IpListService/ResumeIpListSync`
- **Kind** unary
- **Auth** (`policy:iplist:sync`)

**Request** — `tiyi.v1.ResumeIpListSyncRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `sync_now` | `syncNow` | `bool` | singular | — |

**Response** — `tiyi.v1.ResumeIpListSyncResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |
| `sync_run` | `syncRun` | [`IpListSyncRun`](#iplistsyncrun) | singular | — |

### IpListService.ListIpListSyncRuns

- **Procedure** `POST /tiyi.v1.IpListService/ListIpListSyncRuns`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListIpListSyncRunsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `limit` | `limit` | `int32` | singular | — |

**Response** — `tiyi.v1.ListIpListSyncRunsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`IpListSyncRun`](#iplistsyncrun) | repeated | — |

### IpListService.AcceptHeldIpListUpdate

- **Procedure** `POST /tiyi.v1.IpListService/AcceptHeldIpListUpdate`
- **Kind** unary
- **Auth** (`policy:iplist:sync`)

**Request** — `tiyi.v1.AcceptHeldIpListUpdateRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.AcceptHeldIpListUpdateResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `sync_run` | `syncRun` | [`IpListSyncRun`](#iplistsyncrun) | singular | — |

### IpListService.DiscardHeldIpListUpdate

- **Procedure** `POST /tiyi.v1.IpListService/DiscardHeldIpListUpdate`
- **Kind** unary
- **Auth** (`policy:iplist:sync`)

**Request** — `tiyi.v1.DiscardHeldIpListUpdateRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DiscardHeldIpListUpdateResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.AddEntries

- **Procedure** `POST /tiyi.v1.IpListService/AddEntries`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.AddEntriesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `entries` | `entries` | [`IpListEntry`](#iplistentry) | repeated | — |

**Response** — `tiyi.v1.AddEntriesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.RemoveEntries

- **Procedure** `POST /tiyi.v1.IpListService/RemoveEntries`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.RemoveEntriesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `values` | `values` | `string` | repeated | — |

**Response** — `tiyi.v1.RemoveEntriesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list` | `ipList` | [`IpList`](#iplist) | singular | — |

### IpListService.ExportCsv

- **Procedure** `POST /tiyi.v1.IpListService/ExportCsv`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ExportCsvRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |

**Response** — `tiyi.v1.ExportCsvResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `csv` | `csv` | `bytes` | singular | _base64-encoded JSON string._ |
| `filename` | `filename` | `string` | singular | — |

### IpListService.LookupIp

- **Procedure** `POST /tiyi.v1.IpListService/LookupIp`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.LookupIpRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `ip` | `ip` | `string` | singular | — |

**Response** — `tiyi.v1.LookupIpResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `matched` | `matched` | `bool` | singular | — |
| `entries` | `entries` | [`IpListEntry`](#iplistentry) | repeated | — |
| `decision` | `decision` | `string` | singular | — |

### IpListService.LookupIpScopes

- **Procedure** `POST /tiyi.v1.IpListService/LookupIpScopes`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.LookupIpScopesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip` | `ip` | `string` | singular | One client IP, not a CIDR range. |
| `site_id` | `siteId` | `string` | singular | — |
| `peer_ip` | `peerIp` | `string` | singular | Required for a complete decision when applicable bindings use peer_ip. |
| `request_path` | `requestPath` | `string` | singular | URL path, default /. Percent escapes are decoded before path matching. |

**Response** — `tiyi.v1.LookupIpScopesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `hits` | `hits` | [`IpListScopeHit`](#iplistscopehit) | repeated | — |
| `decision` | `decision` | `string` | singular | IP-list bindings only; empty unless decision_status is evaluated. |
| `decision_status` | `decisionStatus` | `string` | singular | evaluated \| site_required \| peer_required |
| `decision_binding_id` | `decisionBindingId` | `string` | singular | — |

### IpListService.ListIpListBindings

Bindings — attach an IP list to a policy. See WAF_POLICY_DESIGN.md § 3.2 / § 4.1 for the path_prefix + site_id semantics.

- **Procedure** `POST /tiyi.v1.IpListService/ListIpListBindings`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListIpListBindingsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | When set, filter to bindings for this site plus policy-wide bindings. |

**Response** — `tiyi.v1.ListIpListBindingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`IpListBindingRecord`](#iplistbindingrecord) | repeated | — |

### IpListService.UpsertIpListBinding

- **Procedure** `POST /tiyi.v1.IpListService/UpsertIpListBinding`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.UpsertIpListBindingRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `binding` | `binding` | [`IpListBindingRecord`](#iplistbindingrecord) | singular | — |

**Response** — `tiyi.v1.UpsertIpListBindingResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `binding` | `binding` | [`IpListBindingRecord`](#iplistbindingrecord) | singular | — |

### IpListService.DeleteIpListBinding

- **Procedure** `POST /tiyi.v1.IpListService/DeleteIpListBinding`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.DeleteIpListBindingRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteIpListBindingResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### IpListService.ListGlobalIpListBindings

- **Procedure** `POST /tiyi.v1.IpListService/ListGlobalIpListBindings`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListGlobalIpListBindingsRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ListGlobalIpListBindingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`IpListBindingRecord`](#iplistbindingrecord) | repeated | — |

### IpListService.UpsertGlobalIpListBinding

- **Procedure** `POST /tiyi.v1.IpListService/UpsertGlobalIpListBinding`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.UpsertGlobalIpListBindingRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `binding` | `binding` | [`IpListBindingRecord`](#iplistbindingrecord) | singular | — |

**Response** — `tiyi.v1.UpsertGlobalIpListBindingResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `binding` | `binding` | [`IpListBindingRecord`](#iplistbindingrecord) | singular | — |

### IpListService.DeleteGlobalIpListBinding

- **Procedure** `POST /tiyi.v1.IpListService/DeleteGlobalIpListBinding`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.DeleteGlobalIpListBindingRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteGlobalIpListBindingResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### IpListService.ListIpListReferences

- **Procedure** `POST /tiyi.v1.IpListService/ListIpListReferences`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListIpListReferencesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |

**Response** — `tiyi.v1.ListIpListReferencesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`IpListReference`](#iplistreference) | repeated | — |

### IpListService.ApplyIpList

- **Procedure** `POST /tiyi.v1.IpListService/ApplyIpList`
- **Kind** unary
- **Auth** (`policy:iplist:write`)

**Request** — `tiyi.v1.ApplyIpListRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `targets` | `targets` | [`IpListApplyTarget`](#iplistapplytarget) | repeated | — |
| `kind` | `kind` | `string` | singular | Required action: allow \| deny \| monitor. |
| `bypass_mode` | `bypassMode` | `string` | singular | — |
| `address_source` | `addressSource` | `string` | singular | client_ip \| peer_ip |
| `match_mode` | `matchMode` | `string` | singular | in_list \| not_in_list |
| `etag` | `etag` | `string` | singular | Optional optimistic guard for a previously saved operation receipt. |

**Response** — `tiyi.v1.ApplyIpListResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `references` | `references` | [`IpListReference`](#iplistreference) | repeated | — |
| `saved` | `saved` | `bool` | singular | Bindings and compiled policy hashes committed atomically. |
| `applied` | `applied` | `bool` | singular | Controller apply completed; individual remote nodes may still be pending. |
| `apply_error` | `applyError` | `string` | singular | — |

### CountryAccessService.ListCountryAccessRules

- **Procedure** `POST /tiyi.v1.CountryAccessService/ListCountryAccessRules`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCountryAccessRulesRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ListCountryAccessRulesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CountryAccessRule`](#countryaccessrule) | repeated | — |

### CountryAccessService.GetCountryAccessRule

- **Procedure** `POST /tiyi.v1.CountryAccessService/GetCountryAccessRule`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetCountryAccessRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetCountryAccessRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CountryAccessRule`](#countryaccessrule) | singular | — |

### CountryAccessService.GetCountryCatalog

- **Procedure** `POST /tiyi.v1.CountryAccessService/GetCountryCatalog`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetCountryCatalogRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetCountryCatalogResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `catalog` | `catalog` | [`CountryCatalog`](#countrycatalog) | singular | — |

### CountryAccessService.UpsertCountryAccessRule

- **Procedure** `POST /tiyi.v1.CountryAccessService/UpsertCountryAccessRule`
- **Kind** unary
- **Auth** (`policy:country:write`)

**Request** — `tiyi.v1.UpsertCountryAccessRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CountryAccessRule`](#countryaccessrule) | singular | — |

**Response** — `tiyi.v1.UpsertCountryAccessRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CountryAccessRule`](#countryaccessrule) | singular | — |

### CountryAccessService.DeleteCountryAccessRule

- **Procedure** `POST /tiyi.v1.CountryAccessService/DeleteCountryAccessRule`
- **Kind** unary
- **Auth** (`policy:country:write`)

**Request** — `tiyi.v1.DeleteCountryAccessRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteCountryAccessRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### RateLimitService.ListRateLimitEndpoints

- **Procedure** `POST /tiyi.v1.RateLimitService/ListRateLimitEndpoints`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListRateLimitEndpointsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.ListRateLimitEndpointsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`RateLimitEndpointRecord`](#ratelimitendpointrecord) | repeated | — |

### RateLimitService.UpsertRateLimitEndpoint

- **Procedure** `POST /tiyi.v1.RateLimitService/UpsertRateLimitEndpoint`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.UpsertRateLimitEndpointRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `endpoint` | `endpoint` | [`RateLimitEndpointRecord`](#ratelimitendpointrecord) | singular | — |

**Response** — `tiyi.v1.UpsertRateLimitEndpointResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `endpoint` | `endpoint` | [`RateLimitEndpointRecord`](#ratelimitendpointrecord) | singular | — |

### RateLimitService.DeleteRateLimitEndpoint

- **Procedure** `POST /tiyi.v1.RateLimitService/DeleteRateLimitEndpoint`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.DeleteRateLimitEndpointRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteRateLimitEndpointResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### CrsService.ListCrsRulesets

- **Procedure** `POST /tiyi.v1.CrsService/ListCrsRulesets`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCrsRulesetsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListCrsRulesetsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CrsRuleset`](#crsruleset) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### CrsService.GetCrsRuleset

- **Procedure** `POST /tiyi.v1.CrsService/GetCrsRuleset`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetCrsRulesetRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetCrsRulesetResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset` | `ruleset` | [`CrsRuleset`](#crsruleset) | singular | — |

### CrsService.ListCrsRules

- **Procedure** `POST /tiyi.v1.CrsService/ListCrsRules`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCrsRulesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset_id` | `rulesetId` | `string` | singular | — |
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |
| `tags` | `tags` | `string` | repeated | — |
| `category` | `category` | `string` | singular | — |
| `paranoia_level` | `paranoiaLevel` | `int32` | singular | — |
| `phase` | `phase` | `int32` | singular | — |
| `severity` | `severity` | `string` | singular | — |

**Response** — `tiyi.v1.ListCrsRulesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CrsRule`](#crsrule) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### CrsService.GetCrsRule

- **Procedure** `POST /tiyi.v1.CrsService/GetCrsRule`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetCrsRuleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset_id` | `rulesetId` | `string` | singular | — |
| `rule_id` | `ruleId` | `string` | singular | — |

**Response** — `tiyi.v1.GetCrsRuleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule` | `rule` | [`CrsRule`](#crsrule) | singular | — |

### CrsService.ListCrsCategories

- **Procedure** `POST /tiyi.v1.CrsService/ListCrsCategories`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCrsCategoriesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset_id` | `rulesetId` | `string` | singular | — |

**Response** — `tiyi.v1.ListCrsCategoriesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `categories` | `categories` | [`CrsCategory`](#crscategory) | repeated | — |

### CrsService.ListCrsTags

- **Procedure** `POST /tiyi.v1.CrsService/ListCrsTags`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCrsTagsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset_id` | `rulesetId` | `string` | singular | — |

**Response** — `tiyi.v1.ListCrsTagsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `tags` | `tags` | [`CrsTag`](#crstag) | repeated | — |

### CrsService.ListCrsPlugins

- **Procedure** `POST /tiyi.v1.CrsService/ListCrsPlugins`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCrsPluginsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset_id` | `rulesetId` | `string` | singular | — |

**Response** — `tiyi.v1.ListCrsPluginsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `plugins` | `plugins` | [`CrsPlugin`](#crsplugin) | repeated | — |

### CrsService.GetCrsPluginConfigSchema

- **Procedure** `POST /tiyi.v1.CrsService/GetCrsPluginConfigSchema`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetCrsPluginConfigSchemaRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `plugin_id` | `pluginId` | `string` | singular | — |

**Response** — `tiyi.v1.GetCrsPluginConfigSchemaResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `schema` | `schema` | `google.protobuf.Struct` | singular | _free-form JSON object._ |

### CrsService.ListCrsExclusionPlugins

CRS rule-exclusion package catalog and bindings. See WAF_POLICY_DESIGN.md § 1.3 and CRS docs § 2-3 "Rule Exclusion Packages".

- **Procedure** `POST /tiyi.v1.CrsService/ListCrsExclusionPlugins`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListCrsExclusionPluginsRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ListCrsExclusionPluginsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CrsExclusionPlugin`](#crsexclusionplugin) | repeated | — |

### CrsService.GetCrsExclusionPlugin

- **Procedure** `POST /tiyi.v1.CrsService/GetCrsExclusionPlugin`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.GetCrsExclusionPluginRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id_or_slug` | `idOrSlug` | `string` | singular | Accepts either id or slug. |

**Response** — `tiyi.v1.GetCrsExclusionPluginResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `plugin` | `plugin` | [`CrsExclusionPlugin`](#crsexclusionplugin) | singular | — |

### CrsService.ImportCrsExclusionPlugin

- **Procedure** `POST /tiyi.v1.CrsService/ImportCrsExclusionPlugin`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.ImportCrsExclusionPluginRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id_or_slug` | `idOrSlug` | `string` | singular | Plugin id or slug identifying which catalog row to populate. |
| `github_tag` | `githubTag` | `string` | singular | When set, fetch from github.com/coreruleset/<slug>-rule-exclusions-plugin at this release tag. Takes precedence over archive when both are set. |
| `archive` | `archive` | `bytes` | singular | Alternatively, the archive bytes (tar.gz or zip) for offline installs where the server has no outbound internet access. _base64-encoded JSON string._ |

**Response** — `tiyi.v1.ImportCrsExclusionPluginResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `plugin` | `plugin` | [`CrsExclusionPlugin`](#crsexclusionplugin) | singular | — |

### CrsService.ListUpstreamCrsExclusionPluginReleases

- **Procedure** `POST /tiyi.v1.CrsService/ListUpstreamCrsExclusionPluginReleases`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.ListUpstreamCrsExclusionPluginReleasesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `slug` | `slug` | `string` | singular | — |
| `limit` | `limit` | `int32` | singular | — |
| `include_prerelease` | `includePrerelease` | `bool` | singular | — |

**Response** — `tiyi.v1.ListUpstreamCrsExclusionPluginReleasesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `releases` | `releases` | [`UpstreamCrsExclusionPluginRelease`](#upstreamcrsexclusionpluginrelease) | repeated | — |

### CrsService.ListPolicyExclusionPlugins

- **Procedure** `POST /tiyi.v1.CrsService/ListPolicyExclusionPlugins`
- **Kind** unary
- **Auth** (`policy:read`)

**Request** — `tiyi.v1.ListPolicyExclusionPluginsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `policy_id` | `policyId` | `string` | singular | — |

**Response** — `tiyi.v1.ListPolicyExclusionPluginsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`PolicyCrsExclusionPlugin`](#policycrsexclusionplugin) | repeated | — |

### CrsService.UpsertPolicyExclusionPlugin

- **Procedure** `POST /tiyi.v1.CrsService/UpsertPolicyExclusionPlugin`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.UpsertPolicyExclusionPluginRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `binding` | `binding` | [`PolicyCrsExclusionPlugin`](#policycrsexclusionplugin) | singular | — |

**Response** — `tiyi.v1.UpsertPolicyExclusionPluginResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `binding` | `binding` | [`PolicyCrsExclusionPlugin`](#policycrsexclusionplugin) | singular | — |

### CrsService.DeletePolicyExclusionPlugin

- **Procedure** `POST /tiyi.v1.CrsService/DeletePolicyExclusionPlugin`
- **Kind** unary
- **Auth** (`policy:write`)

**Request** — `tiyi.v1.DeletePolicyExclusionPluginRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeletePolicyExclusionPluginResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

## Messages

### CountryAccessRule

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `country_codes` | `countryCodes` | `string` | repeated | canonical ISO 3166-1 alpha-2 |
| `kind` | `kind` | `string` | singular | allow \| deny \| monitor |
| `bypass_mode` | `bypassMode` | `string` | singular | all_waf \| ip_lists_only |
| `address_source` | `addressSource` | `string` | singular | client_ip \| peer_ip |
| `match_mode` | `matchMode` | `string` | singular | in_list \| not_in_list |
| `enabled` | `enabled` | `bool` | singular | — |
| `sort_order` | `sortOrder` | `int32` | singular | — |
| `etag` | `etag` | `string` | singular | required on update |
| `targets` | `targets` | [`CountryAccessTarget`](#countryaccesstarget) | repeated | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### CountryAccessTarget

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `scope` | `scope` | `string` | singular | global \| policy \| site |
| `policy_id` | `policyId` | `string` | singular | — |
| `policy_name` | `policyName` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `site_name` | `siteName` | `string` | singular | — |

### CountryCatalog

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `available` | `available` | `bool` | singular | — |
| `dataset_version` | `datasetVersion` | `string` | singular | — |
| `dataset_source` | `datasetSource` | `string` | singular | — |
| `dataset_sha256` | `datasetSha256` | `string` | singular | — |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `countries` | `countries` | [`CountryCatalogEntry`](#countrycatalogentry) | repeated | — |
| `activation_status` | `activationStatus` | `string` | singular | — |
| `last_activation_error` | `lastActivationError` | `string` | singular | — |
| `activated_at` | `activatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### CountryCatalogEntry

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `code` | `code` | `string` | singular | — |
| `prefix_count` | `prefixCount` | `int32` | singular | — |

### CrsCategory

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `code` | `code` | `string` | singular | — |
| `label` | `label` | `string` | singular | — |
| `rule_count` | `ruleCount` | `int32` | singular | — |

### CrsExclusionPlugin

CrsExclusionPlugin is a single curated rule-exclusion-package row in the tenant-wide catalog. Slugs identify upstream packages for common web applications (WordPress, Drupal, Nextcloud, …). The compiler uses each package's tx.<slug>-rule-exclusions-plugin_enabled gate for path scoping.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `slug` | `slug` | `string` | singular | — |
| `display_name` | `displayName` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `homepage_url` | `homepageUrl` | `string` | singular | — |
| `repo_url` | `repoUrl` | `string` | singular | — |
| `tx_variable` | `txVariable` | `string` | singular | — |
| `installed` | `installed` | `bool` | singular | — |
| `source` | `source` | `string` | singular | "github:<tag>" or "uploaded" |
| `source_version` | `sourceVersion` | `string` | singular | — |
| `artifact_path` | `artifactPath` | `string` | singular | — |
| `curated` | `curated` | `bool` | singular | — |
| `imported_at` | `importedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### CrsPlugin

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `ruleset_id` | `rulesetId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `config_schema` | `configSchema` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `version` | `version` | `string` | singular | — |
| `files` | `files` | `string` | repeated | — |
| `curated` | `curated` | `bool` | singular | — |
| `has_before` | `hasBefore` | `bool` | singular | — |
| `has_after` | `hasAfter` | `bool` | singular | — |
| `has_config` | `hasConfig` | `bool` | singular | — |

### CrsRule

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `rule_id` | `ruleId` | `int32` | singular | — |
| `file` | `file` | `string` | singular | — |
| `category` | `category` | `string` | singular | — |
| `category_label` | `categoryLabel` | `string` | singular | — |
| `paranoia_level` | `paranoiaLevel` | `int32` | singular | — |
| `severity` | `severity` | `string` | singular | — |
| `default_action` | `defaultAction` | `string` | singular | — |
| `default_score` | `defaultScore` | `int32` | singular | — |
| `msg` | `msg` | `string` | singular | — |
| `tags` | `tags` | `string` | repeated | — |
| `phase` | `phase` | `int32` | singular | — |
| `is_initialization` | `isInitialization` | `bool` | singular | — |
| `is_evaluation` | `isEvaluation` | `bool` | singular | — |
| `rule_kind` | `ruleKind` | `string` | singular | — |
| `score_variable` | `scoreVariable` | `string` | singular | — |
| `raw_sha256` | `rawSha256` | `string` | singular | — |
| `score_expression` | `scoreExpression` | `string` | singular | — |
| `line` | `line` | `int32` | singular | — |
| `targets` | `targets` | `string` | repeated | — |
| `operator` | `operator` | `string` | singular | — |
| `transform_chain` | `transformChain` | `string` | singular | — |
| `ruleset_id` | `rulesetId` | `string` | singular | — |
| `raw` | `raw` | `string` | singular | Exact SecLang directive as imported, including original line continuations. Populated by GetCrsRule; list responses omit it to keep catalog pages small. |

### CrsRuleset

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `version` | `version` | `string` | singular | — |
| `source` | `source` | `string` | singular | vendor \| uploaded |
| `status` | `status` | [`ResourceStatus`](common.md#resourcestatus) | singular | — |
| `fingerprint` | `fingerprint` | `string` | singular | — |
| `rule_count` | `ruleCount` | `int32` | singular | — |
| `plugin_count` | `pluginCount` | `int32` | singular | — |
| `ingested_at` | `ingestedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `activated_at` | `activatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `crs_setup_version` | `crsSetupVersion` | `string` | singular | — |
| `rule_file_count` | `ruleFileCount` | `int32` | singular | — |

### CrsTag

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `tag` | `tag` | `string` | singular | — |
| `rule_count` | `ruleCount` | `int32` | singular | — |

### CustomRule

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `rule_id` | `ruleId` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `phase` | `phase` | `int32` | singular | — |
| `sort_order` | `sortOrder` | `int32` | singular | — |
| `enabled` | `enabled` | `bool` | optional (explicit) | Presence is required on the JSON wire so an explicit disabled state is distinct from an invalid write that omitted the operator's choice. |
| `seclang` | `seclang` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `site_id` | `siteId` | `string` | singular | Optional site id. When empty the rule is policy-wide; when set it only runs when the matching site is being compiled. WAF_POLICY_DESIGN § 3.2. |
| `placement` | `placement` | `string` | singular | "before_crs" \| "after_crs" \| "request_before_blocking" \| "response_before_blocking". |
| `visual_spec` | `visualSpec` | `google.protobuf.Struct` | singular | Optional visual-builder spec. When set the server compiles this into SecLang; when absent the `seclang` field is treated as raw. See internal/waf/visualrule for the schema. _free-form JSON object._ |

### CustomRuleTemplate

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `defaults` | `defaults` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `category` | `category` | `string` | singular | Grouping key for the catalog card: access \| observability \| privacy \| … |
| `builtin` | `builtin` | `bool` | singular | True for builtin/seeded recipes; false for tenant-authored ones. |

### IpList

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `entries` | `entries` | [`IpListEntry`](#iplistentry) | repeated | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `deleted_at` | `deletedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `global_ref_count` | `globalRefCount` | `int32` | singular | — |
| `policy_ref_count` | `policyRefCount` | `int32` | singular | — |
| `site_ref_count` | `siteRefCount` | `int32` | singular | — |
| `management_mode` | `managementMode` | `string` | singular | manual \| subscription |
| `etag` | `etag` | `string` | singular | opaque concurrency token; required by UpdateIpList |
| `entry_count` | `entryCount` | `int32` | singular | — |
| `ipv4_count` | `ipv4Count` | `int32` | singular | — |
| `ipv6_count` | `ipv6Count` | `int32` | singular | — |
| `content_status` | `contentStatus` | `string` | singular | available \| empty |
| `deployment_status` | `deploymentStatus` | `string` | singular | not_in_use \| config_pending \| config_applying \| config_failed \| config_receipts_complete \| unverified |
| `source` | `source` | [`IpListSource`](#iplistsource) | singular | — |
| `sync_status` | `syncStatus` | [`IpListSyncStatus`](#iplistsyncstatus) | singular | — |
| `held_update` | `heldUpdate` | [`IpListHeldUpdate`](#iplistheldupdate) | singular | — |
| `reference_preview` | `referencePreview` | [`IpListReference`](#iplistreference) | repeated | First two effective references, ordered exactly like ListIpListReferences. The catalog uses this bounded preview to show action + scope without hydrating every relationship for every row. |
| `deployment` | `deployment` | [`IpListDeployment`](#iplistdeployment) | singular | Exact list identity and required node receipts; hydrated by List/Get. |

### IpListApplyTarget

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `scope` | `scope` | `string` | singular | "global" \| "policy" \| "site". |
| `policy_id` | `policyId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |

### IpListBindingRecord

IpListBindingRecord is the sole authored enforcement use of an IP list. The list owns addresses only; this record owns identity, membership and action semantics.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `ip_list_name` | `ipListName` | `string` | singular | Cached IP list name for display; set by the server on reads. |
| `kind` | `kind` | `string` | singular | "allow" \| "deny" \| "monitor". |
| `sort_order` | `sortOrder` | `int32` | singular | — |
| `path_prefix` | `pathPrefix` | `string` | singular | Scope the binding to requests whose URI begins with this prefix. Empty = applies to every request the policy sees. |
| `site_id` | `siteId` | `string` | singular | Optional site id. Empty = policy-wide binding; set = site-scoped extra that only runs when the matching site is compiled. |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `bypass_mode` | `bypassMode` | `string` | singular | "all_waf" (bypass the complete WAF) or "ip_lists_only". |
| `scope` | `scope` | `string` | singular | "global" \| "policy" \| "site"; set by the server on reads. |
| `address_source` | `addressSource` | `string` | singular | required: client_ip \| peer_ip |
| `match_mode` | `matchMode` | `string` | singular | required: in_list \| not_in_list |

### IpListDeployment

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `revision_id` | `revisionId` | `string` | singular | — |
| `content_digest` | `contentDigest` | `string` | singular | — |
| `site_ids` | `siteIds` | `string` | repeated | — |
| `targets` | `targets` | [`IpListDeploymentTarget`](#iplistdeploymenttarget) | repeated | — |

### IpListDeploymentTarget

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | — |
| `id` | `id` | `string` | singular | — |
| `status` | `status` | `string` | singular | — |
| `applied_at` | `appliedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `last_error` | `lastError` | `string` | singular | — |

### IpListEntry

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `value` | `value` | `string` | singular | — |
| `note` | `note` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### IpListHeldUpdate

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `reason` | `reason` | `string` | singular | — |
| `entry_count` | `entryCount` | `int32` | singular | — |
| `ipv4_count` | `ipv4Count` | `int32` | singular | — |
| `ipv6_count` | `ipv6Count` | `int32` | singular | — |
| `added_count` | `addedCount` | `int32` | singular | — |
| `removed_count` | `removedCount` | `int32` | singular | — |
| `added_samples` | `addedSamples` | `string` | repeated | — |
| `removed_samples` | `removedSamples` | `string` | repeated | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### IpListReference

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `scope` | `scope` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `policy_name` | `policyName` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `site_name` | `siteName` | `string` | singular | — |
| `binding_id` | `bindingId` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `bypass_mode` | `bypassMode` | `string` | singular | — |
| `role` | `role` | `string` | singular | access_control \| trusted_proxy_peer \| rule_operand \| bot_trusted_client |
| `address_source` | `addressSource` | `string` | singular | — |
| `match_mode` | `matchMode` | `string` | singular | — |
| `custom_rule_id` | `customRuleId` | `string` | singular | — |
| `custom_rule_name` | `customRuleName` | `string` | singular | — |
| `trust_node_id` | `trustNodeId` | `string` | singular | — |
| `trust_node_name` | `trustNodeName` | `string` | singular | — |

### IpListRollout

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `status` | `status` | `string` | singular | — |
| `affected_consumers` | `affectedConsumers` | `int32` | singular | — |
| `updated_targets` | `updatedTargets` | `int32` | singular | — |
| `failed_targets` | `failedTargets` | `int32` | singular | — |

### IpListScopeHit

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `scope` | `scope` | `string` | singular | — |
| `ip_list_id` | `ipListId` | `string` | singular | — |
| `ip_list_name` | `ipListName` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `policy_name` | `policyName` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `site_name` | `siteName` | `string` | singular | — |
| `kind` | `kind` | `string` | singular | — |
| `bypass_mode` | `bypassMode` | `string` | singular | — |
| `entries` | `entries` | [`IpListEntry`](#iplistentry) | repeated | — |
| `binding_id` | `bindingId` | `string` | singular | — |
| `address_source` | `addressSource` | `string` | singular | — |
| `match_mode` | `matchMode` | `string` | singular | — |
| `path_prefix` | `pathPrefix` | `string` | singular | — |

### IpListSource

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `url` | `url` | `string` | singular | query values are redacted on every read |
| `format` | `format` | `string` | singular | — |
| `json_paths` | `jsonPaths` | `string` | repeated | RFC 9535; every expression must select strings |
| `interval` | `interval` | `google.protobuf.Duration` | singular | _seconds string, e.g. `30s`._ |
| `paused` | `paused` | `bool` | singular | — |
| `min_entries` | `minEntries` | `int32` | singular | — |
| `max_entries` | `maxEntries` | `int32` | singular | — |
| `max_delete_ratio` | `maxDeleteRatio` | `double` | singular | — |
| `generation` | `generation` | `int64` | singular | internal CAS input; UI must not display it _JSON string (64-bit ints are quoted)._ |
| `headers` | `headers` | [`IpListSourceHeader`](#iplistsourceheader) | repeated | — |

### IpListSourceHeader

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `configured` | `configured` | `bool` | singular | — |

### IpListSourceHeaderMutation

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `keep_existing` | `keepExisting` | `bool` | singular | Part of oneof `operation`. |
| `replace_secret` | `replaceSecret` | `string` | singular | Part of oneof `operation`. |
| `delete` | `delete` | `bool` | singular | Part of oneof `operation`. |

### IpListSourceInput

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `url` | `url` | `string` | singular | — |
| `format` | `format` | `string` | singular | — |
| `json_paths` | `jsonPaths` | `string` | repeated | RFC 9535; 1-8 expressions for json_v1 |
| `interval` | `interval` | `google.protobuf.Duration` | singular | _seconds string, e.g. `30s`._ |
| `paused` | `paused` | `bool` | singular | — |
| `min_entries` | `minEntries` | `int32` | singular | — |
| `max_entries` | `maxEntries` | `int32` | singular | — |
| `max_delete_ratio` | `maxDeleteRatio` | `double` | singular | — |
| `headers` | `headers` | [`IpListSourceHeaderMutation`](#iplistsourceheadermutation) | repeated | — |

### IpListSyncRun

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `trigger` | `trigger` | `string` | singular | — |
| `status` | `status` | `string` | singular | — |
| `result_code` | `resultCode` | `string` | singular | — |
| `error` | `error` | `string` | singular | — |
| `http_status` | `httpStatus` | `int32` | singular | — |
| `entry_count` | `entryCount` | `int32` | singular | — |
| `ipv4_count` | `ipv4Count` | `int32` | singular | — |
| `ipv6_count` | `ipv6Count` | `int32` | singular | — |
| `added_count` | `addedCount` | `int32` | singular | — |
| `removed_count` | `removedCount` | `int32` | singular | — |
| `started_at` | `startedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `finished_at` | `finishedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### IpListSyncStatus

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `status` | `status` | `string` | singular | never_synced \| healthy \| syncing \| held \| failed \| paused |
| `result_code` | `resultCode` | `string` | singular | — |
| `last_error` | `lastError` | `string` | singular | — |
| `last_attempt_at` | `lastAttemptAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `last_success_at` | `lastSuccessAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `next_sync_at` | `nextSyncAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `consecutive_failures` | `consecutiveFailures` | `int32` | singular | — |

### PolicyCrsExclusionPlugin

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `plugin_id` | `pluginId` | `string` | singular | — |
| `plugin_slug` | `pluginSlug` | `string` | singular | — |
| `tx_variable` | `txVariable` | `string` | singular | — |
| `enabled` | `enabled` | `bool` | singular | — |
| `path_prefix` | `pathPrefix` | `string` | singular | Optional URI prefix. Empty = applies to every request the policy sees; non-empty = emits a phase-1 @beginsWith SecRule so the CRS exclusion variable only flips on for that path. |
| `sort_order` | `sortOrder` | `int32` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### RateLimitEndpointRecord

RateLimitEndpointRecord is one canonical rolling-window rule. Policy-wide rows are reusable defaults; site rows override an inherited rule with the same path + HTTP-method signature.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | Optional site id. Empty = policy-wide rule; set = site-scoped overlay that only runs when the matching site is compiled. There is no scalar rate-limit policy layer. |
| `path_pattern` | `pathPattern` | `string` | singular | — |
| `method_mode` | `methodMode` | `string` | singular | Explicit method contract: "any" ignores methods; "include" requires at least one canonical HTTP token in methods. Empty never means ANY. |
| `methods` | `methods` | `string` | repeated | — |
| `action` | `action` | `string` | singular | "block" affects only matching requests; "ban" rejects every request from the resolved IP in ban_scope; "challenge" runs the browser-check flow. |
| `sort_order` | `sortOrder` | `int32` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `enforcement_mode` | `enforcementMode` | `string` | singular | Observation is a rule mode, never an action. "observe" records the exact would-enforce decision without interrupting traffic; "enforce" applies it. |
| `verified_request_count` | `verifiedRequestCount` | `int32` | singular | Resolved browser-check values. For comfort/standard/strict the server derives and canonicalizes these from request_count/window_seconds. They are caller-controlled only when challenge_profile is custom. |
| `verified_window_seconds` | `verifiedWindowSeconds` | `int32` | singular | — |
| `challenge_ttl_seconds` | `challengeTtlSeconds` | `int32` | singular | — |
| `clearance_ttl_seconds` | `clearanceTtlSeconds` | `int32` | singular | — |
| `proof_difficulty` | `proofDifficulty` | `int32` | singular | — |
| `bind_network` | `bindNetwork` | `bool` | singular | — |
| `counting_key` | `countingKey` | `string` | singular | Per-client identity: "ip" \| "session" \| "header:<name>". |
| `request_count` | `requestCount` | `int32` | singular | Allow N requests in the T-second rolling window; request N+1 starts the fixed action episode. |
| `window_seconds` | `windowSeconds` | `int32` | singular | — |
| `mitigation_seconds` | `mitigationSeconds` | `int32` | singular | How long a newly-triggered block/ban/challenge episode remains active. Blocked requests do not extend this TTL. |
| `ban_scope` | `banScope` | `string` | singular | Required only for action=ban: "site" \| "global". Global means every site in this tenant, not every tenant on the node. |
| `challenge_profile` | `challengeProfile` | `string` | singular | Required only for action=challenge: "comfort" \| "standard" \| "strict" \| "custom". A preset is the sole operator intent; conflicting raw values are ignored and re-derived. |

### RuleOverride

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `policy_id` | `policyId` | `string` | singular | — |
| `crs_rule_id` | `crsRuleId` | `string` | singular | — |
| `removed_targets` | `removedTargets` | `string` | repeated | — |
| `added_targets` | `addedTargets` | `string` | repeated | — |
| `tags` | `tags` | `string` | repeated | — |
| `rationale` | `rationale` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `site_id` | `siteId` | `string` | singular | Optional site id. When empty the override is policy-wide (applies to every site that attaches the policy); when set, it only runs when the matching site is being compiled. WAF_POLICY_DESIGN § 3.2. |
| `scope` | `scope` | `string` | singular | Optional path prefix (`@beginsWith`). When set the override is scoped to requests whose URI starts with this string. CRS docs § 2-3 Example 5. |
| `score_override` | `scoreOverride` | `int32` | optional (explicit) | Optional explicit score override (PR 3). proto3 `optional` gives presence tracking so the operator can set 0 to suppress the rule's anomaly contribution entirely (defect C5). When unset and `action_enum != SCORE_OVERRIDE`, the rule's default contribution stays untouched. |
| `action_enum` | `actionEnum` | [`RuleOverrideAction`](#ruleoverrideaction) | singular | Required canonical action verb. |

### UpstreamCrsExclusionPluginRelease

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `slug` | `slug` | `string` | singular | — |
| `tag` | `tag` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `published_at` | `publishedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `prerelease` | `prerelease` | `bool` | singular | — |
| `draft` | `draft` | `bool` | singular | — |
| `body` | `body` | `string` | singular | — |

## Enums

### RuleOverrideAction

RuleOverrideAction is the canonical operator-visible verb for a CRS override. UNSPECIFIED is invalid on writes; DEFAULT explicitly leaves the rule action unchanged for target or scope-only overrides.

| Value | Number | Description |
|---|---|---|
| `RULE_OVERRIDE_ACTION_UNSPECIFIED` | 0 | — |
| `RULE_OVERRIDE_ACTION_DEFAULT` | 1 | — |
| `RULE_OVERRIDE_ACTION_DISABLE` | 2 | — |
| `RULE_OVERRIDE_ACTION_LOG_ONLY` | 3 | — |
| `RULE_OVERRIDE_ACTION_SCORE_OVERRIDE` | 4 | — |
