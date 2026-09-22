# Tiyi v3.8.0 release notes

Released on 2026-09-22. Signed Linux amd64 and arm64 packages are available from GitHub and Gitee Releases.

**Upgrade boundary: v3.8.0 requires fresh state. State created by v3.7.2 or
earlier releases cannot be reused.** Archive the complete installation before
the documented purge/rebuild workflow, then re-enroll every remote Agent with
the same v3.8.0 build. Old databases, metrics, identities, spools and cached
bundles are not converted or deleted automatically. Earlier development snapshots are also unsupported upgrade sources. Do not use only a binary
update and restart for this transition. See [Upgrade and migration](upgrade-migration.md).

## Highlights

- **Exact security statistics:** Overview, Enforcement and threshold alerts use counts collected before log sampling. Event Analysis continues to show sampled relationships. Rankings expose coverage loss; a missing sample is not a zero count. Automatic IP remediation respects the rule's site/time/type/severity scope.
- **Console and runtime recovery:** transient session failures offer retry without silently logging out. Bounded diagnostic output and health probes keep slow consumers from stalling request handling; local diagnostics expose pressure and management latency.
- **Reliable operations:** DNS retries and renewal recovery, current upstream health, node-install receipts, safe user/role edits, saved settings drafts, audit verification and alert editing distinguish current results from stale, failed or pending work.

- **Shared protection responses:** configure public status, title, and message for six protection scenarios with common HTML/JSON templates. Give browser and API clients a clear explanation and request ID; see the [complete starter](responses.md).
- **Clearer operational status:** distinguish process liveness, component readiness, and node application results. Enrollment commands support expiry and node limits; site editing states the publication scope.


- **API Assets:** one site-scoped workspace combines discovered endpoints,
  explicit API catalog membership, request counts, latency, status codes and
  document management. Add/Remove catalog actions are independent of hiding
  rows or learning traffic. Publication status comes from matching serving-node
  receipts; failed or unknown state is never presented as applied.
- **API documents and request validation:** import OpenAPI 3.0/3.1/3.2 or
  Swagger 2.0, review address mappings, edit request definitions and examples,
  and apply or restore a reviewed revision. Each endpoint can turn validation
  off, observe, or enforce supported request structure/type checks. Unsupported
  constraints are explained. Requests outside the catalog have a separate
  allow/observe/block action within the published document's scope.
- **Automatic JSON learning:** eligible discovered or declared POST/PUT/PATCH
  endpoints learn bounded successful JSON request structures without retaining
  field values. Review saved versions and export an OpenAPI draft or establish
  an editable specification. Learning never silently changes authored rules
  or enables blocking; learning samples and retained access evidence are separate.
- **Request inspection and uploads:** site policy owns ordinary body, file,
  total-upload, argument and structure capacities. API definitions own validation
  and extra file-field requirements. Use these controls to bound uploads while retaining normal application request handling, including Light-policy sites.
- **Operational clarity and efficiency:** exact Schema statistics, default-off
  violation samples, preserved editing state, clearer publication history and
  WAF/API reason totals make diagnosis more direct. Improved request inspection and editing feedback help operators identify the next action.

## Upgrade and verification

Follow the backup, purge, retained-binary update, fresh service installation,
resource rebuild and Agent re-enrollment steps in
[Upgrade and migration](upgrade-migration.md#incompatible-state-update).
Keep the old binary and its complete state/config archive together for rollback;
never restore that state into v3.8.0 live paths. Use the same v3.8.0 build for the Controller and all remote Agents; mixed old/new state and node protocols are unsupported.

After rebuilding, check `tiyi --version`, `sudo tiyi system health`, site routing,
TLS, WAF responses and the current configuration result on every serving node.
The admin UI requires a browser with ES2020 and native BigInt support.

After publication, signed Linux amd64/arm64 downloads, `SHA256SUMS`, `SHA256SUMS.sig` and
`release-manifest.json` will be on the
[GitHub release](https://github.com/zzmzm/tiyi/releases/tag/v3.8.0) and
[Gitee mirror](https://gitee.com/tiyisec/tiyi/releases/tag/v3.8.0).

## Start using the features

[First protected site](getting-started.md) · [copyable configuration](configuration.md) · [site import JSON](site-import.md) · [OpenAPI walkthrough](api-protection.md) · [CLI](cli.md) · [API authentication and full reference](api.md).
