<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# system.proto — System settings, health, dashboards, updates, and declarative apply

Schema: `tiyi.v1` · `system.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### SystemService

| RPC | Kind | Required permission |
|---|---|---|
| [`Health`](#systemservicehealth) | unary | (`system:read`) |
| [`Version`](#systemserviceversion) | unary | authenticated |
| [`GetSystemSettings`](#systemservicegetsystemsettings) | unary | (`system:read`) |
| [`UpdateSystemSettings`](#systemserviceupdatesystemsettings) | unary | (`system:write`) |
| [`ImportLicense`](#systemserviceimportlicense) | unary | (`system:write`) |
| [`GetDashboardStats`](#systemservicegetdashboardstats) | unary | (`site:read`) |
| [`GetDashboardOverview`](#systemservicegetdashboardoverview) | unary | `site:read` and `telemetry:read` |
| [`GetTrafficTimeseries`](#systemservicegettraffictimeseries) | unary | (`site:read`) |
| [`GetAttackDistribution`](#systemservicegetattackdistribution) | unary | (`site:read`) |
| [`GetTopAttackers`](#systemservicegettopattackers) | unary | (`site:read`) |
| [`PreviewApply`](#systemservicepreviewapply) | unary | (`system:apply`) |
| [`Apply`](#systemserviceapply) | unary | (`system:apply`) |
| [`ListBinaryReleases`](#systemservicelistbinaryreleases) | unary | (`system:update:read`) |
| [`GetBinaryRelease`](#systemservicegetbinaryrelease) | unary | (`system:update:read`) |
| [`ImportBinaryRelease`](#systemserviceimportbinaryrelease) | unary | (`system:update:write`) |
| [`DeleteBinaryRelease`](#systemservicedeletebinaryrelease) | unary | (`system:update:write`) |
| [`ApplyBinaryRelease`](#systemserviceapplybinaryrelease) | unary | (`system:update:apply`) |
| [`RollbackBinaryRelease`](#systemservicerollbackbinaryrelease) | unary | (`system:update:apply`) |
| [`ListSystemCrsRulesets`](#systemservicelistsystemcrsrulesets) | unary | (`system:update:read`) |
| [`GetSystemCrsRuleset`](#systemservicegetsystemcrsruleset) | unary | (`system:update:read`) |
| [`ImportCrsRuleset`](#systemserviceimportcrsruleset) | unary | (`system:update:write`) |
| [`DeleteCrsRuleset`](#systemservicedeletecrsruleset) | unary | (`system:update:write`) |
| [`ListUpgradeRuns`](#systemservicelistupgraderuns) | unary | (`system:update:read`) |
| [`GetUpgradeRun`](#systemservicegetupgraderun) | unary | (`system:update:read`) |
| [`StreamUpgradeRun`](#systemservicestreamupgraderun) | server stream | (`system:update:read`) |
| [`CancelUpgradeRun`](#systemservicecancelupgraderun) | unary | (`system:update:apply`) |
| [`CheckForUpdates`](#systemservicecheckforupdates) | unary | (`system:update:read`) |
| [`ListUpstreamCrsReleases`](#systemservicelistupstreamcrsreleases) | unary | (`system:update:read`) |
| [`GetObservationPipelineStats`](#systemservicegetobservationpipelinestats) | unary | (`system:read`) |
| [`ListGeoDatabases`](#systemservicelistgeodatabases) | unary | (`system:update:read`) |
| [`DownloadGeoDatabase`](#systemservicedownloadgeodatabase) | unary | (`system:update:write`) |
| [`UploadGeoDatabase`](#systemserviceuploadgeodatabase) | unary | (`system:update:write`) |
| [`DeleteGeoDatabase`](#systemservicedeletegeodatabase) | unary | (`system:update:write`) |

## RPCs

### SystemService.Health

- **Procedure** `POST /tiyi.v1.SystemService/Health`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.HealthRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.HealthResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `status` | `status` | `string` | singular | — |
| `version` | `version` | `string` | singular | — |
| `controller_id` | `controllerId` | `string` | singular | — |
| `deployment_id` | `deploymentId` | `string` | singular | — |
| `checks` | `checks` | [`SystemHealthCheck`](#systemhealthcheck) | repeated | — |
| `checked_at` | `checkedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `config_revision` | `configRevision` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `active_sites` | `activeSites` | `int32` | singular | — |
| `remote_agents_connected` | `remoteAgentsConnected` | `int32` | singular | — |

