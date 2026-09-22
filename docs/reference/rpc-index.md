<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# RPC index

Every RPC Tiyi serves: **310 RPCs across 26 services**. Generated from the protobuf schema, so this list is complete by construction.

`Auth` is the permission the server requires. `authenticated` means any valid session may call it; `public` means no token at all. A role holding `tiyi:superadmin` satisfies every check. See [the API guide](../en/api.md#authentication) for how tokens are obtained.

## AuthService

[Full reference →](services/auth.md#authservice) · `proto/tiyi/v1/auth.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`GetLoginOptions`](services/auth.md#authservicegetloginoptions) | `/tiyi.v1.AuthService/GetLoginOptions` | unary | **public** (no token) |
| [`Login`](services/auth.md#authservicelogin) | `/tiyi.v1.AuthService/Login` | unary | **public** (no token) |
| [`CompleteAuthenticationChallenge`](services/auth.md#authservicecompleteauthenticationchallenge) | `/tiyi.v1.AuthService/CompleteAuthenticationChallenge` | unary | **public** (no token) |
| [`Logout`](services/auth.md#authservicelogout) | `/tiyi.v1.AuthService/Logout` | unary | **public** (no token) |
| [`Refresh`](services/auth.md#authservicerefresh) | `/tiyi.v1.AuthService/Refresh` | unary | **public** (no token) |
| [`GetUserInfo`](services/auth.md#authservicegetuserinfo) | `/tiyi.v1.AuthService/GetUserInfo` | unary | authenticated |
| [`GetAccessCodes`](services/auth.md#authservicegetaccesscodes) | `/tiyi.v1.AuthService/GetAccessCodes` | unary | authenticated |
| [`ChangePassword`](services/auth.md#authservicechangepassword) | `/tiyi.v1.AuthService/ChangePassword` | unary | authenticated |
| [`GetMFAStatus`](services/auth.md#authservicegetmfastatus) | `/tiyi.v1.AuthService/GetMFAStatus` | unary | authenticated |
| [`BeginTOTPEnrollment`](services/auth.md#authservicebegintotpenrollment) | `/tiyi.v1.AuthService/BeginTOTPEnrollment` | unary | authenticated |
| [`ConfirmTOTPEnrollment`](services/auth.md#authserviceconfirmtotpenrollment) | `/tiyi.v1.AuthService/ConfirmTOTPEnrollment` | unary | authenticated |
| [`DisableTOTP`](services/auth.md#authservicedisabletotp) | `/tiyi.v1.AuthService/DisableTOTP` | unary | authenticated |
| [`RegenerateRecoveryCodes`](services/auth.md#authserviceregeneraterecoverycodes) | `/tiyi.v1.AuthService/RegenerateRecoveryCodes` | unary | authenticated |

## SystemService

[Full reference →](services/system.md#systemservice) · `proto/tiyi/v1/system.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`Health`](services/system.md#systemservicehealth) | `/tiyi.v1.SystemService/Health` | unary | (`system:read`) |
| [`Version`](services/system.md#systemserviceversion) | `/tiyi.v1.SystemService/Version` | unary | authenticated |
| [`GetSystemSettings`](services/system.md#systemservicegetsystemsettings) | `/tiyi.v1.SystemService/GetSystemSettings` | unary | (`system:read`) |
| [`UpdateSystemSettings`](services/system.md#systemserviceupdatesystemsettings) | `/tiyi.v1.SystemService/UpdateSystemSettings` | unary | (`system:write`) |
| [`ImportLicense`](services/system.md#systemserviceimportlicense) | `/tiyi.v1.SystemService/ImportLicense` | unary | (`system:write`) |
| [`GetDashboardStats`](services/system.md#systemservicegetdashboardstats) | `/tiyi.v1.SystemService/GetDashboardStats` | unary | (`site:read`) |
| [`GetDashboardOverview`](services/system.md#systemservicegetdashboardoverview) | `/tiyi.v1.SystemService/GetDashboardOverview` | unary | `site:read` and `telemetry:read` |
| [`GetTrafficTimeseries`](services/system.md#systemservicegettraffictimeseries) | `/tiyi.v1.SystemService/GetTrafficTimeseries` | unary | (`site:read`) |
| [`GetAttackDistribution`](services/system.md#systemservicegetattackdistribution) | `/tiyi.v1.SystemService/GetAttackDistribution` | unary | (`site:read`) |
| [`GetTopAttackers`](services/system.md#systemservicegettopattackers) | `/tiyi.v1.SystemService/GetTopAttackers` | unary | (`site:read`) |
| [`PreviewApply`](services/system.md#systemservicepreviewapply) | `/tiyi.v1.SystemService/PreviewApply` | unary | (`system:apply`) |
| [`Apply`](services/system.md#systemserviceapply) | `/tiyi.v1.SystemService/Apply` | unary | (`system:apply`) |
| [`ListBinaryReleases`](services/system.md#systemservicelistbinaryreleases) | `/tiyi.v1.SystemService/ListBinaryReleases` | unary | (`system:update:read`) |
| [`GetBinaryRelease`](services/system.md#systemservicegetbinaryrelease) | `/tiyi.v1.SystemService/GetBinaryRelease` | unary | (`system:update:read`) |
| [`ImportBinaryRelease`](services/system.md#systemserviceimportbinaryrelease) | `/tiyi.v1.SystemService/ImportBinaryRelease` | unary | (`system:update:write`) |
| [`DeleteBinaryRelease`](services/system.md#systemservicedeletebinaryrelease) | `/tiyi.v1.SystemService/DeleteBinaryRelease` | unary | (`system:update:write`) |
| [`ApplyBinaryRelease`](services/system.md#systemserviceapplybinaryrelease) | `/tiyi.v1.SystemService/ApplyBinaryRelease` | unary | (`system:update:apply`) |
| [`RollbackBinaryRelease`](services/system.md#systemservicerollbackbinaryrelease) | `/tiyi.v1.SystemService/RollbackBinaryRelease` | unary | (`system:update:apply`) |
| [`ListSystemCrsRulesets`](services/system.md#systemservicelistsystemcrsrulesets) | `/tiyi.v1.SystemService/ListSystemCrsRulesets` | unary | (`system:update:read`) |
| [`GetSystemCrsRuleset`](services/system.md#systemservicegetsystemcrsruleset) | `/tiyi.v1.SystemService/GetSystemCrsRuleset` | unary | (`system:update:read`) |
| [`ImportCrsRuleset`](services/system.md#systemserviceimportcrsruleset) | `/tiyi.v1.SystemService/ImportCrsRuleset` | unary | (`system:update:write`) |
| [`DeleteCrsRuleset`](services/system.md#systemservicedeletecrsruleset) | `/tiyi.v1.SystemService/DeleteCrsRuleset` | unary | (`system:update:write`) |
| [`ListUpgradeRuns`](services/system.md#systemservicelistupgraderuns) | `/tiyi.v1.SystemService/ListUpgradeRuns` | unary | (`system:update:read`) |
| [`GetUpgradeRun`](services/system.md#systemservicegetupgraderun) | `/tiyi.v1.SystemService/GetUpgradeRun` | unary | (`system:update:read`) |
| [`StreamUpgradeRun`](services/system.md#systemservicestreamupgraderun) | `/tiyi.v1.SystemService/StreamUpgradeRun` | server stream | (`system:update:read`) |
| [`CancelUpgradeRun`](services/system.md#systemservicecancelupgraderun) | `/tiyi.v1.SystemService/CancelUpgradeRun` | unary | (`system:update:apply`) |
| [`CheckForUpdates`](services/system.md#systemservicecheckforupdates) | `/tiyi.v1.SystemService/CheckForUpdates` | unary | (`system:update:read`) |
| [`ListUpstreamCrsReleases`](services/system.md#systemservicelistupstreamcrsreleases) | `/tiyi.v1.SystemService/ListUpstreamCrsReleases` | unary | (`system:update:read`) |
| [`GetObservationPipelineStats`](services/system.md#systemservicegetobservationpipelinestats) | `/tiyi.v1.SystemService/GetObservationPipelineStats` | unary | (`system:read`) |
| [`ListGeoDatabases`](services/system.md#systemservicelistgeodatabases) | `/tiyi.v1.SystemService/ListGeoDatabases` | unary | (`system:update:read`) |
| [`DownloadGeoDatabase`](services/system.md#systemservicedownloadgeodatabase) | `/tiyi.v1.SystemService/DownloadGeoDatabase` | unary | (`system:update:write`) |
| [`UploadGeoDatabase`](services/system.md#systemserviceuploadgeodatabase) | `/tiyi.v1.SystemService/UploadGeoDatabase` | unary | (`system:update:write`) |
| [`DeleteGeoDatabase`](services/system.md#systemservicedeletegeodatabase) | `/tiyi.v1.SystemService/DeleteGeoDatabase` | unary | (`system:update:write`) |

## SiteService

[Full reference →](services/site.md#siteservice) · `proto/tiyi/v1/site.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListSites`](services/site.md#siteservicelistsites) | `/tiyi.v1.SiteService/ListSites` | unary | (`site:read`) |
| [`GetSite`](services/site.md#siteservicegetsite) | `/tiyi.v1.SiteService/GetSite` | unary | (`site:read`) |
| [`CreateSite`](services/site.md#siteservicecreatesite) | `/tiyi.v1.SiteService/CreateSite` | unary | (`site:write`) |
| [`UpdateSite`](services/site.md#siteserviceupdatesite) | `/tiyi.v1.SiteService/UpdateSite` | unary | (`site:write`) |
| [`DeleteSite`](services/site.md#siteservicedeletesite) | `/tiyi.v1.SiteService/DeleteSite` | unary | (`site:delete`) |
| [`EnableSite`](services/site.md#siteserviceenablesite) | `/tiyi.v1.SiteService/EnableSite` | unary | (`site:write`) |
| [`DisableSite`](services/site.md#siteservicedisablesite) | `/tiyi.v1.SiteService/DisableSite` | unary | (`site:write`) |
| [`PreviewCompiledConfig`](services/site.md#siteservicepreviewcompiledconfig) | `/tiyi.v1.SiteService/PreviewCompiledConfig` | unary | (`site:preview`) |
| [`ExportSite`](services/site.md#siteserviceexportsite) | `/tiyi.v1.SiteService/ExportSite` | unary | `site:read` and `upstream:read` and `cert:export` |
| [`ExportSites`](services/site.md#siteserviceexportsites) | `/tiyi.v1.SiteService/ExportSites` | unary | `site:read` and `upstream:read` and `cert:export` |
| [`ImportSite`](services/site.md#siteserviceimportsite) | `/tiyi.v1.SiteService/ImportSite` | unary | `site:write` and `upstream:write` and `cert:write` |
| [`GetSiteRouting`](services/site.md#siteservicegetsiterouting) | `/tiyi.v1.SiteService/GetSiteRouting` | unary | (`site:read`) |
| [`UpdateSiteRouting`](services/site.md#siteserviceupdatesiterouting) | `/tiyi.v1.SiteService/UpdateSiteRouting` | unary | (`site:write`) |
| [`GetSitePolicyOverride`](services/site.md#siteservicegetsitepolicyoverride) | `/tiyi.v1.SiteService/GetSitePolicyOverride` | unary | (`site:read`) |
| [`UpsertSitePolicyOverride`](services/site.md#siteserviceupsertsitepolicyoverride) | `/tiyi.v1.SiteService/UpsertSitePolicyOverride` | unary | (`site:write`) |
| [`DeleteSitePolicyOverride`](services/site.md#siteservicedeletesitepolicyoverride) | `/tiyi.v1.SiteService/DeleteSitePolicyOverride` | unary | (`site:write`) |

## UpstreamService

[Full reference →](services/upstream.md#upstreamservice) · `proto/tiyi/v1/upstream.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListUpstreams`](services/upstream.md#upstreamservicelistupstreams) | `/tiyi.v1.UpstreamService/ListUpstreams` | unary | (`upstream:read`) |
| [`GetUpstream`](services/upstream.md#upstreamservicegetupstream) | `/tiyi.v1.UpstreamService/GetUpstream` | unary | (`upstream:read`) |
| [`CreateUpstream`](services/upstream.md#upstreamservicecreateupstream) | `/tiyi.v1.UpstreamService/CreateUpstream` | unary | (`upstream:write`) |
| [`UpdateUpstream`](services/upstream.md#upstreamserviceupdateupstream) | `/tiyi.v1.UpstreamService/UpdateUpstream` | unary | (`upstream:write`) |
| [`DeleteUpstream`](services/upstream.md#upstreamservicedeleteupstream) | `/tiyi.v1.UpstreamService/DeleteUpstream` | unary | (`upstream:delete`) |
| [`ListUpstreamHealth`](services/upstream.md#upstreamservicelistupstreamhealth) | `/tiyi.v1.UpstreamService/ListUpstreamHealth` | unary | (`upstream:read`) |

## CertService

[Full reference →](services/cert.md#certservice) · `proto/tiyi/v1/cert.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListCerts`](services/cert.md#certservicelistcerts) | `/tiyi.v1.CertService/ListCerts` | unary | (`cert:read`) |
| [`GetCert`](services/cert.md#certservicegetcert) | `/tiyi.v1.CertService/GetCert` | unary | (`cert:read`) |
| [`UploadCert`](services/cert.md#certserviceuploadcert) | `/tiyi.v1.CertService/UploadCert` | unary | (`cert:write`) |
| [`IssueACMECert`](services/cert.md#certserviceissueacmecert) | `/tiyi.v1.CertService/IssueACMECert` | unary | (`cert:issue`) |
| [`RenewCert`](services/cert.md#certservicerenewcert) | `/tiyi.v1.CertService/RenewCert` | unary | (`cert:issue`) |
| [`DeleteCert`](services/cert.md#certservicedeletecert) | `/tiyi.v1.CertService/DeleteCert` | unary | (`cert:delete`) |
| [`DownloadCert`](services/cert.md#certservicedownloadcert) | `/tiyi.v1.CertService/DownloadCert` | unary | (`cert:export`) |
| [`ListDNSProviders`](services/cert.md#certservicelistdnsproviders) | `/tiyi.v1.CertService/ListDNSProviders` | unary | (`cert:read`) |
| [`GetDNSProvider`](services/cert.md#certservicegetdnsprovider) | `/tiyi.v1.CertService/GetDNSProvider` | unary | (`cert:read`) |
| [`CreateDNSProvider`](services/cert.md#certservicecreatednsprovider) | `/tiyi.v1.CertService/CreateDNSProvider` | unary | (`cert:write`) |
| [`UpdateDNSProvider`](services/cert.md#certserviceupdatednsprovider) | `/tiyi.v1.CertService/UpdateDNSProvider` | unary | (`cert:write`) |
| [`DeleteDNSProvider`](services/cert.md#certservicedeletednsprovider) | `/tiyi.v1.CertService/DeleteDNSProvider` | unary | (`cert:delete`) |
| [`ListDNSProviderDrivers`](services/cert.md#certservicelistdnsproviderdrivers) | `/tiyi.v1.CertService/ListDNSProviderDrivers` | unary | (`cert:read`) |

## PolicyService

[Full reference →](services/policy.md#policyservice) · `proto/tiyi/v1/policy.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListPolicies`](services/policy.md#policyservicelistpolicies) | `/tiyi.v1.PolicyService/ListPolicies` | unary | (`policy:read`) |
| [`GetPolicy`](services/policy.md#policyservicegetpolicy) | `/tiyi.v1.PolicyService/GetPolicy` | unary | (`policy:read`) |
| [`CreatePolicy`](services/policy.md#policyservicecreatepolicy) | `/tiyi.v1.PolicyService/CreatePolicy` | unary | (`policy:write`) |
| [`CreatePolicyFromTemplate`](services/policy.md#policyservicecreatepolicyfromtemplate) | `/tiyi.v1.PolicyService/CreatePolicyFromTemplate` | unary | (`policy:write`) |
| [`UpdatePolicy`](services/policy.md#policyserviceupdatepolicy) | `/tiyi.v1.PolicyService/UpdatePolicy` | unary | (`policy:write`) |
| [`UpdatePolicyLayer`](services/policy.md#policyserviceupdatepolicylayer) | `/tiyi.v1.PolicyService/UpdatePolicyLayer` | unary | (`policy:write`) |
| [`DeletePolicy`](services/policy.md#policyservicedeletepolicy) | `/tiyi.v1.PolicyService/DeletePolicy` | unary | (`policy:delete`) |
| [`SetEngineState`](services/policy.md#policyservicesetenginestate) | `/tiyi.v1.PolicyService/SetEngineState` | unary | (`policy:write`) |
| [`SetActiveCrsRuleset`](services/policy.md#policyservicesetactivecrsruleset) | `/tiyi.v1.PolicyService/SetActiveCrsRuleset` | unary | (`policy:crs:write`) |
| [`PreviewSecLang`](services/policy.md#policyservicepreviewseclang) | `/tiyi.v1.PolicyService/PreviewSecLang` | unary | (`policy:preview`) |
| [`PreviewCrsImpact`](services/policy.md#policyservicepreviewcrsimpact) | `/tiyi.v1.PolicyService/PreviewCrsImpact` | unary | (`policy:preview`) |
| [`TestPolicy`](services/policy.md#policyservicetestpolicy) | `/tiyi.v1.PolicyService/TestPolicy` | unary | (`policy:test`) |
| [`ListPolicyTemplates`](services/policy.md#policyservicelistpolicytemplates) | `/tiyi.v1.PolicyService/ListPolicyTemplates` | unary | (`policy:read`) |
| [`ListPolicyVersions`](services/policy.md#policyservicelistpolicyversions) | `/tiyi.v1.PolicyService/ListPolicyVersions` | unary | (`policy:read`) |
| [`GetPolicyVersion`](services/policy.md#policyservicegetpolicyversion) | `/tiyi.v1.PolicyService/GetPolicyVersion` | unary | (`policy:read`) |
| [`RollbackPolicy`](services/policy.md#policyservicerollbackpolicy) | `/tiyi.v1.PolicyService/RollbackPolicy` | unary | (`policy:write`) |
| [`DiffPolicyVersions`](services/policy.md#policyservicediffpolicyversions) | `/tiyi.v1.PolicyService/DiffPolicyVersions` | unary | (`policy:read`) |

## RuleOverrideService

[Full reference →](services/rule.md#ruleoverrideservice) · `proto/tiyi/v1/rule.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListRuleOverrides`](services/rule.md#ruleoverrideservicelistruleoverrides) | `/tiyi.v1.RuleOverrideService/ListRuleOverrides` | unary | (`policy:read`) |
| [`GetRuleOverride`](services/rule.md#ruleoverrideservicegetruleoverride) | `/tiyi.v1.RuleOverrideService/GetRuleOverride` | unary | (`policy:read`) |
| [`UpsertRuleOverride`](services/rule.md#ruleoverrideserviceupsertruleoverride) | `/tiyi.v1.RuleOverrideService/UpsertRuleOverride` | unary | (`policy:rule:override`) |
| [`DeleteRuleOverride`](services/rule.md#ruleoverrideservicedeleteruleoverride) | `/tiyi.v1.RuleOverrideService/DeleteRuleOverride` | unary | (`policy:rule:override`) |
| [`BulkUpsertRuleOverrides`](services/rule.md#ruleoverrideservicebulkupsertruleoverrides) | `/tiyi.v1.RuleOverrideService/BulkUpsertRuleOverrides` | unary | (`policy:rule:override`) |
| [`ListCrsRulesForPolicy`](services/rule.md#ruleoverrideservicelistcrsrulesforpolicy) | `/tiyi.v1.RuleOverrideService/ListCrsRulesForPolicy` | unary | (`policy:read`) |

## CustomRuleService

[Full reference →](services/rule.md#customruleservice) · `proto/tiyi/v1/rule.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListCustomRules`](services/rule.md#customruleservicelistcustomrules) | `/tiyi.v1.CustomRuleService/ListCustomRules` | unary | (`policy:read`) |
| [`GetCustomRule`](services/rule.md#customruleservicegetcustomrule) | `/tiyi.v1.CustomRuleService/GetCustomRule` | unary | (`policy:read`) |
| [`CreateCustomRule`](services/rule.md#customruleservicecreatecustomrule) | `/tiyi.v1.CustomRuleService/CreateCustomRule` | unary | (`policy:custom:write`) |
| [`UpdateCustomRule`](services/rule.md#customruleserviceupdatecustomrule) | `/tiyi.v1.CustomRuleService/UpdateCustomRule` | unary | (`policy:custom:write`) |
| [`DeleteCustomRule`](services/rule.md#customruleservicedeletecustomrule) | `/tiyi.v1.CustomRuleService/DeleteCustomRule` | unary | (`policy:custom:write`) |
| [`ReorderCustomRules`](services/rule.md#customruleservicereordercustomrules) | `/tiyi.v1.CustomRuleService/ReorderCustomRules` | unary | (`policy:custom:write`) |
| [`PreviewCustomRule`](services/rule.md#customruleservicepreviewcustomrule) | `/tiyi.v1.CustomRuleService/PreviewCustomRule` | unary | (`policy:preview`) |
| [`ListCustomRuleTemplates`](services/rule.md#customruleservicelistcustomruletemplates) | `/tiyi.v1.CustomRuleService/ListCustomRuleTemplates` | unary | (`policy:read`) |
| [`CreateFromTemplate`](services/rule.md#customruleservicecreatefromtemplate) | `/tiyi.v1.CustomRuleService/CreateFromTemplate` | unary | (`policy:custom:write`) |

## IpListService

[Full reference →](services/rule.md#iplistservice) · `proto/tiyi/v1/rule.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListIpLists`](services/rule.md#iplistservicelistiplists) | `/tiyi.v1.IpListService/ListIpLists` | unary | (`policy:read`) |
| [`GetIpList`](services/rule.md#iplistservicegetiplist) | `/tiyi.v1.IpListService/GetIpList` | unary | (`policy:read`) |
| [`ListIpListEntries`](services/rule.md#iplistservicelistiplistentries) | `/tiyi.v1.IpListService/ListIpListEntries` | unary | (`policy:read`) |
| [`CreateIpList`](services/rule.md#iplistservicecreateiplist) | `/tiyi.v1.IpListService/CreateIpList` | unary | (`policy:iplist:write`) |
| [`UpdateIpList`](services/rule.md#iplistserviceupdateiplist) | `/tiyi.v1.IpListService/UpdateIpList` | unary | (`policy:iplist:write`) |
| [`DeleteIpList`](services/rule.md#iplistservicedeleteiplist) | `/tiyi.v1.IpListService/DeleteIpList` | unary | (`policy:iplist:write`) |
| [`ReplaceIpListEntries`](services/rule.md#iplistservicereplaceiplistentries) | `/tiyi.v1.IpListService/ReplaceIpListEntries` | unary | (`policy:iplist:write`) |
| [`CloneIpList`](services/rule.md#iplistservicecloneiplist) | `/tiyi.v1.IpListService/CloneIpList` | unary | (`policy:iplist:write`) |
| [`GetIpListEditImpact`](services/rule.md#iplistservicegetiplisteditimpact) | `/tiyi.v1.IpListService/GetIpListEditImpact` | unary | (`policy:read`) |
| [`CreateIpListSubscription`](services/rule.md#iplistservicecreateiplistsubscription) | `/tiyi.v1.IpListService/CreateIpListSubscription` | unary | (`policy:iplist:source:write`) |
| [`UpdateIpListSubscription`](services/rule.md#iplistserviceupdateiplistsubscription) | `/tiyi.v1.IpListService/UpdateIpListSubscription` | unary | (`policy:iplist:source:write`) |
| [`TestIpListSource`](services/rule.md#iplistservicetestiplistsource) | `/tiyi.v1.IpListService/TestIpListSource` | unary | (`policy:iplist:source:write`) |
| [`SyncIpListNow`](services/rule.md#iplistservicesynciplistnow) | `/tiyi.v1.IpListService/SyncIpListNow` | unary | (`policy:iplist:sync`) |
| [`PauseIpListSync`](services/rule.md#iplistservicepauseiplistsync) | `/tiyi.v1.IpListService/PauseIpListSync` | unary | (`policy:iplist:sync`) |
| [`ResumeIpListSync`](services/rule.md#iplistserviceresumeiplistsync) | `/tiyi.v1.IpListService/ResumeIpListSync` | unary | (`policy:iplist:sync`) |
| [`ListIpListSyncRuns`](services/rule.md#iplistservicelistiplistsyncruns) | `/tiyi.v1.IpListService/ListIpListSyncRuns` | unary | (`policy:read`) |
| [`AcceptHeldIpListUpdate`](services/rule.md#iplistserviceacceptheldiplistupdate) | `/tiyi.v1.IpListService/AcceptHeldIpListUpdate` | unary | (`policy:iplist:sync`) |
| [`DiscardHeldIpListUpdate`](services/rule.md#iplistservicediscardheldiplistupdate) | `/tiyi.v1.IpListService/DiscardHeldIpListUpdate` | unary | (`policy:iplist:sync`) |
| [`AddEntries`](services/rule.md#iplistserviceaddentries) | `/tiyi.v1.IpListService/AddEntries` | unary | (`policy:iplist:write`) |
| [`RemoveEntries`](services/rule.md#iplistserviceremoveentries) | `/tiyi.v1.IpListService/RemoveEntries` | unary | (`policy:iplist:write`) |
| [`ExportCsv`](services/rule.md#iplistserviceexportcsv) | `/tiyi.v1.IpListService/ExportCsv` | unary | (`policy:read`) |
| [`LookupIp`](services/rule.md#iplistservicelookupip) | `/tiyi.v1.IpListService/LookupIp` | unary | (`policy:read`) |
| [`LookupIpScopes`](services/rule.md#iplistservicelookupipscopes) | `/tiyi.v1.IpListService/LookupIpScopes` | unary | (`policy:read`) |
| [`ListIpListBindings`](services/rule.md#iplistservicelistiplistbindings) | `/tiyi.v1.IpListService/ListIpListBindings` | unary | (`policy:read`) |
| [`UpsertIpListBinding`](services/rule.md#iplistserviceupsertiplistbinding) | `/tiyi.v1.IpListService/UpsertIpListBinding` | unary | (`policy:iplist:write`) |
| [`DeleteIpListBinding`](services/rule.md#iplistservicedeleteiplistbinding) | `/tiyi.v1.IpListService/DeleteIpListBinding` | unary | (`policy:iplist:write`) |
| [`ListGlobalIpListBindings`](services/rule.md#iplistservicelistglobaliplistbindings) | `/tiyi.v1.IpListService/ListGlobalIpListBindings` | unary | (`policy:read`) |
| [`UpsertGlobalIpListBinding`](services/rule.md#iplistserviceupsertglobaliplistbinding) | `/tiyi.v1.IpListService/UpsertGlobalIpListBinding` | unary | (`policy:iplist:write`) |
| [`DeleteGlobalIpListBinding`](services/rule.md#iplistservicedeleteglobaliplistbinding) | `/tiyi.v1.IpListService/DeleteGlobalIpListBinding` | unary | (`policy:iplist:write`) |
| [`ListIpListReferences`](services/rule.md#iplistservicelistiplistreferences) | `/tiyi.v1.IpListService/ListIpListReferences` | unary | (`policy:read`) |
| [`ApplyIpList`](services/rule.md#iplistserviceapplyiplist) | `/tiyi.v1.IpListService/ApplyIpList` | unary | (`policy:iplist:write`) |

## CountryAccessService

[Full reference →](services/rule.md#countryaccessservice) · `proto/tiyi/v1/rule.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListCountryAccessRules`](services/rule.md#countryaccessservicelistcountryaccessrules) | `/tiyi.v1.CountryAccessService/ListCountryAccessRules` | unary | (`policy:read`) |
| [`GetCountryAccessRule`](services/rule.md#countryaccessservicegetcountryaccessrule) | `/tiyi.v1.CountryAccessService/GetCountryAccessRule` | unary | (`policy:read`) |
| [`GetCountryCatalog`](services/rule.md#countryaccessservicegetcountrycatalog) | `/tiyi.v1.CountryAccessService/GetCountryCatalog` | unary | (`policy:read`) |
| [`UpsertCountryAccessRule`](services/rule.md#countryaccessserviceupsertcountryaccessrule) | `/tiyi.v1.CountryAccessService/UpsertCountryAccessRule` | unary | (`policy:country:write`) |
| [`DeleteCountryAccessRule`](services/rule.md#countryaccessservicedeletecountryaccessrule) | `/tiyi.v1.CountryAccessService/DeleteCountryAccessRule` | unary | (`policy:country:write`) |

## RateLimitService

[Full reference →](services/rule.md#ratelimitservice) · `proto/tiyi/v1/rule.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListRateLimitEndpoints`](services/rule.md#ratelimitservicelistratelimitendpoints) | `/tiyi.v1.RateLimitService/ListRateLimitEndpoints` | unary | (`policy:read`) |
| [`UpsertRateLimitEndpoint`](services/rule.md#ratelimitserviceupsertratelimitendpoint) | `/tiyi.v1.RateLimitService/UpsertRateLimitEndpoint` | unary | (`policy:write`) |
| [`DeleteRateLimitEndpoint`](services/rule.md#ratelimitservicedeleteratelimitendpoint) | `/tiyi.v1.RateLimitService/DeleteRateLimitEndpoint` | unary | (`policy:write`) |

## CrsService

[Full reference →](services/rule.md#crsservice) · `proto/tiyi/v1/rule.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListCrsRulesets`](services/rule.md#crsservicelistcrsrulesets) | `/tiyi.v1.CrsService/ListCrsRulesets` | unary | (`policy:read`) |
| [`GetCrsRuleset`](services/rule.md#crsservicegetcrsruleset) | `/tiyi.v1.CrsService/GetCrsRuleset` | unary | (`policy:read`) |
| [`ListCrsRules`](services/rule.md#crsservicelistcrsrules) | `/tiyi.v1.CrsService/ListCrsRules` | unary | (`policy:read`) |
| [`GetCrsRule`](services/rule.md#crsservicegetcrsrule) | `/tiyi.v1.CrsService/GetCrsRule` | unary | (`policy:read`) |
| [`ListCrsCategories`](services/rule.md#crsservicelistcrscategories) | `/tiyi.v1.CrsService/ListCrsCategories` | unary | (`policy:read`) |
| [`ListCrsTags`](services/rule.md#crsservicelistcrstags) | `/tiyi.v1.CrsService/ListCrsTags` | unary | (`policy:read`) |
| [`ListCrsPlugins`](services/rule.md#crsservicelistcrsplugins) | `/tiyi.v1.CrsService/ListCrsPlugins` | unary | (`policy:read`) |
| [`GetCrsPluginConfigSchema`](services/rule.md#crsservicegetcrspluginconfigschema) | `/tiyi.v1.CrsService/GetCrsPluginConfigSchema` | unary | (`policy:read`) |
| [`ListCrsExclusionPlugins`](services/rule.md#crsservicelistcrsexclusionplugins) | `/tiyi.v1.CrsService/ListCrsExclusionPlugins` | unary | (`policy:read`) |
| [`GetCrsExclusionPlugin`](services/rule.md#crsservicegetcrsexclusionplugin) | `/tiyi.v1.CrsService/GetCrsExclusionPlugin` | unary | (`policy:read`) |
| [`ImportCrsExclusionPlugin`](services/rule.md#crsserviceimportcrsexclusionplugin) | `/tiyi.v1.CrsService/ImportCrsExclusionPlugin` | unary | (`system:update:write`) |
| [`ListUpstreamCrsExclusionPluginReleases`](services/rule.md#crsservicelistupstreamcrsexclusionpluginreleases) | `/tiyi.v1.CrsService/ListUpstreamCrsExclusionPluginReleases` | unary | (`system:update:read`) |
| [`ListPolicyExclusionPlugins`](services/rule.md#crsservicelistpolicyexclusionplugins) | `/tiyi.v1.CrsService/ListPolicyExclusionPlugins` | unary | (`policy:read`) |
| [`UpsertPolicyExclusionPlugin`](services/rule.md#crsserviceupsertpolicyexclusionplugin) | `/tiyi.v1.CrsService/UpsertPolicyExclusionPlugin` | unary | (`policy:write`) |
| [`DeletePolicyExclusionPlugin`](services/rule.md#crsservicedeletepolicyexclusionplugin) | `/tiyi.v1.CrsService/DeletePolicyExclusionPlugin` | unary | (`policy:write`) |

## LogService

[Full reference →](services/log.md#logservice) · `proto/tiyi/v1/log.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`GetGlobalLogPolicy`](services/log.md#logservicegetgloballogpolicy) | `/tiyi.v1.LogService/GetGlobalLogPolicy` | unary | (`system:read`) |
| [`UpdateGlobalLogPolicy`](services/log.md#logserviceupdategloballogpolicy) | `/tiyi.v1.LogService/UpdateGlobalLogPolicy` | unary | (`system:write`) |
| [`GetSiteLogPolicy`](services/log.md#logservicegetsitelogpolicy) | `/tiyi.v1.LogService/GetSiteLogPolicy` | unary | (`site:read`) |
| [`UpsertSiteLogPolicyOverride`](services/log.md#logserviceupsertsitelogpolicyoverride) | `/tiyi.v1.LogService/UpsertSiteLogPolicyOverride` | unary | (`site:write`) |
| [`DeleteSiteLogPolicyOverride`](services/log.md#logservicedeletesitelogpolicyoverride) | `/tiyi.v1.LogService/DeleteSiteLogPolicyOverride` | unary | (`site:write`) |
| [`QuerySecurityEvents`](services/log.md#logservicequerysecurityevents) | `/tiyi.v1.LogService/QuerySecurityEvents` | unary | (`log:read`) |
| [`QueryAccessEvents`](services/log.md#logservicequeryaccessevents) | `/tiyi.v1.LogService/QueryAccessEvents` | unary | (`log:read`) |
| [`QueryErrorEvents`](services/log.md#logservicequeryerrorevents) | `/tiyi.v1.LogService/QueryErrorEvents` | unary | (`log:read`) |
| [`GetSecurityEvent`](services/log.md#logservicegetsecurityevent) | `/tiyi.v1.LogService/GetSecurityEvent` | unary | (`log:read`) |
| [`GetAccessEvent`](services/log.md#logservicegetaccessevent) | `/tiyi.v1.LogService/GetAccessEvent` | unary | (`log:read`) |
| [`GetErrorEvent`](services/log.md#logservicegeterrorevent) | `/tiyi.v1.LogService/GetErrorEvent` | unary | (`log:read`) |
| [`TailSecurityEvents`](services/log.md#logservicetailsecurityevents) | `/tiyi.v1.LogService/TailSecurityEvents` | server stream | (`log:read`) |
| [`ExportSecurityEvents`](services/log.md#logserviceexportsecurityevents) | `/tiyi.v1.LogService/ExportSecurityEvents` | unary | (`log:export`) |
| [`ExportAccessEvents`](services/log.md#logserviceexportaccessevents) | `/tiyi.v1.LogService/ExportAccessEvents` | unary | (`log:export`) |
| [`ExportErrorEvents`](services/log.md#logserviceexporterrorevents) | `/tiyi.v1.LogService/ExportErrorEvents` | unary | (`log:export`) |
| [`GetAccessLogSummary`](services/log.md#logservicegetaccesslogsummary) | `/tiyi.v1.LogService/GetAccessLogSummary` | unary | (`log:read`) |
| [`GetAccessLogRankings`](services/log.md#logservicegetaccesslogrankings) | `/tiyi.v1.LogService/GetAccessLogRankings` | unary | (`log:read`) |
| [`GetSecurityLogSummary`](services/log.md#logservicegetsecuritylogsummary) | `/tiyi.v1.LogService/GetSecurityLogSummary` | unary | (`log:read`) |
| [`GetRequestEvidenceMetadata`](services/log.md#logservicegetrequestevidencemetadata) | `/tiyi.v1.LogService/GetRequestEvidenceMetadata` | unary | (`log:read`) |
| [`GetRequestEvidenceHeaders`](services/log.md#logservicegetrequestevidenceheaders) | `/tiyi.v1.LogService/GetRequestEvidenceHeaders` | unary | (`log:read`) |
| [`StreamRequestEvidenceBody`](services/log.md#logservicestreamrequestevidencebody) | `/tiyi.v1.LogService/StreamRequestEvidenceBody` | server stream | (`log:read`) |
| [`DownloadRequestEvidenceBody`](services/log.md#logservicedownloadrequestevidencebody) | `/tiyi.v1.LogService/DownloadRequestEvidenceBody` | server stream | (`log:read`) |

## AlertService

[Full reference →](services/alert.md#alertservice) · `proto/tiyi/v1/alert.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListAlerts`](services/alert.md#alertservicelistalerts) | `/tiyi.v1.AlertService/ListAlerts` | unary | (`alert:read`) |
| [`GetAlert`](services/alert.md#alertservicegetalert) | `/tiyi.v1.AlertService/GetAlert` | unary | (`alert:read`) |
| [`AckAlert`](services/alert.md#alertserviceackalert) | `/tiyi.v1.AlertService/AckAlert` | unary | (`alert:ack`) |
| [`ResolveAlert`](services/alert.md#alertserviceresolvealert) | `/tiyi.v1.AlertService/ResolveAlert` | unary | (`alert:resolve`) |
| [`ListAlertRules`](services/alert.md#alertservicelistalertrules) | `/tiyi.v1.AlertService/ListAlertRules` | unary | (`alert:read`) |
| [`GetAlertRule`](services/alert.md#alertservicegetalertrule) | `/tiyi.v1.AlertService/GetAlertRule` | unary | (`alert:read`) |
| [`UpsertAlertRule`](services/alert.md#alertserviceupsertalertrule) | `/tiyi.v1.AlertService/UpsertAlertRule` | unary | (`alert:write`) |
| [`ReplayAlertRule`](services/alert.md#alertservicereplayalertrule) | `/tiyi.v1.AlertService/ReplayAlertRule` | unary | (`alert:write`) |
| [`DeleteAlertRule`](services/alert.md#alertservicedeletealertrule) | `/tiyi.v1.AlertService/DeleteAlertRule` | unary | (`alert:write`) |
| [`ListAlertChannels`](services/alert.md#alertservicelistalertchannels) | `/tiyi.v1.AlertService/ListAlertChannels` | unary | (`alert:read`) |
| [`GetAlertChannel`](services/alert.md#alertservicegetalertchannel) | `/tiyi.v1.AlertService/GetAlertChannel` | unary | (`alert:read`) |
| [`UpsertAlertChannel`](services/alert.md#alertserviceupsertalertchannel) | `/tiyi.v1.AlertService/UpsertAlertChannel` | unary | (`alert:write`) |
| [`DeleteAlertChannel`](services/alert.md#alertservicedeletealertchannel) | `/tiyi.v1.AlertService/DeleteAlertChannel` | unary | (`alert:write`) |
| [`TestAlertChannel`](services/alert.md#alertservicetestalertchannel) | `/tiyi.v1.AlertService/TestAlertChannel` | unary | (`alert:write`) |
| [`PreviewAlertRuleNotification`](services/alert.md#alertservicepreviewalertrulenotification) | `/tiyi.v1.AlertService/PreviewAlertRuleNotification` | unary | (`alert:write`) |
| [`ApplyAlertChannelToRules`](services/alert.md#alertserviceapplyalertchanneltorules) | `/tiyi.v1.AlertService/ApplyAlertChannelToRules` | unary | (`alert:write`) |
| [`ListAlertNotes`](services/alert.md#alertservicelistalertnotes) | `/tiyi.v1.AlertService/ListAlertNotes` | unary | (`alert:read`) |
| [`ListAlertSilences`](services/alert.md#alertservicelistalertsilences) | `/tiyi.v1.AlertService/ListAlertSilences` | unary | (`alert:read`) |
| [`CreateAlertSilence`](services/alert.md#alertservicecreatealertsilence) | `/tiyi.v1.AlertService/CreateAlertSilence` | unary | (`alert:write`) |
| [`DeleteAlertSilence`](services/alert.md#alertservicedeletealertsilence) | `/tiyi.v1.AlertService/DeleteAlertSilence` | unary | (`alert:write`) |
| [`PreviewAlertSilence`](services/alert.md#alertservicepreviewalertsilence) | `/tiyi.v1.AlertService/PreviewAlertSilence` | unary | (`alert:write`) |

## AuditService

[Full reference →](services/audit.md#auditservice) · `proto/tiyi/v1/audit.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`QueryAudit`](services/audit.md#auditservicequeryaudit) | `/tiyi.v1.AuditService/QueryAudit` | unary | (`audit:read`) |
| [`GetAuditEntry`](services/audit.md#auditservicegetauditentry) | `/tiyi.v1.AuditService/GetAuditEntry` | unary | (`audit:read`) |
| [`GetChainStatus`](services/audit.md#auditservicegetchainstatus) | `/tiyi.v1.AuditService/GetChainStatus` | unary | (`audit:read`) |
| [`VerifyChain`](services/audit.md#auditserviceverifychain) | `/tiyi.v1.AuditService/VerifyChain` | unary | (`audit:verify`) |

## AgentService

[Full reference →](services/agent.md#agentservice) · `proto/tiyi/v1/agent.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`Enroll`](services/agent.md#agentserviceenroll) | `/tiyi.v1.AgentService/Enroll` | unary | **public** (no token) |
| [`ListNodes`](services/agent.md#agentservicelistnodes) | `/tiyi.v1.AgentService/ListNodes` | unary | (`agent:read`) |
| [`ListAgents`](services/agent.md#agentservicelistagents) | `/tiyi.v1.AgentService/ListAgents` | unary | (`agent:read`) |
| [`GetAgent`](services/agent.md#agentservicegetagent) | `/tiyi.v1.AgentService/GetAgent` | unary | (`agent:read`) |
| [`GetNodeCapabilities`](services/agent.md#agentservicegetnodecapabilities) | `/tiyi.v1.AgentService/GetNodeCapabilities` | unary | (`agent:read`) |
| [`GetNodeServingState`](services/agent.md#agentservicegetnodeservingstate) | `/tiyi.v1.AgentService/GetNodeServingState` | unary | (`agent:read`) |
| [`UpdateAgent`](services/agent.md#agentserviceupdateagent) | `/tiyi.v1.AgentService/UpdateAgent` | unary | (`agent:write`) |
| [`DeleteAgent`](services/agent.md#agentservicedeleteagent) | `/tiyi.v1.AgentService/DeleteAgent` | unary | (`agent:delete`) |
| [`RetryNodeConfig`](services/agent.md#agentserviceretrynodeconfig) | `/tiyi.v1.AgentService/RetryNodeConfig` | unary | (`agent:write`) |
| [`IssueEnrollmentToken`](services/agent.md#agentserviceissueenrollmenttoken) | `/tiyi.v1.AgentService/IssueEnrollmentToken` | unary | (`agent:install`) |
| [`CreateNodeInstallation`](services/agent.md#agentservicecreatenodeinstallation) | `/tiyi.v1.AgentService/CreateNodeInstallation` | unary | (`agent:install`) |
| [`GetNodeInstallStatus`](services/agent.md#agentservicegetnodeinstallstatus) | `/tiyi.v1.AgentService/GetNodeInstallStatus` | unary | (`agent:install`) |
| [`StreamAgentEvents`](services/agent.md#agentservicestreamagentevents) | `/tiyi.v1.AgentService/StreamAgentEvents` | server stream | (`agent:read`) |
| [`ListNodeMetricSamples`](services/agent.md#agentservicelistnodemetricsamples) | `/tiyi.v1.AgentService/ListNodeMetricSamples` | unary | (`agent:read`) |
| [`ListConfigBundles`](services/agent.md#agentservicelistconfigbundles) | `/tiyi.v1.AgentService/ListConfigBundles` | unary | (`agent:read`) |
| [`GetConfigBundle`](services/agent.md#agentservicegetconfigbundle) | `/tiyi.v1.AgentService/GetConfigBundle` | unary | (`agent:read`) |

## AgentGroupService

[Full reference →](services/agent.md#agentgroupservice) · `proto/tiyi/v1/agent.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListAgentGroups`](services/agent.md#agentgroupservicelistagentgroups) | `/tiyi.v1.AgentGroupService/ListAgentGroups` | unary | (`agent_group:read`) |
| [`GetAgentGroup`](services/agent.md#agentgroupservicegetagentgroup) | `/tiyi.v1.AgentGroupService/GetAgentGroup` | unary | (`agent_group:read`) |
| [`CreateAgentGroup`](services/agent.md#agentgroupservicecreateagentgroup) | `/tiyi.v1.AgentGroupService/CreateAgentGroup` | unary | (`agent_group:write`) |
| [`UpdateAgentGroup`](services/agent.md#agentgroupserviceupdateagentgroup) | `/tiyi.v1.AgentGroupService/UpdateAgentGroup` | unary | (`agent_group:write`) |
| [`DeleteAgentGroup`](services/agent.md#agentgroupservicedeleteagentgroup) | `/tiyi.v1.AgentGroupService/DeleteAgentGroup` | unary | (`agent_group:delete`) |
| [`ResolveAgentGroup`](services/agent.md#agentgroupserviceresolveagentgroup) | `/tiyi.v1.AgentGroupService/ResolveAgentGroup` | unary | (`agent_group:read`) |

## AgentStreamService

[Full reference →](services/agent.md#agentstreamservice) · `proto/tiyi/v1/agent.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`Connect`](services/agent.md#agentstreamserviceconnect) | `/tiyi.v1.AgentStreamService/Connect` | bidi stream | **public** (no token) |

## EvidenceUploadService

[Full reference →](services/agent.md#evidenceuploadservice) · `proto/tiyi/v1/agent.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`Upload`](services/agent.md#evidenceuploadserviceupload) | `/tiyi.v1.EvidenceUploadService/Upload` | bidi stream | **public** (no token) |

## TrustService

[Full reference →](services/trust.md#trustservice) · `proto/tiyi/v1/trust.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`GetTrustProfile`](services/trust.md#trustservicegettrustprofile) | `/tiyi.v1.TrustService/GetTrustProfile` | unary | (`system:read`) |
| [`SetTrustProfile`](services/trust.md#trustservicesettrustprofile) | `/tiyi.v1.TrustService/SetTrustProfile` | unary | (`system:write`) |
| [`ResetTrustProfile`](services/trust.md#trustserviceresettrustprofile) | `/tiyi.v1.TrustService/ResetTrustProfile` | unary | (`system:write`) |
| [`ExplainTrust`](services/trust.md#trustserviceexplaintrust) | `/tiyi.v1.TrustService/ExplainTrust` | unary | (`system:read`) |
| [`GetTrustStatus`](services/trust.md#trustservicegettruststatus) | `/tiyi.v1.TrustService/GetTrustStatus` | unary | (`system:read`) |
| [`StartClientIPAnalysis`](services/trust.md#trustservicestartclientipanalysis) | `/tiyi.v1.TrustService/StartClientIPAnalysis` | unary | (`system:write`) |
| [`GetClientIPAnalysis`](services/trust.md#trustservicegetclientipanalysis) | `/tiyi.v1.TrustService/GetClientIPAnalysis` | unary | (`system:read`) |
| [`StopClientIPAnalysis`](services/trust.md#trustservicestopclientipanalysis) | `/tiyi.v1.TrustService/StopClientIPAnalysis` | unary | (`system:write`) |
| [`ApplyClientIPAnalysis`](services/trust.md#trustserviceapplyclientipanalysis) | `/tiyi.v1.TrustService/ApplyClientIPAnalysis` | unary | (`system:write`) |

## UserService

[Full reference →](services/user.md#userservice) · `proto/tiyi/v1/user.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListUsers`](services/user.md#userservicelistusers) | `/tiyi.v1.UserService/ListUsers` | unary | (`user:read`) |
| [`GetUser`](services/user.md#userservicegetuser) | `/tiyi.v1.UserService/GetUser` | unary | (`user:read`) |
| [`CreateUser`](services/user.md#userservicecreateuser) | `/tiyi.v1.UserService/CreateUser` | unary | (`user:write`) |
| [`UpdateUser`](services/user.md#userserviceupdateuser) | `/tiyi.v1.UserService/UpdateUser` | unary | (`user:write`) |
| [`DeleteUser`](services/user.md#userservicedeleteuser) | `/tiyi.v1.UserService/DeleteUser` | unary | (`user:delete`) |
| [`AssignRoles`](services/user.md#userserviceassignroles) | `/tiyi.v1.UserService/AssignRoles` | unary | (`user:write`) |
| [`ResetPassword`](services/user.md#userserviceresetpassword) | `/tiyi.v1.UserService/ResetPassword` | unary | (`user:write`) |
| [`LockUser`](services/user.md#userservicelockuser) | `/tiyi.v1.UserService/LockUser` | unary | (`user:write`) |
| [`UnlockUser`](services/user.md#userserviceunlockuser) | `/tiyi.v1.UserService/UnlockUser` | unary | (`user:write`) |
| [`ResetUserMFA`](services/user.md#userserviceresetusermfa) | `/tiyi.v1.UserService/ResetUserMFA` | unary | (`user:write`) |

## RoleService

[Full reference →](services/user.md#roleservice) · `proto/tiyi/v1/user.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListRoles`](services/user.md#roleservicelistroles) | `/tiyi.v1.RoleService/ListRoles` | unary | (`role:read`) |
| [`GetRole`](services/user.md#roleservicegetrole) | `/tiyi.v1.RoleService/GetRole` | unary | (`role:read`) |
| [`CreateRole`](services/user.md#roleservicecreaterole) | `/tiyi.v1.RoleService/CreateRole` | unary | (`role:write`) |
| [`UpdateRole`](services/user.md#roleserviceupdaterole) | `/tiyi.v1.RoleService/UpdateRole` | unary | (`role:write`) |
| [`DeleteRole`](services/user.md#roleservicedeleterole) | `/tiyi.v1.RoleService/DeleteRole` | unary | (`role:delete`) |
| [`ListPermissions`](services/user.md#roleservicelistpermissions) | `/tiyi.v1.RoleService/ListPermissions` | unary | (`role:read`) |

## MenuService

[Full reference →](services/menu.md#menuservice) · `proto/tiyi/v1/menu.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListMenus`](services/menu.md#menuservicelistmenus) | `/tiyi.v1.MenuService/ListMenus` | unary | authenticated |

## AIService

[Full reference →](services/ai.md#aiservice) · `proto/tiyi/v1/ai.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`ListAIProposals`](services/ai.md#aiservicelistaiproposals) | `/tiyi.v1.AIService/ListAIProposals` | unary | (`ai:read`) |
| [`GetAIProposal`](services/ai.md#aiservicegetaiproposal) | `/tiyi.v1.AIService/GetAIProposal` | unary | (`ai:read`) |
| [`GetAIStatus`](services/ai.md#aiservicegetaistatus) | `/tiyi.v1.AIService/GetAIStatus` | unary | (`ai:read`) |
| [`DraftCustomRule`](services/ai.md#aiservicedraftcustomrule) | `/tiyi.v1.AIService/DraftCustomRule` | unary | (`ai:propose`) |
| [`TranslateLogQuery`](services/ai.md#aiservicetranslatelogquery) | `/tiyi.v1.AIService/TranslateLogQuery` | unary | (`ai:read`) |
| [`StreamAnalysis`](services/ai.md#aiservicestreamanalysis) | `/tiyi.v1.AIService/StreamAnalysis` | server stream | `ai:read` and `log:read` |
| [`StreamChat`](services/ai.md#aiservicestreamchat) | `/tiyi.v1.AIService/StreamChat` | server stream | `ai:read` and `log:read` |
| [`ApplyAIProposal`](services/ai.md#aiserviceapplyaiproposal) | `/tiyi.v1.AIService/ApplyAIProposal` | unary | (`ai:apply`) |
| [`RejectAIProposal`](services/ai.md#aiservicerejectaiproposal) | `/tiyi.v1.AIService/RejectAIProposal` | unary | (`ai:propose`) |
| [`SetAIProviderSecret`](services/ai.md#aiservicesetaiprovidersecret) | `/tiyi.v1.AIService/SetAIProviderSecret` | unary | (`system:write`) |

## ApiSchemaService

[Full reference →](services/api_schema.md#apischemaservice) · `proto/tiyi/v1/api_schema.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`GetSchemaValidation`](services/api_schema.md#apischemaservicegetschemavalidation) | `/tiyi.v1.ApiSchemaService/GetSchemaValidation` | unary | `telemetry:read` and `site:read` |
| [`StageApiCatalogChange`](services/api_schema.md#apischemaservicestageapicatalogchange) | `/tiyi.v1.ApiSchemaService/StageApiCatalogChange` | unary | `api_inventory:write` and `site:write` |
| [`GetSchemaLearning`](services/api_schema.md#apischemaservicegetschemalearning) | `/tiyi.v1.ApiSchemaService/GetSchemaLearning` | unary | `telemetry:read` and `site:read` |
| [`ChangeSchemaLearning`](services/api_schema.md#apischemaservicechangeschemalearning) | `/tiyi.v1.ApiSchemaService/ChangeSchemaLearning` | unary | `api_inventory:write` and `site:write` |
| [`SnapshotSchemaLearning`](services/api_schema.md#apischemaservicesnapshotschemalearning) | `/tiyi.v1.ApiSchemaService/SnapshotSchemaLearning` | unary | `api_inventory:write` and `site:write` |
| [`StageLearnedDocument`](services/api_schema.md#apischemaservicestagelearneddocument) | `/tiyi.v1.ApiSchemaService/StageLearnedDocument` | unary | `api_inventory:write` and `site:write` |
| [`ExportLearnedDocument`](services/api_schema.md#apischemaserviceexportlearneddocument) | `/tiyi.v1.ApiSchemaService/ExportLearnedDocument` | unary | `telemetry:read` and `site:read` |
| [`GetApiRequestDocument`](services/api_schema.md#apischemaservicegetapirequestdocument) | `/tiyi.v1.ApiSchemaService/GetApiRequestDocument` | unary | `telemetry:read` and `site:read` |
| [`StageApiRequestDocument`](services/api_schema.md#apischemaservicestageapirequestdocument) | `/tiyi.v1.ApiSchemaService/StageApiRequestDocument` | unary | `api_inventory:write` and `site:write` |
| [`StageSchemaSource`](services/api_schema.md#apischemaservicestageschemasource) | `/tiyi.v1.ApiSchemaService/StageSchemaSource` | unary | `api_inventory:write` and `site:write` |
| [`ListSchemaSources`](services/api_schema.md#apischemaservicelistschemasources) | `/tiyi.v1.ApiSchemaService/ListSchemaSources` | unary | `telemetry:read` and `site:read` |
| [`GetSchemaSource`](services/api_schema.md#apischemaservicegetschemasource) | `/tiyi.v1.ApiSchemaService/GetSchemaSource` | unary | `api_inventory:write` and `site:write` |
| [`ListApiDocumentReports`](services/api_schema.md#apischemaservicelistapidocumentreports) | `/tiyi.v1.ApiSchemaService/ListApiDocumentReports` | unary | `telemetry:read` and `site:read` |
| [`GetApiDocumentReport`](services/api_schema.md#apischemaservicegetapidocumentreport) | `/tiyi.v1.ApiSchemaService/GetApiDocumentReport` | unary | `telemetry:read` and `site:read` |
| [`StageSchemaProfile`](services/api_schema.md#apischemaservicestageschemaprofile) | `/tiyi.v1.ApiSchemaService/StageSchemaProfile` | unary | `api_inventory:write` and `site:write` |
| [`ListSchemaProfiles`](services/api_schema.md#apischemaservicelistschemaprofiles) | `/tiyi.v1.ApiSchemaService/ListSchemaProfiles` | unary | `telemetry:read` and `site:read` |
| [`GetSchemaProfile`](services/api_schema.md#apischemaservicegetschemaprofile) | `/tiyi.v1.ApiSchemaService/GetSchemaProfile` | unary | `telemetry:read` and `site:read` |
| [`PreviewApiDeclaration`](services/api_schema.md#apischemaservicepreviewapideclaration) | `/tiyi.v1.ApiSchemaService/PreviewApiDeclaration` | unary | `telemetry:read` and `site:read` |
| [`StageApiDeclaration`](services/api_schema.md#apischemaservicestageapideclaration) | `/tiyi.v1.ApiSchemaService/StageApiDeclaration` | unary | `api_inventory:write` and `site:write` |
| [`ListSchemaContracts`](services/api_schema.md#apischemaservicelistschemacontracts) | `/tiyi.v1.ApiSchemaService/ListSchemaContracts` | unary | `telemetry:read` and `site:read` |
| [`GetSchemaContract`](services/api_schema.md#apischemaservicegetschemacontract) | `/tiyi.v1.ApiSchemaService/GetSchemaContract` | unary | `telemetry:read` and `site:read` |
| [`PreviewSchemaControl`](services/api_schema.md#apischemaservicepreviewschemacontrol) | `/tiyi.v1.ApiSchemaService/PreviewSchemaControl` | unary | `telemetry:read` and `site:read` |
| [`ChangeSchemaControl`](services/api_schema.md#apischemaservicechangeschemacontrol) | `/tiyi.v1.ApiSchemaService/ChangeSchemaControl` | unary | `api_inventory:write` and `site:write` and `policy:write` |
| [`StageSchemaBindings`](services/api_schema.md#apischemaservicestageschemabindings) | `/tiyi.v1.ApiSchemaService/StageSchemaBindings` | unary | `api_inventory:write` and `site:write` |
| [`GetSchemaBindings`](services/api_schema.md#apischemaservicegetschemabindings) | `/tiyi.v1.ApiSchemaService/GetSchemaBindings` | unary | `telemetry:read` and `site:read` |
| [`ListSchemaBindings`](services/api_schema.md#apischemaservicelistschemabindings) | `/tiyi.v1.ApiSchemaService/ListSchemaBindings` | unary | `telemetry:read` and `site:read` |
| [`GetSchemaDetection`](services/api_schema.md#apischemaservicegetschemadetection) | `/tiyi.v1.ApiSchemaService/GetSchemaDetection` | unary | `telemetry:read` and `site:read` |

## OperationControlService

[Full reference →](services/operation_control.md#operationcontrolservice) · `proto/tiyi/v1/operation_control.proto`

| RPC | Procedure | Kind | Auth |
|---|---|---|---|
| [`GetRequestInspection`](services/operation_control.md#operationcontrolservicegetrequestinspection) | `/tiyi.v1.OperationControlService/GetRequestInspection` | unary | `telemetry:read` and `site:read` and `policy:read` |
| [`PreviewBodyControl`](services/operation_control.md#operationcontrolservicepreviewbodycontrol) | `/tiyi.v1.OperationControlService/PreviewBodyControl` | unary | `api_inventory:write` and `site:write` |
| [`ApplyBodyControl`](services/operation_control.md#operationcontrolserviceapplybodycontrol) | `/tiyi.v1.OperationControlService/ApplyBodyControl` | unary | `api_inventory:write` and `site:write` |
| [`PreviewBodyChange`](services/operation_control.md#operationcontrolservicepreviewbodychange) | `/tiyi.v1.OperationControlService/PreviewBodyChange` | unary | `api_inventory:write` and `site:write` |
| [`ChangeBodyControl`](services/operation_control.md#operationcontrolservicechangebodycontrol) | `/tiyi.v1.OperationControlService/ChangeBodyControl` | unary | `api_inventory:write` and `site:write` |
| [`GetOperationControlState`](services/operation_control.md#operationcontrolservicegetoperationcontrolstate) | `/tiyi.v1.OperationControlService/GetOperationControlState` | unary | `telemetry:read` and `site:read` |
| [`ListOperationControlHistory`](services/operation_control.md#operationcontrolservicelistoperationcontrolhistory) | `/tiyi.v1.OperationControlService/ListOperationControlHistory` | unary | `telemetry:read` and `site:read` |
| [`ReplaceOperationControls`](services/operation_control.md#operationcontrolservicereplaceoperationcontrols) | `/tiyi.v1.OperationControlService/ReplaceOperationControls` | unary | `api_inventory:write` and `site:write` and `policy:write` |
| [`RollbackOperationControls`](services/operation_control.md#operationcontrolservicerollbackoperationcontrols) | `/tiyi.v1.OperationControlService/RollbackOperationControls` | unary | `api_inventory:write` and `site:write` and `policy:write` |
