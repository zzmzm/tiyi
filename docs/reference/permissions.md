<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# Permission catalog

Tiyi ships **59 permissions**. Roles are sets of permissions; a JWT carries the union of its user's roles. `tiyi:superadmin` satisfies every check.

Read the live catalog from a running server with `tiyi role permissions` or `RoleService.ListPermissions` — this page is generated from the same seed data (`permissionSeeds()` in `internal/store/bootstrap.go`).

| Permission | Grants | RPCs |
|---|---|---|
| `site:read` | Read sites and compiled config previews. | [`LogService.GetSiteLogPolicy`](services/log.md#logservicegetsitelogpolicy), [`OperationControlService.GetRequestInspection`](services/operation_control.md#operationcontrolservicegetrequestinspection), [`OperationControlService.GetOperationControlState`](services/operation_control.md#operationcontrolservicegetoperationcontrolstate), [`OperationControlService.ListOperationControlHistory`](services/operation_control.md#operationcontrolservicelistoperationcontrolhistory) _+27 more_ |
| `site:write` | Create, update, enable, and disable sites. | [`LogService.UpsertSiteLogPolicyOverride`](services/log.md#logserviceupsertsitelogpolicyoverride), [`LogService.DeleteSiteLogPolicyOverride`](services/log.md#logservicedeletesitelogpolicyoverride), [`OperationControlService.PreviewBodyControl`](services/operation_control.md#operationcontrolservicepreviewbodycontrol), [`OperationControlService.ApplyBodyControl`](services/operation_control.md#operationcontrolserviceapplybodycontrol) _+23 more_ |
| `site:delete` | Delete sites. | [`SiteService.DeleteSite`](services/site.md#siteservicedeletesite) |
| `site:preview` | Preview compiled Caddy JSON. | [`SiteService.PreviewCompiledConfig`](services/site.md#siteservicepreviewcompiledconfig) |
| `upstream:read` | Read upstream pools. | [`UpstreamService.ListUpstreams`](services/upstream.md#upstreamservicelistupstreams), [`UpstreamService.GetUpstream`](services/upstream.md#upstreamservicegetupstream), [`UpstreamService.ListUpstreamHealth`](services/upstream.md#upstreamservicelistupstreamhealth), [`SiteService.ExportSite`](services/site.md#siteserviceexportsite) _+1 more_ |
| `upstream:write` | Create and update upstream pools. | [`UpstreamService.CreateUpstream`](services/upstream.md#upstreamservicecreateupstream), [`UpstreamService.UpdateUpstream`](services/upstream.md#upstreamserviceupdateupstream), [`SiteService.ImportSite`](services/site.md#siteserviceimportsite) |
| `upstream:delete` | Delete upstream pools. | [`UpstreamService.DeleteUpstream`](services/upstream.md#upstreamservicedeleteupstream) |
| `policy:read` | Read WAF policies, templates, versions, rules, lists, and plugins. | [`PolicyService.ListPolicies`](services/policy.md#policyservicelistpolicies), [`PolicyService.GetPolicy`](services/policy.md#policyservicegetpolicy), [`PolicyService.ListPolicyTemplates`](services/policy.md#policyservicelistpolicytemplates), [`PolicyService.ListPolicyVersions`](services/policy.md#policyservicelistpolicyversions) _+35 more_ |
| `policy:write` | Create, update, rollback, and change policy engine state. | [`PolicyService.CreatePolicy`](services/policy.md#policyservicecreatepolicy), [`PolicyService.CreatePolicyFromTemplate`](services/policy.md#policyservicecreatepolicyfromtemplate), [`PolicyService.UpdatePolicy`](services/policy.md#policyserviceupdatepolicy), [`PolicyService.UpdatePolicyLayer`](services/policy.md#policyserviceupdatepolicylayer) _+9 more_ |
| `policy:delete` | Delete WAF policies. | [`PolicyService.DeletePolicy`](services/policy.md#policyservicedeletepolicy) |
| `policy:preview` | Preview SecLang and CRS impact. | [`PolicyService.PreviewSecLang`](services/policy.md#policyservicepreviewseclang), [`PolicyService.PreviewCrsImpact`](services/policy.md#policyservicepreviewcrsimpact), [`CustomRuleService.PreviewCustomRule`](services/rule.md#customruleservicepreviewcustomrule) |
| `policy:test` | Run synthetic policy tests. | [`PolicyService.TestPolicy`](services/policy.md#policyservicetestpolicy) |
| `policy:crs:write` | Switch active CRS rulesets. | [`PolicyService.SetActiveCrsRuleset`](services/policy.md#policyservicesetactivecrsruleset) |
| `policy:rule:override` | Manage per-CRS-rule overrides. | [`RuleOverrideService.UpsertRuleOverride`](services/rule.md#ruleoverrideserviceupsertruleoverride), [`RuleOverrideService.DeleteRuleOverride`](services/rule.md#ruleoverrideservicedeleteruleoverride), [`RuleOverrideService.BulkUpsertRuleOverrides`](services/rule.md#ruleoverrideservicebulkupsertruleoverrides) |
| `policy:custom:write` | Manage custom visual rules. | [`CustomRuleService.CreateCustomRule`](services/rule.md#customruleservicecreatecustomrule), [`CustomRuleService.UpdateCustomRule`](services/rule.md#customruleserviceupdatecustomrule), [`CustomRuleService.DeleteCustomRule`](services/rule.md#customruleservicedeletecustomrule), [`CustomRuleService.ReorderCustomRules`](services/rule.md#customruleservicereordercustomrules) _+1 more_ |
| `policy:custom:seclang` | Author or import raw SecLang custom rules. | _enforced in-handler or reserved_ |
| `policy:iplist:write` | Manage IP lists and entries. | [`IpListService.CreateIpList`](services/rule.md#iplistservicecreateiplist), [`IpListService.UpdateIpList`](services/rule.md#iplistserviceupdateiplist), [`IpListService.DeleteIpList`](services/rule.md#iplistservicedeleteiplist), [`IpListService.ReplaceIpListEntries`](services/rule.md#iplistservicereplaceiplistentries) _+8 more_ |
| `policy:iplist:source:write` | Manage IP-list subscription sources and write-only request headers. | [`IpListService.CreateIpListSubscription`](services/rule.md#iplistservicecreateiplistsubscription), [`IpListService.UpdateIpListSubscription`](services/rule.md#iplistserviceupdateiplistsubscription), [`IpListService.TestIpListSource`](services/rule.md#iplistservicetestiplistsource) |
| `policy:iplist:sync` | Test, synchronize, pause, and resume IP-list subscriptions. | [`IpListService.SyncIpListNow`](services/rule.md#iplistservicesynciplistnow), [`IpListService.PauseIpListSync`](services/rule.md#iplistservicepauseiplistsync), [`IpListService.ResumeIpListSync`](services/rule.md#iplistserviceresumeiplistsync), [`IpListService.AcceptHeldIpListUpdate`](services/rule.md#iplistserviceacceptheldiplistupdate) _+1 more_ |
| `policy:country:write` | Create, update, and delete country access rules. | [`CountryAccessService.UpsertCountryAccessRule`](services/rule.md#countryaccessserviceupsertcountryaccessrule), [`CountryAccessService.DeleteCountryAccessRule`](services/rule.md#countryaccessservicedeletecountryaccessrule) |
| `cert:read` | Read certificates and public certificate material. | [`CertService.ListCerts`](services/cert.md#certservicelistcerts), [`CertService.GetCert`](services/cert.md#certservicegetcert), [`CertService.ListDNSProviders`](services/cert.md#certservicelistdnsproviders), [`CertService.GetDNSProvider`](services/cert.md#certservicegetdnsprovider) _+1 more_ |
| `cert:write` | Upload certificate PEM material. | [`CertService.UploadCert`](services/cert.md#certserviceuploadcert), [`CertService.CreateDNSProvider`](services/cert.md#certservicecreatednsprovider), [`CertService.UpdateDNSProvider`](services/cert.md#certserviceupdatednsprovider), [`SiteService.ImportSite`](services/site.md#siteserviceimportsite) |
| `cert:issue` | Issue and renew ACME certificates. | [`CertService.IssueACMECert`](services/cert.md#certserviceissueacmecert), [`CertService.RenewCert`](services/cert.md#certservicerenewcert) |
| `cert:export` | Export certificates with private keys. | [`CertService.DownloadCert`](services/cert.md#certservicedownloadcert), [`SiteService.ExportSite`](services/site.md#siteserviceexportsite), [`SiteService.ExportSites`](services/site.md#siteserviceexportsites) |
| `cert:delete` | Delete certificates. | [`CertService.DeleteCert`](services/cert.md#certservicedeletecert), [`CertService.DeleteDNSProvider`](services/cert.md#certservicedeletednsprovider) |
| `agent:read` | Read nodes, events, metrics, and config bundles. | [`AgentService.ListNodes`](services/agent.md#agentservicelistnodes), [`AgentService.ListAgents`](services/agent.md#agentservicelistagents), [`AgentService.GetAgent`](services/agent.md#agentservicegetagent), [`AgentService.GetNodeCapabilities`](services/agent.md#agentservicegetnodecapabilities) _+5 more_ |
| `agent:write` | Update remote-agent metadata and retry node config. | [`AgentService.UpdateAgent`](services/agent.md#agentserviceupdateagent), [`AgentService.RetryNodeConfig`](services/agent.md#agentserviceretrynodeconfig) |
| `agent:delete` | Delete agents and revoke certificates. | [`AgentService.DeleteAgent`](services/agent.md#agentservicedeleteagent) |
| `agent:install` | Issue enrollment tokens and install scripts. | [`AgentService.IssueEnrollmentToken`](services/agent.md#agentserviceissueenrollmenttoken), [`AgentService.CreateNodeInstallation`](services/agent.md#agentservicecreatenodeinstallation), [`AgentService.GetNodeInstallStatus`](services/agent.md#agentservicegetnodeinstallstatus) |
| `agent_group:read` | Read agent groups. | [`AgentGroupService.ListAgentGroups`](services/agent.md#agentgroupservicelistagentgroups), [`AgentGroupService.GetAgentGroup`](services/agent.md#agentgroupservicegetagentgroup), [`AgentGroupService.ResolveAgentGroup`](services/agent.md#agentgroupserviceresolveagentgroup) |
| `agent_group:write` | Create and update agent groups. | [`AgentGroupService.CreateAgentGroup`](services/agent.md#agentgroupservicecreateagentgroup), [`AgentGroupService.UpdateAgentGroup`](services/agent.md#agentgroupserviceupdateagentgroup) |
| `agent_group:delete` | Delete agent groups. | [`AgentGroupService.DeleteAgentGroup`](services/agent.md#agentgroupservicedeleteagentgroup) |
| `log:read` | Query and tail logs. | [`LogService.QuerySecurityEvents`](services/log.md#logservicequerysecurityevents), [`LogService.QueryAccessEvents`](services/log.md#logservicequeryaccessevents), [`LogService.QueryErrorEvents`](services/log.md#logservicequeryerrorevents), [`LogService.GetSecurityEvent`](services/log.md#logservicegetsecurityevent) _+12 more_ |
| `log:export` | Export logs. | [`LogService.ExportSecurityEvents`](services/log.md#logserviceexportsecurityevents), [`LogService.ExportAccessEvents`](services/log.md#logserviceexportaccessevents), [`LogService.ExportErrorEvents`](services/log.md#logserviceexporterrorevents) |
| `telemetry:read` | Read exact telemetry and API inventory counters. | [`OperationControlService.GetRequestInspection`](services/operation_control.md#operationcontrolservicegetrequestinspection), [`OperationControlService.GetOperationControlState`](services/operation_control.md#operationcontrolservicegetoperationcontrolstate), [`OperationControlService.ListOperationControlHistory`](services/operation_control.md#operationcontrolservicelistoperationcontrolhistory), [`ApiSchemaService.GetSchemaValidation`](services/api_schema.md#apischemaservicegetschemavalidation) _+16 more_ |
| `api_inventory:write` | Confirm API assets and stage site-owned body or Schema candidates; staging also requires site:write. | [`OperationControlService.PreviewBodyControl`](services/operation_control.md#operationcontrolservicepreviewbodycontrol), [`OperationControlService.ApplyBodyControl`](services/operation_control.md#operationcontrolserviceapplybodycontrol), [`OperationControlService.PreviewBodyChange`](services/operation_control.md#operationcontrolservicepreviewbodychange), [`OperationControlService.ChangeBodyControl`](services/operation_control.md#operationcontrolservicechangebodycontrol) _+13 more_ |
| `api_inventory:block` | Approve new blocking API controls; runtime changes also require inventory, site, and policy write permissions. | _enforced in-handler or reserved_ |
| `alert:read` | Read and stream alerts. | [`AlertService.ListAlerts`](services/alert.md#alertservicelistalerts), [`AlertService.GetAlert`](services/alert.md#alertservicegetalert), [`AlertService.ListAlertRules`](services/alert.md#alertservicelistalertrules), [`AlertService.GetAlertRule`](services/alert.md#alertservicegetalertrule) _+4 more_ |
| `alert:ack` | Acknowledge alerts. | [`AlertService.AckAlert`](services/alert.md#alertserviceackalert) |
| `alert:resolve` | Resolve alerts. | [`AlertService.ResolveAlert`](services/alert.md#alertserviceresolvealert) |
| `alert:write` | Manage alert rules and channels. | [`AlertService.UpsertAlertRule`](services/alert.md#alertserviceupsertalertrule), [`AlertService.ReplayAlertRule`](services/alert.md#alertservicereplayalertrule), [`AlertService.DeleteAlertRule`](services/alert.md#alertservicedeletealertrule), [`AlertService.UpsertAlertChannel`](services/alert.md#alertserviceupsertalertchannel) _+7 more_ |
| `ai:read` | Use AI log analysis, chat, and read advisory proposals. | [`AIService.ListAIProposals`](services/ai.md#aiservicelistaiproposals), [`AIService.GetAIProposal`](services/ai.md#aiservicegetaiproposal), [`AIService.GetAIStatus`](services/ai.md#aiservicegetaistatus), [`AIService.TranslateLogQuery`](services/ai.md#aiservicetranslatelogquery) _+2 more_ |
| `ai:propose` | Generate AI advisory proposals (drafts; mutates nothing). | [`AIService.DraftCustomRule`](services/ai.md#aiservicedraftcustomrule), [`AIService.RejectAIProposal`](services/ai.md#aiservicerejectaiproposal) |
| `ai:apply` | Apply an AI proposal through the audited mutation path (also requires the target permission). | [`AIService.ApplyAIProposal`](services/ai.md#aiserviceapplyaiproposal) |
| `audit:read` | Query audit log and chain status. | [`AuditService.QueryAudit`](services/audit.md#auditservicequeryaudit), [`AuditService.GetAuditEntry`](services/audit.md#auditservicegetauditentry), [`AuditService.GetChainStatus`](services/audit.md#auditservicegetchainstatus) |
| `audit:verify` | Trigger audit chain verification. | [`AuditService.VerifyChain`](services/audit.md#auditserviceverifychain) |
| `user:read` | Read users. | [`UserService.ListUsers`](services/user.md#userservicelistusers), [`UserService.GetUser`](services/user.md#userservicegetuser) |
| `user:write` | Create, update, and assign user roles. | [`UserService.CreateUser`](services/user.md#userservicecreateuser), [`UserService.UpdateUser`](services/user.md#userserviceupdateuser), [`UserService.AssignRoles`](services/user.md#userserviceassignroles), [`UserService.ResetPassword`](services/user.md#userserviceresetpassword) _+3 more_ |
| `user:delete` | Delete users. | [`UserService.DeleteUser`](services/user.md#userservicedeleteuser) |
| `role:read` | Read roles and permissions. | [`RoleService.ListRoles`](services/user.md#roleservicelistroles), [`RoleService.GetRole`](services/user.md#roleservicegetrole), [`RoleService.ListPermissions`](services/user.md#roleservicelistpermissions) |
| `role:write` | Create and update roles. | [`RoleService.CreateRole`](services/user.md#roleservicecreaterole), [`RoleService.UpdateRole`](services/user.md#roleserviceupdaterole) |
| `role:delete` | Delete roles. | [`RoleService.DeleteRole`](services/user.md#roleservicedeleterole) |
| `system:read` | Read system settings, health, and dashboard statistics. | [`LogService.GetGlobalLogPolicy`](services/log.md#logservicegetgloballogpolicy), [`SystemService.Health`](services/system.md#systemservicehealth), [`SystemService.GetSystemSettings`](services/system.md#systemservicegetsystemsettings), [`SystemService.GetObservationPipelineStats`](services/system.md#systemservicegetobservationpipelinestats) _+4 more_ |
| `system:write` | Update system settings. | [`LogService.UpdateGlobalLogPolicy`](services/log.md#logserviceupdategloballogpolicy), [`AIService.SetAIProviderSecret`](services/ai.md#aiservicesetaiprovidersecret), [`SystemService.UpdateSystemSettings`](services/system.md#systemserviceupdatesystemsettings), [`SystemService.ImportLicense`](services/system.md#systemserviceimportlicense) _+5 more_ |
| `system:apply` | Preview and apply declarative manifests. | [`SystemService.PreviewApply`](services/system.md#systemservicepreviewapply), [`SystemService.Apply`](services/system.md#systemserviceapply) |
| `system:update:read` | Read releases, CRS rulesets, and upgrade runs. | [`CrsService.ListUpstreamCrsExclusionPluginReleases`](services/rule.md#crsservicelistupstreamcrsexclusionpluginreleases), [`SystemService.ListBinaryReleases`](services/system.md#systemservicelistbinaryreleases), [`SystemService.GetBinaryRelease`](services/system.md#systemservicegetbinaryrelease), [`SystemService.ListSystemCrsRulesets`](services/system.md#systemservicelistsystemcrsrulesets) _+7 more_ |
| `system:update:write` | Import and delete releases and CRS rulesets. | [`CrsService.ImportCrsExclusionPlugin`](services/rule.md#crsserviceimportcrsexclusionplugin), [`SystemService.ImportBinaryRelease`](services/system.md#systemserviceimportbinaryrelease), [`SystemService.DeleteBinaryRelease`](services/system.md#systemservicedeletebinaryrelease), [`SystemService.ImportCrsRuleset`](services/system.md#systemserviceimportcrsruleset) _+4 more_ |
| `system:update:apply` | Apply, rollback, and cancel upgrades. | [`SystemService.ApplyBinaryRelease`](services/system.md#systemserviceapplybinaryrelease), [`SystemService.RollbackBinaryRelease`](services/system.md#systemservicerollbackbinaryrelease), [`SystemService.CancelUpgradeRun`](services/system.md#systemservicecancelupgraderun) |
| `tiyi:superadmin` | Reserved cross-tenant platform access. | _enforced in-handler or reserved_ |

## Public procedures

These RPCs are reachable without a token. Everything else requires a bearer JWT (or the local admin socket).

| RPC | Why it is public |
|---|---|
| [`AgentService.Enroll`](services/agent.md#agentserviceenroll) | gated by a one-use enrollment token, not a session |
| [`AgentStreamService.Connect`](services/agent.md#agentstreamserviceconnect) | gated by the agent stream token |
| [`EvidenceUploadService.Upload`](services/agent.md#evidenceuploadserviceupload) | gated by the agent stream token |
| [`AuthService.CompleteAuthenticationChallenge`](services/auth.md#authservicecompleteauthenticationchallenge) | finishes a short-lived cookie-bound MFA/RADIUS challenge before any token exists |
| [`AuthService.GetLoginOptions`](services/auth.md#authservicegetloginoptions) | discovers enabled interactive sign-in methods |
| [`AuthService.Login`](services/auth.md#authservicelogin) | issues the first token |
| [`AuthService.Logout`](services/auth.md#authservicelogout) | must succeed even with a stale token |
| [`AuthService.Refresh`](services/auth.md#authservicerefresh) | renews a token that has already expired |

## Permissions without a static RPC binding

A few permissions are checked inside handlers or on the REST telemetry surface in addition to the generated RPC contract:

| Permission | Checked by |
|---|---|
| `telemetry:read` | every `/api/v1/telemetry/*` route (see [HTTP endpoints](../en/api.md#http)) |
| `api_inventory:write` | `POST /api/v1/telemetry/apitree/action` — required for every action (`confirm`, `hide`, `restore`, `block`) |
| `api_inventory:block` | the `block` action on the same route, **and** `policy:write`, because it writes a custom rule |
| `log:read` | declared as an all-of requirement by `AIService.StreamAnalysis` and `AIService.StreamChat` |
| `policy:custom:seclang` | `CustomRuleService.CreateCustomRule` / `UpdateCustomRule` when the rule carries raw SecLang instead of a visual spec |

`policy:rule:override`, `policy:custom:write`, and `policy:iplist:write` are the required granular mutation permissions for their respective resources.

Tiyi seeds three built-in roles: **Administrator** (all permissions), **Auditor** (read-only), and **WAF Operator** (daily WAF tuning without raw SecLang, alert-channel, identity, or platform administration). Create narrower roles with `RoleService.CreateRole` (`tiyi role create`) and assign them with `UserService.AssignRoles`.