### SystemService.Version

- **Procedure** `POST /tiyi.v1.SystemService/Version`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.VersionRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.VersionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `build` | `build` | [`BuildInfo`](common.md#buildinfo) | singular | — |
| `license` | `license` | [`LicenseStatus`](#licensestatus) | singular | LICENSE-GATE |

### SystemService.GetSystemSettings

- **Procedure** `POST /tiyi.v1.SystemService/GetSystemSettings`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.GetSystemSettingsRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetSystemSettingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `settings` | `settings` | [`SystemSettings`](#systemsettings) | singular | — |

### SystemService.UpdateSystemSettings

- **Procedure** `POST /tiyi.v1.SystemService/UpdateSystemSettings`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.UpdateSystemSettingsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `values` | `values` | `google.protobuf.Struct` | singular | _free-form JSON object._ |

**Response** — `tiyi.v1.UpdateSystemSettingsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `settings` | `settings` | [`SystemSettings`](#systemsettings) | singular | — |
| `application` | `application` | `string` | singular | The settings have committed. Application is separate from persistence. |
| `apply_error` | `applyError` | `string` | singular | — |

### SystemService.ImportLicense

LICENSE-GATE

- **Procedure** `POST /tiyi.v1.SystemService/ImportLicense`
- **Kind** unary
- **Auth** (`system:write`)

**Request** — `tiyi.v1.ImportLicenseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `license` | `license` | `bytes` | singular | raw bytes of the signed license file. _base64-encoded JSON string._ |

**Response** — `tiyi.v1.ImportLicenseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `status` | `status` | [`LicenseStatus`](#licensestatus) | singular | the resulting (verified, possibly expired) status. |

### SystemService.GetDashboardStats

- **Procedure** `POST /tiyi.v1.SystemService/GetDashboardStats`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetDashboardStatsRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetDashboardStatsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `stats` | `stats` | [`DashboardStats`](#dashboardstats) | singular | — |

### SystemService.GetDashboardOverview

Returns the complete dashboard read model in one bounded request. The richer telemetry rankings require both site and telemetry visibility.

- **Procedure** `POST /tiyi.v1.SystemService/GetDashboardOverview`
- **Kind** unary
- **Auth** `site:read` and `telemetry:read`

**Request** — `tiyi.v1.GetDashboardOverviewRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `bucket_size` | `bucketSize` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |
| `top_k_limit` | `topKLimit` | `int32` | singular | Applies to every ranking. The server defaults to 10 and caps at 100. |

**Response** — `tiyi.v1.GetDashboardOverviewResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | Actual immutable snapshot scope, including when a cached response is served. |
| `traffic_bucket_seconds` | `trafficBucketSeconds` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `stats` | `stats` | [`DashboardStats`](#dashboardstats) | singular | — |
| `traffic` | `traffic` | [`TrafficPoint`](#trafficpoint) | repeated | — |
| `attack_distribution` | `attackDistribution` | [`AttackDistributionItem`](#attackdistributionitem) | repeated | — |
| `top_attackers` | `topAttackers` | [`TopAttacker`](#topattacker) | repeated | — |
| `top_statuses` | `topStatuses` | [`DashboardTopK`](#dashboardtopk) | singular | — |
| `top_paths` | `topPaths` | [`DashboardTopK`](#dashboardtopk) | singular | — |
| `top_user_agents` | `topUserAgents` | [`DashboardTopK`](#dashboardtopk) | singular | — |
| `top_sites` | `topSites` | [`DashboardTopSite`](#dashboardtopsite) | repeated | Empty for a site-scoped request: ranking one selected site against itself is not useful and preserving this distinction avoids a semantic surprise when the operator changes the dashboard site selector. |
| `other_sites_total` | `otherSitesTotal` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `security_top_attackers` | `securityTopAttackers` | [`DashboardSecurityTopK`](#dashboardsecuritytopk) | singular | SecurityFact-derived rankings. These are separate from the all-traffic top_paths/top_sites fields above so their semantics cannot be confused. |
| `security_top_sites` | `securityTopSites` | [`DashboardSecurityTopK`](#dashboardsecuritytopk) | singular | — |
| `security_top_targets` | `securityTopTargets` | [`DashboardSecurityTopK`](#dashboardsecuritytopk) | singular | — |
| `security_top_attack_types` | `securityTopAttackTypes` | [`DashboardSecurityTopK`](#dashboardsecuritytopk) | singular | — |
| `security_top_rules` | `securityTopRules` | [`DashboardSecurityTopK`](#dashboardsecuritytopk) | singular | — |
| `security_top_methods` | `securityTopMethods` | [`DashboardSecurityTopK`](#dashboardsecuritytopk) | singular | — |
| `freshness` | `freshness` | [`DashboardFreshness`](#dashboardfreshness) | singular | — |
| `traffic_quality` | `trafficQuality` | [`DashboardTrafficQuality`](#dashboardtrafficquality) | singular | — |
| `top_methods` | `topMethods` | [`DashboardTopK`](#dashboardtopk) | singular | — |
| `top_http_versions` | `topHttpVersions` | [`DashboardTopK`](#dashboardtopk) | singular | — |
| `top_transport_versions` | `topTransportVersions` | [`DashboardTopK`](#dashboardtopk) | singular | — |
| `security_top_countries` | `securityTopCountries` | [`DashboardSecurityTopK`](#dashboardsecuritytopk) | singular | Country distribution derived from the bounded attacker heavy-hitter set. other_count includes attackers outside that set and IPs that cannot be resolved by the currently installed Country database. |

### SystemService.GetTrafficTimeseries

- **Procedure** `POST /tiyi.v1.SystemService/GetTrafficTimeseries`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetTrafficTimeseriesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `bucket_size` | `bucketSize` | `string` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetTrafficTimeseriesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `points` | `points` | [`TrafficPoint`](#trafficpoint) | repeated | — |

### SystemService.GetAttackDistribution

- **Procedure** `POST /tiyi.v1.SystemService/GetAttackDistribution`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetAttackDistributionRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `limit` | `limit` | `int32` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetAttackDistributionResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`AttackDistributionItem`](#attackdistributionitem) | repeated | — |

### SystemService.GetTopAttackers

- **Procedure** `POST /tiyi.v1.SystemService/GetTopAttackers`
- **Kind** unary
- **Auth** (`site:read`)

**Request** — `tiyi.v1.GetTopAttackersRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `time_range` | `timeRange` | [`TimeRange`](common.md#timerange) | singular | — |
| `limit` | `limit` | `int32` | singular | — |
| `site_id` | `siteId` | `string` | singular | — |

**Response** — `tiyi.v1.GetTopAttackersResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`TopAttacker`](#topattacker) | repeated | — |

### SystemService.PreviewApply

- **Procedure** `POST /tiyi.v1.SystemService/PreviewApply`
- **Kind** unary
- **Auth** (`system:apply`)

**Request** — `tiyi.v1.PreviewApplyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `manifest_yaml` | `manifestYaml` | `bytes` | singular | _base64-encoded JSON string._ |

**Response** — `tiyi.v1.PreviewApplyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `plan` | `plan` | [`ApplyPlan`](#applyplan) | singular | — |

### SystemService.Apply

- **Procedure** `POST /tiyi.v1.SystemService/Apply`
- **Kind** unary
- **Auth** (`system:apply`)

**Request** — `tiyi.v1.ApplyRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `manifest_yaml` | `manifestYaml` | `bytes` | singular | _base64-encoded JSON string._ |
| `dry_run` | `dryRun` | `bool` | singular | — |

**Response** — `tiyi.v1.ApplyResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `plan` | `plan` | [`ApplyPlan`](#applyplan) | singular | — |
| `results` | `results` | [`MutationResult`](common.md#mutationresult) | repeated | — |

### SystemService.ListBinaryReleases

- **Procedure** `POST /tiyi.v1.SystemService/ListBinaryReleases`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.ListBinaryReleasesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListBinaryReleasesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`BinaryRelease`](#binaryrelease) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### SystemService.GetBinaryRelease

- **Procedure** `POST /tiyi.v1.SystemService/GetBinaryRelease`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.GetBinaryReleaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetBinaryReleaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `release` | `release` | [`BinaryRelease`](#binaryrelease) | singular | — |

### SystemService.ImportBinaryRelease

- **Procedure** `POST /tiyi.v1.SystemService/ImportBinaryRelease`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.ImportBinaryReleaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `tarball` | `tarball` | `bytes` | singular | _base64-encoded JSON string._ |
| `source_url` | `sourceUrl` | `string` | singular | — |

**Response** — `tiyi.v1.ImportBinaryReleaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `release` | `release` | [`BinaryRelease`](#binaryrelease) | singular | — |

### SystemService.DeleteBinaryRelease

- **Procedure** `POST /tiyi.v1.SystemService/DeleteBinaryRelease`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.DeleteBinaryReleaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteBinaryReleaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### SystemService.ApplyBinaryRelease

- **Procedure** `POST /tiyi.v1.SystemService/ApplyBinaryRelease`
- **Kind** unary
- **Auth** (`system:update:apply`)

**Request** — `tiyi.v1.ApplyBinaryReleaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `release_id` | `releaseId` | `string` | singular | — |
| `agent_ids` | `agentIds` | `string` | repeated | — |

**Response** — `tiyi.v1.ApplyBinaryReleaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`UpgradeRun`](#upgraderun) | singular | — |

### SystemService.RollbackBinaryRelease

- **Procedure** `POST /tiyi.v1.SystemService/RollbackBinaryRelease`
- **Kind** unary
- **Auth** (`system:update:apply`)

**Request** — `tiyi.v1.RollbackBinaryReleaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `agent_ids` | `agentIds` | `string` | repeated | — |

**Response** — `tiyi.v1.RollbackBinaryReleaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`UpgradeRun`](#upgraderun) | singular | — |

### SystemService.ListSystemCrsRulesets

- **Procedure** `POST /tiyi.v1.SystemService/ListSystemCrsRulesets`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.ListSystemCrsRulesetsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListSystemCrsRulesetsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`CrsRuleset`](rule.md#crsruleset) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### SystemService.GetSystemCrsRuleset

- **Procedure** `POST /tiyi.v1.SystemService/GetSystemCrsRuleset`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.GetSystemCrsRulesetRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetSystemCrsRulesetResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset` | `ruleset` | [`CrsRuleset`](rule.md#crsruleset) | singular | — |

### SystemService.ImportCrsRuleset

- **Procedure** `POST /tiyi.v1.SystemService/ImportCrsRuleset`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.ImportCrsRulesetRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `archive` | `archive` | `bytes` | singular | _base64-encoded JSON string._ |
| `source_url` | `sourceUrl` | `string` | singular | — |
| `github_tag` | `githubTag` | `string` | singular | When set, the server fetches the CRS release tarball from GitHub (https://github.com/coreruleset/coreruleset/releases/tag/<github_tag>), extracts it to a local cache, and imports the rules from there. Takes precedence over source_url when both are set. |

**Response** — `tiyi.v1.ImportCrsRulesetResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `ruleset` | `ruleset` | [`CrsRuleset`](rule.md#crsruleset) | singular | — |

### SystemService.DeleteCrsRuleset

- **Procedure** `POST /tiyi.v1.SystemService/DeleteCrsRuleset`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.DeleteCrsRulesetRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteCrsRulesetResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### SystemService.ListUpgradeRuns

- **Procedure** `POST /tiyi.v1.SystemService/ListUpgradeRuns`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.ListUpgradeRunsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |

**Response** — `tiyi.v1.ListUpgradeRunsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`UpgradeRun`](#upgraderun) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### SystemService.GetUpgradeRun

- **Procedure** `POST /tiyi.v1.SystemService/GetUpgradeRun`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.GetUpgradeRunRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetUpgradeRunResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`UpgradeRun`](#upgraderun) | singular | — |

### SystemService.StreamUpgradeRun

- **Procedure** `POST /tiyi.v1.SystemService/StreamUpgradeRun`
- **Kind** server stream — server-streaming; the response is a stream of messages
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.StreamUpgradeRunRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run_id` | `runId` | `string` | singular | — |

**Response** — `tiyi.v1.StreamUpgradeRunResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `event` | `event` | [`UpgradeRunEvent`](#upgraderunevent) | singular | — |

### SystemService.CancelUpgradeRun

- **Procedure** `POST /tiyi.v1.SystemService/CancelUpgradeRun`
- **Kind** unary
- **Auth** (`system:update:apply`)

**Request** — `tiyi.v1.CancelUpgradeRunRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run_id` | `runId` | `string` | singular | — |

**Response** — `tiyi.v1.CancelUpgradeRunResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run` | `run` | [`UpgradeRun`](#upgraderun) | singular | — |

### SystemService.CheckForUpdates

- **Procedure** `POST /tiyi.v1.SystemService/CheckForUpdates`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.CheckForUpdatesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `channel` | `channel` | `string` | singular | — |

**Response** — `tiyi.v1.CheckForUpdatesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `releases` | `releases` | [`BinaryRelease`](#binaryrelease) | repeated | — |
| `crs_rulesets` | `crsRulesets` | [`CrsRuleset`](rule.md#crsruleset) | repeated | — |
| `status` | `status` | `string` | singular | unconfigured, no_release, current, available |
| `checked_at` | `checkedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `channel` | `channel` | `string` | singular | — |

### SystemService.ListUpstreamCrsReleases

- **Procedure** `POST /tiyi.v1.SystemService/ListUpstreamCrsReleases`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.ListUpstreamCrsReleasesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `limit` | `limit` | `int32` | singular | Maximum number of releases to return (default 20, max 100). |
| `include_prerelease` | `includePrerelease` | `bool` | singular | If true, include pre-release and draft releases. |

**Response** — `tiyi.v1.ListUpstreamCrsReleasesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `releases` | `releases` | [`UpstreamCrsRelease`](#upstreamcrsrelease) | repeated | — |

### SystemService.GetObservationPipelineStats

- **Procedure** `POST /tiyi.v1.SystemService/GetObservationPipelineStats`
- **Kind** unary
- **Auth** (`system:read`)

**Request** — `tiyi.v1.GetObservationPipelineStatsRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetObservationPipelineStatsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `stats` | `stats` | [`ObservationPipelineStats`](#observationpipelinestats) | singular | — |

### SystemService.ListGeoDatabases

DB-IP Lite geo-IP datasets (country/city/asn). See internal/controlplane/geofetch. Each RPC is per (tenant, kind); a deployment typically installs at least the Country DB to enrich logs with geographic context. Enforcement IP lists accept only literal IP addresses and CIDR prefixes.

- **Procedure** `POST /tiyi.v1.SystemService/ListGeoDatabases`
- **Kind** unary
- **Auth** (`system:update:read`)

**Request** — `tiyi.v1.ListGeoDatabasesRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ListGeoDatabasesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`GeoDatabase`](#geodatabase) | repeated | — |

### SystemService.DownloadGeoDatabase

- **Procedure** `POST /tiyi.v1.SystemService/DownloadGeoDatabase`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.DownloadGeoDatabaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | country \| city \| asn |
| `month` | `month` | `string` | singular | Optional YYYY-MM override. Empty → current month then previous. |

**Response** — `tiyi.v1.DownloadGeoDatabaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `database` | `database` | [`GeoDatabase`](#geodatabase) | singular | — |

### SystemService.UploadGeoDatabase

- **Procedure** `POST /tiyi.v1.SystemService/UploadGeoDatabase`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.UploadGeoDatabaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | country \| city \| asn |
| `version` | `version` | `string` | singular | Operator-supplied label for the UI (e.g. "2026-05-custom"); if empty the server derives one from the MMDB build timestamp. |
| `payload` | `payload` | `bytes` | singular | Raw .mmdb or .mmdb.gz bytes. The fetcher transparently handles either. _base64-encoded JSON string._ |

**Response** — `tiyi.v1.UploadGeoDatabaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `database` | `database` | [`GeoDatabase`](#geodatabase) | singular | — |

### SystemService.DeleteGeoDatabase

- **Procedure** `POST /tiyi.v1.SystemService/DeleteGeoDatabase`
- **Kind** unary
- **Auth** (`system:update:write`)

**Request** — `tiyi.v1.DeleteGeoDatabaseRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteGeoDatabaseResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

## Messages

### ApplyChange

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `action` | `action` | `string` | singular | — |
| `diff` | `diff` | [`JsonPatch`](common.md#jsonpatch) | singular | — |

### ApplyPlan

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `changes` | `changes` | [`ApplyChange`](#applychange) | repeated | — |
| `warnings` | `warnings` | `string` | repeated | — |

### AttackDistributionItem

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `tag` | `tag` | `string` | singular | — |
| `count` | `count` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### BinaryRelease

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `version` | `version` | `string` | singular | — |
| `channel` | `channel` | `string` | singular | — |
| `sha256` | `sha256` | `string` | singular | — |
| `signature` | `signature` | `string` | singular | — |
| `imported_at` | `importedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### DashboardFreshness

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `as_of` | `asOf` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `resolution_seconds` | `resolutionSeconds` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `stale` | `stale` | `bool` | singular | — |
| `source` | `source` | `string` | singular | — |
| `snapshot_age_ms` | `snapshotAgeMs` | `int64` | singular | Age of the complete cached Overview response. _JSON string (64-bit ints are quoted)._ |
| `snapshot_stale` | `snapshotStale` | `bool` | singular | — |
| `observation_degraded` | `observationDegraded` | `bool` | singular | The security observation lane sampled events under recent pressure. Exact counters and rankings are unaffected; Event Analysis and drill-down logs are based on retained samples. |
| `observation_dropped` | `observationDropped` | `uint64` | singular | Process-lifetime count of sampled audit log records after full counters. _JSON string (64-bit ints are quoted)._ |
| `observation_last_drop_at` | `observationLastDropAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `waf_overload_state` | `wafOverloadState` | `string` | singular | Live node-local WAF pressure chain: resource pressure, Coraza causality, and the action currently selected by the overload controller. |
| `waf_agent_cpu_percent` | `wafAgentCpuPercent` | `double` | singular | — |
| `waf_coraza_demand_percent` | `wafCorazaDemandPercent` | `double` | singular | — |
| `waf_phase_p99_millis` | `wafPhaseP99Millis` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `waf_overload_action` | `wafOverloadAction` | `string` | singular | — |
| `waf_probe_percent` | `wafProbePercent` | `int32` | singular | — |
| `waf_overload_last_transition_at` | `wafOverloadLastTransitionAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `waf_overload_node_id` | `wafOverloadNodeId` | `string` | singular | Worst currently affected node selected from the existing local/Agent health projections. active_nodes counts degraded + recovering nodes. |
| `waf_overload_node_name` | `wafOverloadNodeName` | `string` | singular | — |
| `waf_overload_active_nodes` | `wafOverloadActiveNodes` | `int32` | singular | — |
| `remote_observation_coverage` | `remoteObservationCoverage` | [`ObservationCoverage`](common.md#observationcoverage) | singular | Current remote delivery state. Dashboard totals remain available but are explicitly lower bounds while any fresh online Agent reports a gap. |

### DashboardSecurityTopK

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`DashboardSecurityTopKItem`](#dashboardsecuritytopkitem) | repeated | — |
| `other_count` | `otherCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `total_weight` | `totalWeight` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `unavailable_reason` | `unavailableReason` | `string` | singular | — |

### DashboardSecurityTopKItem

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `key` | `key` | `string` | singular | — |
| `count` | `count` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `geo` | `geo` | [`NetworkGeo`](common.md#networkgeo) | singular | Populated only for source-IP dimensions when GeoIP data is available. |

### DashboardStats

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `sites_enabled` | `sitesEnabled` | `int32` | singular | — |
| `log_mode_degraded_sites` | `logModeDegradedSites` | `int32` | singular | — |
| `certs_expiring_14d` | `certsExpiring14d` | `int32` | singular | ACME / certificate renewal observability (Phase D). All counters are tenant-scoped and do not include soft-deleted rows. |
| `certs_expiring_30d` | `certsExpiring30d` | `int32` | singular | — |
| `acme_renewals_failed_24h` | `acmeRenewalsFailed24h` | `int32` | singular | — |
| `acme_orders_pending` | `acmeOrdersPending` | `int32` | singular | — |
| `acme_last_valid_at` | `acmeLastValidAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `nodes_online` | `nodesOnline` | `int32` | singular | Role-free node counts: the built-in local data plane plus enrolled remote Agents. A healthy single-node deployment reports 1 / 1. |
| `nodes_total` | `nodesTotal` | `int32` | singular | — |

### DashboardTopK

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`DashboardTopKItem`](#dashboardtopkitem) | repeated | — |
| `other_total` | `otherTotal` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `other_blocked` | `otherBlocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### DashboardTopKItem

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `key` | `key` | `string` | singular | — |
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### DashboardTopSite

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `site_id` | `siteId` | `string` | singular | — |
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### DashboardTrafficQuality

Exact request-quality totals over the same time/site scope as Overview. Rates are intentionally calculated by clients so zero-total semantics stay explicit and the wire values remain lossless integer counters.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `status_2xx` | `status2xx` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `status_3xx` | `status3xx` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `status_4xx` | `status4xx` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `status_5xx` | `status5xx` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `slow_requests` | `slowRequests` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `gateway_errors` | `gatewayErrors` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `duration_sum_micros` | `durationSumMicros` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `business_requests` | `businessRequests` | `int64` | singular | Requests that were not terminated by a trusted Tiyi enforcement action. Dashboard quality rates use this denominator so protection traffic does not dilute application availability or latency. _JSON string (64-bit ints are quoted)._ |
| `business_status_4xx` | `businessStatus4xx` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `business_status_5xx` | `businessStatus5xx` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `business_slow_requests` | `businessSlowRequests` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `business_very_slow_requests` | `businessVerySlowRequests` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `business_duration_sum_micros` | `businessDurationSumMicros` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `top_business_4xx_status` | `topBusiness4xxStatus` | `int32` | singular | — |
| `top_business_4xx_count` | `topBusiness4xxCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `top_business_5xx_status` | `topBusiness5xxStatus` | `int32` | singular | — |
| `top_business_5xx_count` | `topBusiness5xxCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### GeoDatabase

GeoDatabase is the metadata projection the UI consumes (no blob). Kind is "country", "city", or "asn". License: DB-IP Lite is CC-BY-4.0, the UI surfaces the attribution whenever the table is populated.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `kind` | `kind` | `string` | singular | — |
| `version` | `version` | `string` | singular | — |
| `source` | `source` | `string` | singular | online \| offline |
| `sha256` | `sha256` | `string` | singular | — |
| `size_bytes` | `sizeBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `build_epoch` | `buildEpoch` | `int64` | singular | MMDB build timestamp (unix seconds) _JSON string (64-bit ints are quoted)._ |
| `node_count` | `nodeCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `fetched_at` | `fetchedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `activation_status` | `activationStatus` | `string` | singular | Country only: pending \| activating \| active \| failed. City/ASN report not_applicable. A failed state is retried independently of auto-download. |
| `activated_sha256` | `activatedSha256` | `string` | singular | — |
| `last_activation_error` | `lastActivationError` | `string` | singular | — |
| `activation_attempted_at` | `activationAttemptedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `activated_at` | `activatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### LicenseStatus

LicenseStatus is the scale-gate status surfaced on the About page (docs/design/licensing-scale-gate.md § 3.7). No new service or page: it rides on the existing SystemService.Version response.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `edition` | `edition` | `string` | singular | "Community (single node)" or, in Phase 2, the plan. |
| `remote_nodes` | `remoteNodes` | `int32` | singular | deployment-wide live remote-agent count. |
| `max_remote_nodes` | `maxRemoteNodes` | `int32` | singular | node budget; 0 for unlicensed Community. |
| `licensee` | `licensee` | `string` | singular | Signed-license display fields. Empty/unset for unlicensed Community. |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | license expiry; unset = perpetual. _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `source` | `source` | `string` | singular | built_in, stored, file |
| `import_supported` | `importSupported` | `bool` | singular | — |
| `status` | `status` | `string` | singular | community, valid, expired, invalid |
| `error` | `error` | `string` | singular | — |

### ObservationLaneStats

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `attempted` | `attempted` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `admitted` | `admitted` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `written` | `written` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `dropped` | `dropped` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `retried` | `retried` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `panicked` | `panicked` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `pending_items` | `pendingItems` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `pending_bytes` | `pendingBytes` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `capacity` | `capacity` | `int64` | optional (explicit) | _JSON string (64-bit ints are quoted)._ |
| `last_error` | `lastError` | `string` | singular | — |
| `last_error_at` | `lastErrorAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `sampled` | `sampled` | `uint64` | singular | Intentionally shed before admission to protect the request path. This is degraded sampling coverage, not an unexpected post-admission loss. _JSON string (64-bit ints are quoted)._ |
| `sampled_client_limit` | `sampledClientLimit` | `uint64` | singular | Repeats collapsed by the per-client fairness budget. _JSON string (64-bit ints are quoted)._ |
| `sampled_global_budget` | `sampledGlobalBudget` | `uint64` | singular | Shed because the node-wide coverage/repeat budget was exhausted. _JSON string (64-bit ints are quoted)._ |
| `sampled_queue_pressure` | `sampledQueuePressure` | `uint64` | singular | Shed because reserved queue items or bytes were exhausted. _JSON string (64-bit ints are quoted)._ |
| `byte_capacity` | `byteCapacity` | `int64` | optional (explicit) | _JSON string (64-bit ints are quoted)._ |
| `last_success_at` | `lastSuccessAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `display_name` | `displayName` | `string` | singular | — |
| `state` | `state` | `string` | singular | ready, disabled or unavailable; lifetime counters remain independent. |

### ObservationPipelineStats

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `lanes` | `lanes` | [`ObservationLaneStats`](#observationlanestats) | repeated | — |
| `panicked_total` | `panickedTotal` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `boundary_panics` | `boundaryPanics` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `invalid_envelopes` | `invalidEnvelopes` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `late_detail_beyond_retention` | `lateDetailBeyondRetention` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `data_plane_requests` | `dataPlaneRequests` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `data_plane_blocked` | `dataPlaneBlocked` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `active_connections` | `activeConnections` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `late_metric_beyond_retention` | `lateMetricBeyondRetention` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |
| `available` | `available` | `bool` | singular | — |
| `epoch` | `epoch` | `string` | singular | — |
| `started_at` | `startedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `observed_at` | `observedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `siem_delivery_losses` | `siemDeliveryLosses` | `uint64` | singular | _JSON string (64-bit ints are quoted)._ |

### SystemHealthCheck

Independent current component observation. status is healthy, unhealthy or unknown.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `component` | `component` | `string` | singular | — |
| `status` | `status` | `string` | singular | — |
| `message` | `message` | `string` | singular | — |
| `checked_at` | `checkedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `duration_ms` | `durationMs` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### SystemSettings

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `values` | `values` | `google.protobuf.Struct` | singular | _free-form JSON object._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `sources` | `sources` | map&lt;`string`, `string`&gt; | map | — |

### TopAttacker

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `client_ip` | `clientIp` | `string` | singular | — |
| `count` | `count` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `top_tags` | `topTags` | `string` | repeated | — |
| `geo` | `geo` | [`NetworkGeo`](common.md#networkgeo) | singular | Best-effort source-network context; absent when GeoIP cannot resolve it. |

### TrafficPoint

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `bucket_start` | `bucketStart` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `total` | `total` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `blocked` | `blocked` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `bytes_in` | `bytesIn` | `int64` | singular | Exact HTTP payload bytes for this bucket. bytes_in is request-body data read from clients; bytes_out is response-body data written to clients. Headers, TLS and transport framing are intentionally excluded. _JSON string (64-bit ints are quoted)._ |
| `bytes_out` | `bytesOut` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |
| `interval_seconds` | `intervalSeconds` | `int64` | singular | Effective wall-clock coverage of this bucket. The first and last buckets may be partial when the requested range is not bucket-aligned. _JSON string (64-bit ints are quoted)._ |

### UpgradeRun

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `target_version` | `targetVersion` | `string` | singular | — |
| `status` | `status` | [`UpgradeRunStatus`](#upgraderunstatus) | singular | — |
| `started_at` | `startedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `finished_at` | `finishedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### UpgradeRunEvent

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `run_id` | `runId` | `string` | singular | — |
| `kind` | `kind` | [`UpgradeRunEventKind`](#upgraderuneventkind) | singular | — |
| `occurred_at` | `occurredAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `payload` | `payload` | `google.protobuf.Struct` | singular | _free-form JSON object._ |

### UpstreamCrsRelease

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `tag` | `tag` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `published_at` | `publishedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `tarball_url` | `tarballUrl` | `string` | singular | — |
| `prerelease` | `prerelease` | `bool` | singular | — |
| `draft` | `draft` | `bool` | singular | — |
| `body` | `body` | `string` | singular | — |

## Enums

### UpgradeRunEventKind

| Value | Number | Description |
|---|---|---|
| `UPGRADE_RUN_EVENT_KIND_UNSPECIFIED` | 0 | — |
| `UPGRADE_RUN_EVENT_KIND_WAVE_STARTED` | 1 | — |
| `UPGRADE_RUN_EVENT_KIND_NODE_UPDATED` | 2 | — |
| `UPGRADE_RUN_EVENT_KIND_NODE_FAILED` | 3 | — |
| `UPGRADE_RUN_EVENT_KIND_WAVE_COMPLETED` | 4 | — |
| `UPGRADE_RUN_EVENT_KIND_RUN_SUCCEEDED` | 5 | — |
| `UPGRADE_RUN_EVENT_KIND_RUN_FAILED` | 6 | — |
| `UPGRADE_RUN_EVENT_KIND_RUN_CANCELED` | 7 | — |

### UpgradeRunStatus

| Value | Number | Description |
|---|---|---|
| `UPGRADE_RUN_STATUS_UNSPECIFIED` | 0 | — |
| `UPGRADE_RUN_STATUS_PENDING` | 1 | — |
| `UPGRADE_RUN_STATUS_RUNNING` | 2 | — |
| `UPGRADE_RUN_STATUS_SUCCEEDED` | 3 | — |
| `UPGRADE_RUN_STATUS_FAILED` | 4 | — |
| `UPGRADE_RUN_STATUS_CANCELED` | 5 | — |
