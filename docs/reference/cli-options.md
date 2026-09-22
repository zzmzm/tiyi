# CLI flags and commands / CLI 参数全集

v3.8.0 preparation snapshot (2026-09-22, not yet published). Command signatures come from the current source build; check the installed version with `tiyi --version`.
本表从当前源码构建的 help 输出提取；请用安装版本的 `tiyi COMMAND --help` 核对差异。

[English task guide](../en/cli.md) · [中文任务指南](../zh/cli.md)

Default socket paths shown below reflect the user running help. System services use `/run/tiyi/admin.sock`;
set `--admin-socket PATH` for a custom foreground instance. The option reference describes arguments, not permission to perform changes.
以下 socket 默认值来自生成 help 的用户环境；系统服务使用 `/run/tiyi/admin.sock`，自定义实例请显式传路径。


## tiyi

```text
Tiyi — single-binary WAF-enabled reverse proxy

Usage:
  tiyi [command]

Available Commands:
  admin            Local administrator maintenance
  agent            Run a remote data plane (Caddy + Coraza, receives config from Tiyi)
  agent-group      Manage agent groups
  agents           Manage enrolled remote agents
  alert            Manage alerts, alert rules, and notification channels
  api-document     Import API declarations and control request validation
  apply            Apply a YAML manifest (kubectl-style declarative management)
  audit            Query audit events and verify the audit chain
  auth             Authenticate against the Tiyi API
  cert             Manage TLS certificates
  completion       Generate the autocompletion script for the specified shell
  crs              Import and browse OWASP CRS rulesets
  dashboard        Serve the optional stateless UI client
  diff             Show the diff between a manifest and current state
  doctor           Check local installation prerequisites and common startup blockers
  get              Read resources declaratively
  help             Help about any command
  install          Install a hardened systemd unit and (with --now) enable + start it
  log              Query security, access, and error logs
  policy           Manage WAF policies
  release          Import and roll out Tiyi binary releases
  role             Manage roles and permissions
  rule             Manage WAF rule tuning
  run              Run the complete Tiyi instance with its built-in local data plane
  site             Manage sites
  system           Read system health and manage settings
  trust            Configure how Tiyi identifies the client IP for each request
  uninstall        Stop and remove the systemd unit (preserves data unless --purge)
  update           Download, verify, and install the latest signed Tiyi release
  upstream         Manage reusable upstream pools
  user             Manage users
  version          Print version, commit, and build metadata

Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
  -h, --help               help for tiyi
      --log-level string   override log level: debug | info | warn | error
  -v, --version            version for tiyi

Use "tiyi [command] --help" for more information about a command.
```

## tiyi admin

```text
Local administrator maintenance

Usage:
  tiyi admin [command]

Available Commands:
  init        Create the first local administrator

Flags:
  -h, --help   help for admin

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi admin [command] --help" for more information about a command.
```

## tiyi agent

```text
Run a remote data plane (Caddy + Coraza, receives config from Tiyi)

Usage:
  tiyi agent [flags]
  tiyi agent [command]

Available Commands:
  reset-enroll Back up stopped Agent state and prepare for enrollment again

Flags:
      --agent-id string             existing enrolled agent id; defaults to state-dir identity
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default "/var/lib/tiyi/caddy-admin.sock")
      --controller-url string       Tiyi instance URL
      --enrollment-token string     enrollment token for first startup
      --fingerprint string          stable agent fingerprint; generated on first startup when omitted
  -h, --help                        help for agent
      --no-proxy                    receive and cache bundles without starting embedded Caddy
      --once                        connect once, apply at most one pending bundle, then exit
      --once-wait duration          maximum wait for a config update when --once is set (default 5s)
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites (default ":443")
      --state-dir string            agent state directory (default "/var/lib/tiyi/agent")
      --stream-token string         existing agent stream token; defaults to state-dir identity

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi agent [command] --help" for more information about a command.
```

## tiyi agent-group

```text
Manage agent groups

Usage:
  tiyi agent-group [command]

Aliases:
  agent-group, agent-groups

Available Commands:
  create      Create an agent group
  delete      Delete an agent group
  get         Get one agent group
  list        List agent groups

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for agent-group
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi agent-group [command] --help" for more information about a command.
```

## tiyi agents

```text
Manage enrolled remote agents

Usage:
  tiyi agents [command]

Aliases:
  agents, agent-status

Available Commands:
  bundle          Get one config bundle
  bundles         List config bundles
  get             Get one agent
  install-command Generate an expiring installation command with a node limit
  issue-token     Issue a bounded remote-agent enrollment token
  list            List enrolled remote agents

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for agents
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi agents [command] --help" for more information about a command.
```

## tiyi alert

```text
Manage alerts, alert rules, and notification channels

Usage:
  tiyi alert [command]

Available Commands:
  ack         Acknowledge an open alert
  channel     Manage alert channels
  get         Get one alert
  list        List alerts
  notes       List the timeline notes for an alert
  resolve     Resolve an open or acknowledged alert
  rule        Manage alert rules
  silence     Manage maintenance-window silences

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for alert
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi alert [command] --help" for more information about a command.
```

## tiyi api-document

```text
Import API declarations and control request validation

Usage:
  tiyi api-document [command]

Available Commands:
  binding             Call the API document service with an explicit JSON request
  bindings            Call the API document service with an explicit JSON request
  bindings-stage      Call the API document service with an explicit JSON request
  declaration         Call the API document service with an explicit JSON request
  declaration-preview Call the API document service with an explicit JSON request
  declaration-stage   Call the API document service with an explicit JSON request
  declarations        Call the API document service with an explicit JSON request
  detection           Call the API document service with an explicit JSON request
  learning            Call the API document service with an explicit JSON request
  learning-change     Call the API document service with an explicit JSON request
  learning-export     Call the API document service with an explicit JSON request
  learning-snapshot   Call the API document service with an explicit JSON request
  learning-stage      Call the API document service with an explicit JSON request
  preview             Call the API document service with an explicit JSON request
  profile             Call the API document service with an explicit JSON request
  profile-stage       Call the API document service with an explicit JSON request
  profiles            Call the API document service with an explicit JSON request
  publish             Call the API document service with an explicit JSON request
  report              Call the API document service with an explicit JSON request
  reports             Call the API document service with an explicit JSON request
  source              Call the API document service with an explicit JSON request
  sources             Call the API document service with an explicit JSON request
  upload              Stage an OpenAPI 3.0/3.1/3.2 or Swagger 2.0 JSON/YAML file

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for api-document
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi api-document [command] --help" for more information about a command.
```

## tiyi apply

```text
Apply a YAML manifest (kubectl-style declarative management)

Usage:
  tiyi apply [flags]

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
      --dry-run               preview only; do not persist
  -f, --file string           manifest file or '-' for stdin
  -h, --help                  help for apply
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi audit

```text
Query audit events and verify the audit chain

Usage:
  tiyi audit [command]

Available Commands:
  get         Get one audit event
  list        List audit events
  status      Show audit chain health
  verify      Verify audit-chain integrity

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for audit
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi audit [command] --help" for more information about a command.
```

## tiyi auth

```text
Authenticate against the Tiyi API

Usage:
  tiyi auth [command]

Available Commands:
  access-codes Print the current user's access codes
  login        Login and print an access token response
  user         Print the current authenticated user

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for auth
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi auth [command] --help" for more information about a command.
```

## tiyi cert

```text
Manage TLS certificates

Usage:
  tiyi cert [command]

Aliases:
  cert, certs, certificate, certificates

Available Commands:
  delete       Delete a certificate
  dns-provider Manage ACME DNS-01 providers
  download     Download certificate PEM material
  get          Get certificate metadata
  issue        Issue an ACME certificate for one or more domains
  list         List certificates
  renew        Renew a managed certificate
  upload       Upload certificate and private key PEM files

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for cert
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi cert [command] --help" for more information about a command.
```

## tiyi completion

```text
Generate the autocompletion script for tiyi for the specified shell.
See each sub-command's help for details on how to use the generated script.

Usage:
  tiyi completion [command]

Available Commands:
  bash        Generate the autocompletion script for bash
  fish        Generate the autocompletion script for fish
  powershell  Generate the autocompletion script for powershell
  zsh         Generate the autocompletion script for zsh

Flags:
  -h, --help   help for completion

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi completion [command] --help" for more information about a command.
```

## tiyi crs

```text
Import and browse OWASP CRS rulesets

Usage:
  tiyi crs [command]

Aliases:
  crs, rulesets

Available Commands:
  categories    List CRS rule categories
  delete        Delete an imported CRS ruleset
  get           Get one imported CRS ruleset
  ingest        Import a CRS ruleset (local path, vendored tree, GitHub tag, or offline archive)
  list          List imported CRS rulesets
  plugin-schema Get a CRS plugin config schema
  plugins       List CRS plugin hooks
  releases      List CRS releases from github.com/coreruleset/coreruleset
  rule          Get one CRS rule
  rules         List CRS rules in a ruleset

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for crs
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi crs [command] --help" for more information about a command.
```

## tiyi dashboard

```text
Serve the optional stateless UI client

Usage:
  tiyi dashboard [flags]

Flags:
      --addr string                 override HTTP listen address (default "0.0.0.0:8080")
      --admin-socket string         local Unix socket for passwordless operator CLI; empty disables (default "/run/user/1000/tiyi/admin.sock")
      --admin-socket-group string   group owner for the local admin socket
      --admin-socket-mode string    file mode for the local admin socket (default "0600")
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default "/var/lib/tiyi/caddy-admin.sock")
  -h, --help                        help for dashboard
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites (default ":443")
      --state-db string             override path to state.db (default "/var/lib/tiyi/state.db")

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi diff

```text
Show the diff between a manifest and current state

Usage:
  tiyi diff [flags]

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -f, --file string           manifest file or '-' for stdin
  -h, --help                  help for diff
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi doctor

```text
Check the local host before starting Tiyi.

Doctor loads the same config and CLI overrides as the runtime commands,
then checks systemd availability, sudo PATH visibility, service state
ownership when a systemd unit is installed, and TCP port listeners that
commonly block a first install.

Usage:
  tiyi doctor [flags]

Flags:
      --addr string                 override HTTP listen address (default "0.0.0.0:8080")
      --admin-socket string         local Unix socket for passwordless operator CLI; empty disables (default "/run/user/1000/tiyi/admin.sock")
      --admin-socket-group string   group owner for the local admin socket
      --admin-socket-mode string    file mode for the local admin socket (default "0600")
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default "/var/lib/tiyi/caddy-admin.sock")
      --fix-state-ownership         repair configured state directory ownership for the service user (requires root)
  -h, --help                        help for doctor
      --mode string                 mode to check: run | agent | dashboard (default "run")
      --no-color                    disable ANSI color in the report
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites (default ":443")
      --service-group string        service group expected to own state (default "tiyi")
      --service-user string         service user expected to own state (default "tiyi")
      --state-db string             override path to state.db (default "/var/lib/tiyi/state.db")

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi get

```text
Read resources declaratively

Usage:
  tiyi get <kind> [name] [flags]

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for get
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi install

```text
Install Tiyi as a systemd service.

Creates the tiyi service user/group (and the tiyi-admin socket group),
writes a hardened Type=simple unit to /etc/systemd/system, and runs
`systemctl daemon-reload`. With --now it also enables and starts the unit;
a first run-mode install prints the one-time administrator login here.

The unit runs unprivileged and binds ports 80/443 via CAP_NET_BIND_SERVICE.
Preview the generated unit without root using `tiyi install --print`.

Usage:
  tiyi install [flags]

Flags:
      --admin-group string   group that owns the local admin socket; empty disables group ownership (default "tiyi-admin")
      --binary-path string   tiyi binary path baked into ExecStart (default: this executable)
      --group string         service group to create and run as (default "tiyi")
  -h, --help                 help for install
      --mode string          run mode the unit launches: run | agent (default "run")
      --now                  enable and start the unit immediately (systemctl enable --now)
      --print                print the generated unit to stdout and exit (no root required)
      --unit-name string     systemd unit name (without .service) (default "tiyi")
      --user string          service user to create and run as (default "tiyi")

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi log

```text
Query security, access, and error logs

Usage:
  tiyi log [command]

Available Commands:
  access        Query access events
  error         Query error events
  security      Query security events
  tail-security Stream live security events as JSON lines

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for log
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi log [command] --help" for more information about a command.
```

## tiyi policy

```text
Manage WAF policies

Usage:
  tiyi policy [command]

Aliases:
  policy, policies

Available Commands:
  bind-plugin          Bind a CRS plugin to a WAF policy
  create               Create a WAF policy
  create-from-template Create a WAF policy from a template
  delete               Delete a WAF policy
  diff                 Diff two policy versions
  get                  Get a WAF policy
  layer                Manage typed WAF policy layers
  list                 List WAF policies
  preview-impact       Preview CRS rule impact for a WAF policy
  preview-seclang      Preview compiled SecLang for a WAF policy
  rollback             Rollback a WAF policy to a saved version
  set-crs              Set a WAF policy active CRS ruleset
  set-engine           Set a WAF policy engine state
  templates            List WAF policy templates
  test                 Simulate native IP/country rules and Coraza request inspection
  unbind-plugin        Remove a CRS plugin binding from a WAF policy
  update               Update a WAF policy
  version              Get a policy version
  versions             List policy versions

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for policy
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi policy [command] --help" for more information about a command.
```

## tiyi release

```text
Import and roll out Tiyi binary releases

Usage:
  tiyi release [command]

Aliases:
  release, releases

Available Commands:
  apply         Roll a binary release out to matching agents
  check-updates Ask the server whether binary or CRS updates are available
  delete        Delete an imported binary release
  get           Show a single binary release
  import        Import a binary release (from a tarball or a source URL)
  list          List imported binary releases
  rollback      Roll agents back to the previous binary
  run-cancel    Cancel an in-flight upgrade run
  run-get       Show details for a single upgrade run (including wave plan)
  runs          List binary upgrade runs

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for release
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi release [command] --help" for more information about a command.
```

## tiyi role

```text
Manage roles and permissions

Usage:
  tiyi role [command]

Aliases:
  role, roles

Available Commands:
  create      Create a custom role
  delete      Delete a custom role
  get         Get one role
  list        List roles
  permissions List all available permission codes

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for role
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi role [command] --help" for more information about a command.
```

## tiyi rule

```text
Manage WAF rule tuning

Usage:
  tiyi rule [command]

Available Commands:
  binding     Manage IP-list bindings (policy-wide and per-site, with optional path_prefix)
  country     Manage first-class country access rules
  custom      Manage custom SecLang rules
  ip-list     Manage reusable IP lists
  override    Manage CRS rule overrides
  rate-limit  Manage persisted rate-limit endpoints (policy-wide and per-site)

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for rule
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi rule [command] --help" for more information about a command.
```

## tiyi run

```text
Run the complete Tiyi instance with its built-in local data plane

Usage:
  tiyi run [flags]

Flags:
      --addr string                 override HTTP listen address (default "0.0.0.0:8080")
      --admin-socket string         local Unix socket for passwordless operator CLI; empty disables (default "/run/user/1000/tiyi/admin.sock")
      --admin-socket-group string   group owner for the local admin socket
      --admin-socket-mode string    file mode for the local admin socket (default "0600")
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default "/var/lib/tiyi/caddy-admin.sock")
  -h, --help                        help for run
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites (default ":443")
      --state-db string             override path to state.db (default "/var/lib/tiyi/state.db")

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi site

```text
Manage sites

Usage:
  tiyi site [command]

Available Commands:
  create          Create a site
  delete          Delete a site
  disable         Disable a site
  enable          Enable a site
  export          Export all sites by default, or one site by ID, including referenced TLS private key material
  get             Get a site
  import          Import one site configuration or an all-sites archive as new resources
  list            List sites
  policy-override Manage per-site policy overrides
  routing         Manage a site's path routing
  update          Update a site

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for site
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi site [command] --help" for more information about a command.
```

## tiyi system

```text
Read system health and manage settings

Usage:
  tiyi system [command]

Available Commands:
  attack-distribution Read dashboard attack-tag distribution
  health              Read system health
  set-ai-key          Store the AI provider API key from stdin (write-only, encrypted)
  settings            Manage persisted system settings
  stats               Read global node, site, certificate and log health
  top-attackers       Read dashboard top client IP attackers
  traffic             Read dashboard traffic timeseries
  version             Read server build metadata

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for system
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi system [command] --help" for more information about a command.
```

## tiyi trust

```text
Configure the proxy topology and the ordered
Header rules Tiyi uses to identify the real client IP.

Common shapes:

  # Sit behind Cloudflare:
  tiyi trust set --proxy 'Cloudflare CDN=<ip-list-id>' \
      --header CF-Connecting-IP --header X-Forwarded-For

  # Sit behind one internal LB:
  tiyi trust set --proxy 'Internal LB=<ip-list-id>' --header X-Forwarded-For

  # Multiple ordered hops:
  tiyi trust set --proxy 'Cloudflare CDN=<cloudflare-list-id>' \
      --proxy 'Internal LB=<lb-list-id>' \
      --header CF-Connecting-IP --header X-Forwarded-For

  # Quick fixed extraction; no topology required:
  tiyi trust set --fixed-header X-Real-IP

  # Replay any request shape to see what the data plane will return:
  tiyi trust test --peer 173.245.48.5 --header 'CF-Connecting-IP: 203.0.113.9'

Usage:
  tiyi trust [command]

Available Commands:
  reset       Restore the safe default (no proxies trusted, no headers honoured)
  set         Set or replace the trust profile
  show        Show the active trust profile
  test        Replay a request against the active profile and explain the result

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for trust
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi trust [command] --help" for more information about a command.
```

## tiyi uninstall

```text
Disable and stop the unit, remove it from /etc/systemd/system, and
reload systemd. State under /var/lib/tiyi, config under /etc/tiyi, and
the service user/group are preserved unless --purge is given.

Usage:
  tiyi uninstall [flags]

Flags:
  -h, --help               help for uninstall
      --purge              also remove /var/lib/tiyi, /etc/tiyi, and the service user/group (DESTRUCTIVE, irreversible)
      --unit-name string   systemd unit name (without .service) (default "tiyi")
  -y, --yes                skip the --purge confirmation prompt

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi update

```text
update checks the configured release channel for a newer signed tiyi
build, downloads it from the selected mirror, and verifies the Ed25519 signature
chain (SHA256SUMS.sig plus the binary's tiyi.sig) against the release key
embedded in this binary before atomically replacing the running executable on
disk.

It does NOT restart the service — restart tiyi (systemd, Docker, …) after a
successful update to run the new version. A tampered, unsigned, or wrong-key
artifact is rejected and the on-disk binary is left untouched.

Defaults come from update.* in the server config (or TIYI_UPDATE_* env);
override with the flags below. The default mirror mode is "auto": GitHub
primary, Gitee fallback. Use --check to report availability only, and --yes to
actually download and install.

Usage:
  tiyi update [flags]

Flags:
      --api-base-url string   GitHub API base URL override (default: update.api_base_url)
      --channel string        release channel: stable | prerelease (default: update.channel)
      --check                 only report whether an update is available
  -h, --help                  help for update
      --mirror string         download mirror: auto | github | gitee (default: update.mirror)
      --repo string           GitHub owner/name for github/auto (default: update.repo / TIYI_UPDATE_REPO)
      --yes                   download, verify, and install without prompting

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi upstream

```text
Manage reusable upstream pools

Usage:
  tiyi upstream [command]

Aliases:
  upstream, upstreams

Available Commands:
  create      Create an upstream pool
  delete      Delete an upstream pool
  get         Get an upstream pool
  health      List Caddy-reported upstream endpoint health by node
  list        List upstream pools
  update      Update an upstream pool

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for upstream
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi upstream [command] --help" for more information about a command.
```

## tiyi user

```text
Manage users

Usage:
  tiyi user [command]

Aliases:
  user, users

Available Commands:
  assign-roles   Replace a user's role assignments
  create         Create a user
  delete         Delete a user
  get            Get one user
  list           List users
  lock           Lock a user account
  reset-password Reset a user's password
  unlock         Unlock a user account

Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for user
      --token string          remote bearer access token (or TIYI_TOKEN)

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error

Use "tiyi user [command] --help" for more information about a command.
```

## tiyi version

```text
Print version, commit, and build metadata

Usage:
  tiyi version [flags]

Flags:
  -h, --help   help for version

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi admin init

```text
Create the first local administrator

Usage:
  tiyi admin init [flags]

Flags:
      --display-name string   admin display name
      --email string          admin email
  -h, --help                  help for init
      --password string       admin password; can also use TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD
      --state-db string       override path to state.db (default "/var/lib/tiyi/state.db")
      --username string       admin username; defaults to auth.bootstrap_admin_username or admin

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi agent reset-enroll

```text
Back up stopped Agent state and prepare for enrollment again

Usage:
  tiyi agent reset-enroll [flags]

Flags:
  -h, --help               help for reset-enroll
      --state-dir string   dedicated agent state directory (default "/var/lib/tiyi/agent")
      --yes                confirm backup and reset of stopped Agent state

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi agent-group create

```text
Create an agent group

Usage:
  tiyi agent-group create [flags]

Flags:
      --agent-id strings   explicit agent IDs; may be repeated
  -h, --help               help for create
      --name string        group name (required)
      --tag strings        tag selectors; may be repeated

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agent-group delete

```text
Delete an agent group

Usage:
  tiyi agent-group delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agent-group get

```text
Get one agent group

Usage:
  tiyi agent-group get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agent-group list

```text
List agent groups

Usage:
  tiyi agent-group list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents bundle

```text
Get one config bundle

Usage:
  tiyi agents bundle <bundle-id> [flags]

Flags:
  -h, --help   help for bundle

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents bundles

```text
List config bundles

Usage:
  tiyi agents bundles [agent-id] [flags]

Flags:
  -h, --help              help for bundles
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents get

```text
Get one agent

Usage:
  tiyi agents get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents install-command

```text
Generate an expiring installation command with a node limit

Usage:
  tiyi agents install-command [flags]

Flags:
      --controller-url string   Tiyi URL used by tiyi agent --controller-url
      --foreground              print the foreground command instead of installing a service
  -h, --help                    help for install-command
      --json                    return both commands, full scripts and the installation receipt as JSON
      --max-nodes int32         maximum distinct nodes registered with this command (1–1000) (default 1)
      --tag strings             tag attached to the enrolled node; may be repeated
      --ttl-seconds int32       enrollment lifetime in seconds (60–2592000) (default 86400)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents issue-token

```text
Issue a bounded remote-agent enrollment token

Usage:
  tiyi agents issue-token [flags]

Flags:
  -h, --help                help for issue-token
      --max-nodes int32     maximum distinct nodes registered with this token (1–1000) (default 1)
      --tag strings         tag attached to agents enrolled with this token; may be repeated
      --ttl-seconds int32   token TTL in seconds (default 86400)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents list

```text
List enrolled remote agents

Usage:
  tiyi agents list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name, fingerprint, or hostname
      --status string     filter by status: online | offline | error

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert ack

```text
Acknowledge an open alert

Usage:
  tiyi alert ack <alert-id> [flags]

Flags:
  -h, --help          help for ack
      --note string   optional note recorded on the alert timeline

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel

```text
Manage alert channels

Usage:
  tiyi alert channel [command]

Available Commands:
  apply       Associate an alert channel with one or more existing rules
  delete      Delete an alert channel
  get         Get one alert channel
  list        List alert channels
  test        Send a test notification through a saved alert channel
  upsert      Create or replace an alert channel

Flags:
  -h, --help   help for channel

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi alert channel [command] --help" for more information about a command.
```

## tiyi alert get

```text
Get one alert

Usage:
  tiyi alert get <alert-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert list

```text
List alerts

Usage:
  tiyi alert list [flags]

Flags:
      --end string        opening time upper bound, RFC3339 (exclusive)
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
      --query string      search alert title and message
      --rule-id string    filter by rule id
      --severity string   filter by severity: info | warning | critical
      --site-id string    filter by site id
      --start string      opening time lower bound, RFC3339 (inclusive)
      --status string     filter by status: active | open | acked | resolved | all (default "active")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert notes

```text
List the timeline notes for an alert

Usage:
  tiyi alert notes <alert-id> [flags]

Flags:
  -h, --help   help for notes

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert resolve

```text
Resolve an open or acknowledged alert

Usage:
  tiyi alert resolve <alert-id> [flags]

Flags:
  -h, --help          help for resolve
      --note string   optional note recorded on the alert timeline

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule

```text
Manage alert rules

Usage:
  tiyi alert rule [command]

Available Commands:
  delete      Delete an alert rule
  get         Get an alert rule
  list        List alert rules
  preview     Preview an unsaved rule notification without sending
  upsert      Create or replace an alert rule

Flags:
  -h, --help   help for rule

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi alert rule [command] --help" for more information about a command.
```

## tiyi alert silence

```text
Manage maintenance-window silences

Usage:
  tiyi alert silence [command]

Available Commands:
  create      Create a silence active from now for the given duration
  delete      Delete a silence
  list        List silences
  preview     Count and sample current unresolved alerts matching a proposed silence

Flags:
  -h, --help   help for silence

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi alert silence [command] --help" for more information about a command.
```

## tiyi api-document binding

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document binding [flags]

Flags:
  -h, --help                  help for binding
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document bindings

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document bindings [flags]

Flags:
  -h, --help                  help for bindings
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document bindings-stage

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document bindings-stage [flags]

Flags:
  -h, --help                  help for bindings-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declaration

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document declaration [flags]

Flags:
  -h, --help                  help for declaration
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declaration-preview

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document declaration-preview [flags]

Flags:
  -h, --help                  help for declaration-preview
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declaration-stage

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document declaration-stage [flags]

Flags:
  -h, --help                  help for declaration-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declarations

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document declarations [flags]

Flags:
  -h, --help                  help for declarations
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document detection

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document detection [flags]

Flags:
  -h, --help                  help for detection
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document learning [flags]

Flags:
  -h, --help                  help for learning
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-change

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document learning-change [flags]

Flags:
  -h, --help                  help for learning-change
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-export

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document learning-export [flags]

Flags:
  -h, --help                  help for learning-export
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-snapshot

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document learning-snapshot [flags]

Flags:
  -h, --help                  help for learning-snapshot
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-stage

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document learning-stage [flags]

Flags:
  -h, --help                  help for learning-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document preview

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document preview [flags]

Flags:
  -h, --help                  help for preview
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document profile

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document profile [flags]

Flags:
  -h, --help                  help for profile
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document profile-stage

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document profile-stage [flags]

Flags:
  -h, --help                  help for profile-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document profiles

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document profiles [flags]

Flags:
  -h, --help                  help for profiles
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document publish

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document publish [flags]

Flags:
  -h, --help                  help for publish
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document report

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document report [flags]

Flags:
  -h, --help                  help for report
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document reports

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document reports [flags]

Flags:
  -h, --help                  help for reports
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document source

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document source [flags]

Flags:
  -h, --help                  help for source
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document sources

```text
Call the API document service with an explicit JSON request

Usage:
  tiyi api-document sources [flags]

Flags:
  -h, --help                  help for sources
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB maximum) (default "-")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document upload

```text
Stage an OpenAPI 3.0/3.1/3.2 or Swagger 2.0 JSON/YAML file

Usage:
  tiyi api-document upload [flags]

Flags:
  -f, --file string              source document path (8 MiB maximum)
  -h, --help                     help for upload
      --idempotency-key string   stable key for exact retries
      --site string              site UUID

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi audit get

```text
Get one audit event

Usage:
  tiyi audit get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi audit list

```text
List audit events

Usage:
  tiyi audit list [flags]

Flags:
      --action string          filter by action, e.g. site.update
      --actor-id string        filter by actor user id
      --cursor string          opaque cursor from a previous audit list response
      --end string             exclusive RFC3339 end time
  -h, --help                   help for list
      --page-size int32        page size (default 50)
      --resource-id string     filter by resource id
      --resource-type string   filter by resource type
      --start string           inclusive RFC3339 start time

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi audit status

```text
Show audit chain health

Usage:
  tiyi audit status [flags]

Flags:
  -h, --help   help for status

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi audit verify

```text
Verify audit-chain integrity

Usage:
  tiyi audit verify [flags]

Flags:
      --end string     exclusive RFC3339 end time
  -h, --help           help for verify
      --start string   inclusive RFC3339 start time

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi auth access-codes

```text
Print the current user's access codes

Usage:
  tiyi auth access-codes [flags]

Flags:
  -h, --help   help for access-codes

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi auth login

```text
Login and print an access token response

Usage:
  tiyi auth login [flags]

Flags:
  -h, --help              help for login
  -p, --password string   password
  -u, --username string   username

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi auth user

```text
Print the current authenticated user

Usage:
  tiyi auth user [flags]

Flags:
  -h, --help   help for user

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert delete

```text
Delete a certificate

Usage:
  tiyi cert delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider

```text
Manage ACME DNS-01 providers

Usage:
  tiyi cert dns-provider [command]

Aliases:
  dns-provider, dns-providers

Available Commands:
  create      Register a new ACME DNS-01 provider
  delete      Delete an ACME DNS-01 provider (soft delete)
  drivers     List the DNS provider drivers the server registry knows
  get         Get one ACME DNS-01 provider
  list        List ACME DNS-01 providers
  update      Update an ACME DNS-01 provider

Flags:
  -h, --help   help for dns-provider

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi cert dns-provider [command] --help" for more information about a command.
```

## tiyi cert download

```text
Download certificate PEM material

Usage:
  tiyi cert download <id> [flags]

Flags:
  -h, --help                  help for download
      --include-private-key   include private key in the PEM bundle
  -o, --out string            write PEM output to file instead of stdout

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert get

```text
Get certificate metadata

Usage:
  tiyi cert get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert issue

```text
Issue an ACME certificate for one or more domains

Usage:
  tiyi cert issue <domain> [domain...] [flags]

Flags:
      --acme-issuer string      ACME issuer: letsencrypt | letsencrypt-staging | custom
      --challenge-type string   challenge type: http-01 (default) or dns-01
      --directory-url string    custom ACME directory URL (required with --acme-issuer=custom)
      --email string            ACME account email
  -h, --help                    help for issue
      --name string             certificate display name (defaults to first domain)
      --staging                 use Let's Encrypt staging directory

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert list

```text
List certificates

Usage:
  tiyi cert list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name, DNS name, or fingerprint

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert renew

```text
Renew a managed certificate

Usage:
  tiyi cert renew <id> [flags]

Flags:
      --force   renew even if the certificate is not near expiry
  -h, --help    help for renew

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert upload

```text
Upload certificate and private key PEM files

Usage:
  tiyi cert upload [flags]

Flags:
      --cert-pem string         leaf certificate PEM file
      --chain-pem stringArray   intermediate certificate PEM file; repeatable
  -h, --help                    help for upload
      --key-pem string          private key PEM file
      --name string             certificate name

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi completion bash

```text
Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(tiyi completion bash)

To load completions for every new session, execute once:

#### Linux:

	tiyi completion bash > /etc/bash_completion.d/tiyi

#### macOS:

	tiyi completion bash > $(brew --prefix)/etc/bash_completion.d/tiyi

You will need to start a new shell for this setup to take effect.

Usage:
  tiyi completion bash

Flags:
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi completion fish

```text
Generate the autocompletion script for the fish shell.

To load completions in your current shell session:

	tiyi completion fish | source

To load completions for every new session, execute once:

	tiyi completion fish > ~/.config/fish/completions/tiyi.fish

You will need to start a new shell for this setup to take effect.

Usage:
  tiyi completion fish [flags]

Flags:
  -h, --help              help for fish
      --no-descriptions   disable completion descriptions

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi completion powershell

```text
Generate the autocompletion script for powershell.

To load completions in your current shell session:

	tiyi completion powershell | Out-String | Invoke-Expression

To load completions for every new session, add the output of the above command
to your powershell profile.

Usage:
  tiyi completion powershell [flags]

Flags:
  -h, --help              help for powershell
      --no-descriptions   disable completion descriptions

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi completion zsh

```text
Generate the autocompletion script for the zsh shell.

If shell completion is not already enabled in your environment you will need
to enable it.  You can execute the following once:

	echo "autoload -U compinit; compinit" >> ~/.zshrc

To load completions in your current shell session:

	source <(tiyi completion zsh)

To load completions for every new session, execute once:

#### Linux:

	tiyi completion zsh > "${fpath[1]}/_tiyi"

#### macOS:

	tiyi completion zsh > $(brew --prefix)/share/zsh/site-functions/_tiyi

You will need to start a new shell for this setup to take effect.

Usage:
  tiyi completion zsh [flags]

Flags:
  -h, --help              help for zsh
      --no-descriptions   disable completion descriptions

Global Flags:
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi crs categories

```text
List CRS rule categories

Usage:
  tiyi crs categories <ruleset-id> [flags]

Flags:
  -h, --help   help for categories

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs delete

```text
Delete an imported CRS ruleset

Usage:
  tiyi crs delete <ruleset-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs get

```text
Get one imported CRS ruleset

Usage:
  tiyi crs get <ruleset-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs ingest

```text
Import a CRS ruleset (local path, vendored tree, GitHub tag, or offline archive)

Usage:
  tiyi crs ingest [flags]

Aliases:
  ingest, import

Flags:
      --archive string   local path to a tar.gz or zip archive for offline installs (takes precedence over --path when --tag is not set)
  -h, --help             help for ingest
      --path string      server-local CRS root path; defaults to the vendored reference/coreruleset-4.25.0
      --tag string       GitHub release tag (e.g. v4.11.0); when set, fetches and extracts the upstream tarball

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs list

```text
List imported CRS rulesets

Usage:
  tiyi crs list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs plugin-schema

```text
Get a CRS plugin config schema

Usage:
  tiyi crs plugin-schema <plugin-id> [flags]

Flags:
  -h, --help   help for plugin-schema

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs plugins

```text
List CRS plugin hooks

Usage:
  tiyi crs plugins <ruleset-id> [flags]

Flags:
  -h, --help   help for plugins

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs releases

```text
List CRS releases from github.com/coreruleset/coreruleset

Usage:
  tiyi crs releases [flags]

Flags:
  -h, --help                 help for releases
      --include-prerelease   include pre-release and draft releases
      --limit int32          maximum number of releases to list (max 100) (default 20)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs rule

```text
Get one CRS rule

Usage:
  tiyi crs rule <ruleset-id> <rule-id> [flags]

Flags:
  -h, --help   help for rule

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs rules

```text
List CRS rules in a ruleset

Usage:
  tiyi crs rules <ruleset-id> [flags]

Flags:
      --category string        filter by exact CRS category code, such as 942
  -h, --help                   help for rules
      --page int32             page number (default 1)
      --page-size int32        page size (default 50)
      --paranoia-level int32   filter by exact CRS paranoia level
      --phase int32            filter by exact CRS phase
  -q, --query string           filter by id, file, category, message, severity, or tag
      --severity string        filter by exact CRS severity
      --tag strings            require exact CRS tag; repeat or comma-separate

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log access

```text
Query access events

Usage:
  tiyi log access [command]

Available Commands:
  export      Export matching access events as NDJSON
  get         Get one access event
  list        List access events

Flags:
  -h, --help   help for access

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi log access [command] --help" for more information about a command.
```

## tiyi log error

```text
Query error events

Usage:
  tiyi log error [command]

Available Commands:
  export      Export filtered error events as NDJSON
  get         Get one error event
  list        List error events

Flags:
  -h, --help   help for error

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi log error [command] --help" for more information about a command.
```

## tiyi log security

```text
Query security events

Usage:
  tiyi log security [command]

Available Commands:
  export      Export matching security events as NDJSON
  get         Get one security event
  list        List security events

Flags:
  -h, --help   help for security

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi log security [command] --help" for more information about a command.
```

## tiyi log tail-security

```text
Stream live security events as JSON lines

Usage:
  tiyi log tail-security [flags]

Flags:
      --agent-id string   filter by agent id
      --count int         stop after this many events; 0 tails until interrupted
  -h, --help              help for tail-security
      --site-id string    filter by site id

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy bind-plugin

```text
Bind a CRS plugin to a WAF policy

Usage:
  tiyi policy bind-plugin <policy-id> [flags]

Flags:
      --config-json string                        plugin config JSON object (default "{}")
      --disabled                                  bind the plugin but keep it disabled
  -h, --help                                      help for bind-plugin
      --plugin-id tiyi crs plugins <ruleset-id>   CRS plugin id from tiyi crs plugins <ruleset-id>

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy create

```text
Create a WAF policy

Usage:
  tiyi policy create [flags]

Flags:
      --blocking-mode string    blocking mode: anomaly | self-contained (default "anomaly")
      --crs-ruleset-id string   active CRS ruleset id
      --description string      policy description
      --engine-state string     engine state: on | detection-only | off (default "on")
  -h, --help                    help for create
      --name string             policy name
      --status string           status: draft | active | archived (default "draft")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy create-from-template

```text
Create a WAF policy from a template

Usage:
  tiyi policy create-from-template [flags]

Flags:
      --description string   policy description
  -h, --help                 help for create-from-template
      --name string          policy name
      --template-id string   template policy id

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy delete

```text
Delete a WAF policy

Usage:
  tiyi policy delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy diff

```text
Diff two policy versions

Usage:
  tiyi policy diff <left-version-id> <right-version-id> [flags]

Flags:
  -h, --help   help for diff

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy get

```text
Get a WAF policy

Usage:
  tiyi policy get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy layer

```text
Manage typed WAF policy layers

Usage:
  tiyi policy layer [command]

Available Commands:
  replace     Replace one complete WAF policy layer

Flags:
  -h, --help   help for layer

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi policy layer [command] --help" for more information about a command.
```

## tiyi policy list

```text
List WAF policies

Usage:
  tiyi policy list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or description
      --templates-only    list policy templates only

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy preview-impact

```text
Preview CRS rule impact for a WAF policy

Usage:
  tiyi policy preview-impact <id> [flags]

Flags:
      --crs-ruleset-id string   candidate CRS ruleset id
  -h, --help                    help for preview-impact

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy preview-seclang

```text
Preview compiled SecLang for a WAF policy

Usage:
  tiyi policy preview-seclang <id> [flags]

Aliases:
  preview-seclang, preview

Flags:
  -h, --help   help for preview-seclang

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy rollback

```text
Rollback a WAF policy to a saved version

Usage:
  tiyi policy rollback <policy-id> [flags]

Flags:
  -h, --help                help for rollback
      --version-id string   version id to restore

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy set-crs

```text
Set a WAF policy active CRS ruleset

Usage:
  tiyi policy set-crs <id> [flags]

Flags:
      --crs-ruleset-id string   CRS ruleset id
  -h, --help                    help for set-crs
      --revision int            expected current revision

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy set-engine

```text
Set a WAF policy engine state

Usage:
  tiyi policy set-engine <id> [flags]

Flags:
      --engine-state string   engine state: on | detection-only | off
  -h, --help                  help for set-engine
      --revision int          expected current revision

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy templates

```text
List WAF policy templates

Usage:
  tiyi policy templates [flags]

Flags:
  -h, --help              help for templates
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy test

```text
Simulate native IP/country rules and Coraza request inspection

Usage:
  tiyi policy test <id> [flags]

Flags:
      --body string          request body
      --client-ip string     simulated client IP; no proxy trust resolution (default "192.0.2.1")
      --header stringArray   request header as 'Name: value' (repeatable)
  -h, --help                 help for test
      --method string        request method (default "GET")
      --peer-ip string       simulated connection peer IP; defaults to client IP
      --protocol string      request protocol: HTTP/1.0 | HTTP/1.1 | HTTP/2 | HTTP/3 (default "HTTP/1.1")
      --site-id string       optional site using this policy, including its overlays
      --url string           request URL or path (default "/")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy unbind-plugin

```text
Remove a CRS plugin binding from a WAF policy

Usage:
  tiyi policy unbind-plugin <policy-id> [flags]

Flags:
  -h, --help               help for unbind-plugin
      --plugin-id string   CRS plugin id

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy update

```text
Update a WAF policy

Usage:
  tiyi policy update <id> [flags]

Flags:
      --blocking-mode string    blocking mode: anomaly | self-contained
      --crs-ruleset-id string   active CRS ruleset id
      --description string      policy description
      --engine-state string     engine state: on | detection-only | off
  -h, --help                    help for update
      --name string             policy name
      --revision int            expected current revision
      --status string           status: draft | active | archived

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy version

```text
Get a policy version

Usage:
  tiyi policy version <version-id> [flags]

Flags:
  -h, --help   help for version

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy versions

```text
List policy versions

Usage:
  tiyi policy versions <policy-id> [flags]

Flags:
  -h, --help              help for versions
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release apply

```text
Queues an APPLY_BINARY command for every agent whose OS and arch
match the release. Each agent downloads the replacement from the
Controller's /bootstrap/binary endpoint, verifies the SHA-256, and
exits so the supervisor restarts into the new binary. Use
--agent-id (repeatable) to narrow the fan-out to specific agents,
for example when rolling through waves.

Usage:
  tiyi release apply <release-id> [flags]

Flags:
      --agent-id strings   limit fan-out to these agent ids (repeatable)
  -h, --help               help for apply

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release check-updates

```text
Ask the server whether binary or CRS updates are available

Usage:
  tiyi release check-updates [flags]

Flags:
  -h, --help   help for check-updates

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release delete

```text
Delete an imported binary release

Usage:
  tiyi release delete <release-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release get

```text
Show a single binary release

Usage:
  tiyi release get <release-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release import

```text
Import a binary release (from a tarball or a source URL)

Usage:
  tiyi release import [flags]

Flags:
  -h, --help                help for import
      --source-url string   server-reachable URL the import path will fetch
      --tarball string      local path to a binary release tarball

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release list

```text
List imported binary releases

Usage:
  tiyi release list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release rollback

```text
Roll agents back to the previous binary

Usage:
  tiyi release rollback [flags]

Flags:
      --agent-id strings   limit rollback to these agent ids (repeatable)
  -h, --help               help for rollback

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release run-cancel

```text
Cancel an in-flight upgrade run

Usage:
  tiyi release run-cancel <run-id> [flags]

Flags:
  -h, --help   help for run-cancel

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release run-get

```text
Show details for a single upgrade run (including wave plan)

Usage:
  tiyi release run-get <run-id> [flags]

Flags:
  -h, --help   help for run-get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release runs

```text
List binary upgrade runs

Usage:
  tiyi release runs [flags]

Flags:
  -h, --help              help for runs
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role create

```text
Create a custom role

Usage:
  tiyi role create [flags]

Flags:
      --description string   role description
  -h, --help                 help for create
      --name string          role name (required)
      --permission strings   permission codes; may be repeated

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role delete

```text
Delete a custom role

Usage:
  tiyi role delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role get

```text
Get one role

Usage:
  tiyi role get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role list

```text
List roles

Usage:
  tiyi role list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role permissions

```text
List all available permission codes

Usage:
  tiyi role permissions [flags]

Flags:
  -h, --help   help for permissions

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule binding

```text
Manage IP-list bindings (policy-wide and per-site, with optional path_prefix)

Usage:
  tiyi rule binding [command]

Available Commands:
  delete      Delete an IP-list binding
  list        List IP-list bindings for a policy (optionally filtered to a site)
  upsert      Create or update an IP-list binding

Flags:
  -h, --help   help for binding

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi rule binding [command] --help" for more information about a command.
```

## tiyi rule country

```text
Manage first-class country access rules

Usage:
  tiyi rule country [command]

Available Commands:
  catalog     Show countries available in the active MMDB
  delete      Delete and atomically remove a country access rule
  get         Get one country access rule
  list        List country access rules
  set         Create or update and atomically apply a country access rule

Flags:
  -h, --help   help for country

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi rule country [command] --help" for more information about a command.
```

## tiyi rule custom

```text
Manage custom SecLang rules

Usage:
  tiyi rule custom [command]

Available Commands:
  create      Create a custom SecLang rule
  delete      Delete a custom rule
  get         Get one custom rule
  list        List custom rules for a policy
  preview     Preview one custom SecLang rule
  update      Update a custom SecLang rule

Flags:
  -h, --help   help for custom

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi rule custom [command] --help" for more information about a command.
```

## tiyi rule ip-list

```text
Manage reusable IP lists

Usage:
  tiyi rule ip-list [command]

Available Commands:
  create      Create a manual IP list
  delete      Delete an IP list
  get         Get one IP list
  list        List IP lists
  lookup      Look up an IP address in a list
  pause       Pause scheduled subscription syncs
  replace     Atomically replace a manual list's complete content
  resume      Resume and immediately sync a subscription
  source-test Fetch and validate a saved source without applying it
  subscribe   Create a managed IP-list subscription
  sync        Queue an immediate subscription sync
  sync-status Show recent subscription sync runs

Flags:
  -h, --help   help for ip-list

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi rule ip-list [command] --help" for more information about a command.
```

## tiyi rule override

```text
Manage CRS rule overrides

Usage:
  tiyi rule override [command]

Available Commands:
  delete      Delete a CRS rule override
  get         Get one CRS rule override
  list        List CRS rule overrides for a policy
  upsert      Create or update a CRS rule override

Flags:
  -h, --help   help for override

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi rule override [command] --help" for more information about a command.
```

## tiyi rule rate-limit

```text
Manage persisted rate-limit endpoints (policy-wide and per-site)

Usage:
  tiyi rule rate-limit [command]

Available Commands:
  delete      Delete a rate-limit endpoint
  list        List rate-limit endpoints for a policy (optionally filtered to a site)
  upsert      Create a rate-limit endpoint, or update one by id

Flags:
  -h, --help   help for rate-limit

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi rule rate-limit [command] --help" for more information about a command.
```

## tiyi site create

```text
Create a site

Usage:
  tiyi site create [flags]

Flags:
      --alias stringArray                 host alias; repeatable; supports '*.example.com'; quote wildcard values
      --bot string                        site-wide bot protection: off | browser-check | human-verification (default "off")
      --bot-bind-network                  bind clearance to the client network
      --bot-challenge-ttl int             browser challenge lifetime in seconds (30-600) (default 120)
      --bot-clearance-ttl int             site clearance lifetime in seconds (300-86400) (default 3600)
      --bot-exempt-path stringArray       literal path prefix exempt from bot protection; repeatable
      --bot-proof-difficulty int          proof-of-work leading zero bits (12-24) (default 16)
      --bot-trusted-ip-list stringArray   IP list id exempt from bot protection; repeatable
      --health-check-path string          inline upstream active health-check path
  -h, --help                              help for create
      --host string                       primary host; '*.example.com' matches one subdomain level, not the root domain
      --name string                       site display name
      --tls string                        TLS mode: none | managed-acme | uploaded (default "managed-acme")
      --tls-cert-id string                uploaded certificate id when --tls uploaded
      --tls-http-behavior string          HTTP behavior for TLS sites: redirect | acme-only | serve-both (default "redirect")
      --tls-min-version string            minimum TLS version: 1.2 | 1.3
      --upstream-url stringArray          inline upstream URL; repeatable
      --waf                               enable WAF (default true)
      --waf-mode string                   WAF mode: blocking | detection (default "blocking")
      --waf-policy string                 WAF policy id for live enforcement

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site delete

```text
Delete a site

Usage:
  tiyi site delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site disable

```text
Disable a site

Usage:
  tiyi site disable <id> [flags]

Flags:
  -h, --help           help for disable
      --revision int   expected current revision

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site enable

```text
Enable a site

Usage:
  tiyi site enable <id> [flags]

Flags:
  -h, --help           help for enable
      --revision int   expected current revision

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site export

```text
Export all sites by default, or one site by ID, including referenced TLS private key material

Usage:
  tiyi site export [id] [flags]

Flags:
      --force           overwrite an existing output file
  -h, --help            help for export
  -o, --output string   output file (default: server-provided name; use - for stdout)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site get

```text
Get a site

Usage:
  tiyi site get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site import

```text
Import one site configuration or an all-sites archive as new resources

Usage:
  tiyi site import <file> [flags]

Flags:
  -h, --help   help for import

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site list

```text
List sites

Usage:
  tiyi site list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or primary host
      --status string     filter by status: active | disabled | deleted | error

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override

```text
Manage per-site policy overrides

Usage:
  tiyi site policy-override [command]

Available Commands:
  delete      Remove a per-site policy override
  get         Show the policy override (if any) for a site
  set         Upsert a per-site policy override

Flags:
  -h, --help   help for policy-override

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi site policy-override [command] --help" for more information about a command.
```

## tiyi site routing

```text
Manage a site's path routing

Usage:
  tiyi site routing [command]

Available Commands:
  get         Show a site's path routing
  set         Replace a site's path routing

Flags:
  -h, --help   help for routing

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi site routing [command] --help" for more information about a command.
```

## tiyi site update

```text
Update a site

Usage:
  tiyi site update <id> [flags]

Flags:
      --alias stringArray                 host alias; repeatable; supports '*.example.com'; quote wildcard values
      --bot string                        site-wide bot protection: off | browser-check | human-verification
      --bot-bind-network                  bind clearance to the client network
      --bot-challenge-ttl int             browser challenge lifetime in seconds (30-600)
      --bot-clearance-ttl int             site clearance lifetime in seconds (300-86400)
      --bot-exempt-path stringArray       literal path prefix exempt from bot protection; repeatable
      --bot-proof-difficulty int          proof-of-work leading zero bits (12-24)
      --bot-trusted-ip-list stringArray   IP list id exempt from bot protection; repeatable
      --health-check-path string          inline upstream active health-check path
  -h, --help                              help for update
      --host string                       primary host; '*.example.com' matches one subdomain level, not the root domain
      --name string                       site display name
      --revision int                      expected current revision
      --tls string                        TLS mode: none | managed-acme | uploaded
      --tls-cert-id string                uploaded certificate id when --tls uploaded
      --tls-http-behavior string          HTTP behavior for TLS sites: redirect | acme-only | serve-both
      --tls-min-version string            minimum TLS version: 1.2 | 1.3
      --upstream-url stringArray          inline upstream URL; repeatable
      --waf                               enable WAF
      --waf-mode string                   WAF mode: blocking | detection
      --waf-policy string                 WAF policy id for live enforcement

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system attack-distribution

```text
Read dashboard attack-tag distribution

Usage:
  tiyi system attack-distribution [flags]

Flags:
      --end string     exclusive RFC3339 end time
  -h, --help           help for attack-distribution
      --limit int32    maximum number of rows (default 10)
      --start string   inclusive RFC3339 start time

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system health

```text
Read system health

Usage:
  tiyi system health [flags]

Flags:
  -h, --help   help for health

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system set-ai-key

```text
Store the AI provider API key under the KEK/DEK envelope (requires system:write).

The key is read from stdin to keep it out of argv and shell history, is never
returned by any RPC, and an empty value is a no-op that preserves the stored key.

  printf %s "$OPENAI_API_KEY" | tiyi system set-ai-key

Usage:
  tiyi system set-ai-key [flags]

Flags:
  -h, --help   help for set-ai-key

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system settings

```text
Manage persisted system settings

Usage:
  tiyi system settings [command]

Available Commands:
  get         Read all persisted system settings
  update      Update persisted system settings

Flags:
  -h, --help   help for settings

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)

Use "tiyi system settings [command] --help" for more information about a command.
```

## tiyi system stats

```text
Read global node, site, certificate and log health

Usage:
  tiyi system stats [flags]

Flags:
  -h, --help   help for stats

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system top-attackers

```text
Read dashboard top client IP attackers

Usage:
  tiyi system top-attackers [flags]

Flags:
      --end string     exclusive RFC3339 end time
  -h, --help           help for top-attackers
      --limit int32    maximum number of rows (default 10)
      --start string   inclusive RFC3339 start time

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system traffic

```text
Read dashboard traffic timeseries

Usage:
  tiyi system traffic [flags]

Flags:
      --bucket-size string   bucket size: 1m | 5m | 15m | 1h | 1d (default "1h")
      --end string           exclusive RFC3339 end time
  -h, --help                 help for traffic
      --start string         inclusive RFC3339 start time

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system version

```text
Read server build metadata

Usage:
  tiyi system version [flags]

Flags:
  -h, --help   help for version

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust reset

```text
Restore the safe default (no proxies trusted, no headers honoured)

Usage:
  tiyi trust reset [flags]

Flags:
  -h, --help          help for reset
      --site string   reset only the per-site override
      --yes           confirm the destructive operation

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust set

```text
Replace the trust profile with stable IP-list references and an
ordered Header list. --proxy expects NAME=IP_LIST_ID and may be repeated;
distinct names become ordered proxy hops. Source URLs, credentials, schedules,
and content are managed only through
`tiyi rule ip-list`.

Verified --header rules require a proxy path. --fixed-header is the explicit
no-topology escape path. Use --file for alternatives or sparse topologies.

Usage:
  tiyi trust set [flags]

Flags:
  -f, --file string             YAML/JSON profile file ('-' for stdin)
      --fixed-header strings    unverified fixed-position Header (repeatable; ordered)
      --fixed-position uint32   one-based N for --fixed-selector nth-from-right
      --fixed-selector string   fixed extraction: single, leftmost, rightmost, or nth-from-right (default "single")
      --force                   allow non-safelisted forwarded headers (audited)
      --header strings          verified forwarded Header (repeatable; ordered)
  -h, --help                    help for set
      --proxy strings           proxy node as "name=ip-list-id" (repeatable; ordered)
      --site string             apply as per-site override

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust show

```text
Show the active trust profile

Usage:
  tiyi trust show [flags]

Flags:
      --format string   yaml | json | table (default "table")
  -h, --help            help for show
      --site string     show the per-site override (empty ⇒ deployment default)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust test

```text
Replay a request against the active profile and explain the result

Usage:
  tiyi trust test [flags]

Flags:
      --header strings   header line; repeatable; format "Name: value"
  -h, --help             help for test
      --peer string      the peer address (e.g. 198.51.100.7)
      --site string      evaluate against a per-site override

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream create

```text
Create an upstream pool

Usage:
  tiyi upstream create [flags]

Flags:
      --description string                 upstream pool description
      --endpoint-url stringArray           backend URL; repeatable
      --endpoint-weight int32Slice         endpoint weight 1..100 in --endpoint-url order (default [])
      --failover-retry                     retry safe requests against another available endpoint (default true)
      --health-check-method string         active health-check method: GET | HEAD (default "GET")
      --health-check-path string           pool-level active health-check path; empty disables
      --health-expected-body string        optional RE2 response-body expression
      --health-expected-status int32       expected HTTP status or class (for example 200 or 2) (default 200)
      --health-follow-redirects            follow redirects during active health checks
      --health-healthy-threshold int32     consecutive passes before Caddy marks an endpoint healthy (default 2)
      --health-host string                 optional Host header for backend probes
      --health-interval int32              probe interval in seconds (default 30)
      --health-timeout int32               probe timeout in seconds (default 5)
      --health-unhealthy-threshold int32   consecutive failures before Caddy marks an endpoint unhealthy (default 3)
  -h, --help                               help for create
      --name string                        upstream pool name
      --passive-fail-duration int32        seconds to remember each proxy failure (default 30)
      --passive-health                     eject endpoints after real proxy failures (default true)
      --passive-max-fails int32            remembered failures before an endpoint is ejected (default 2)
      --request-header stringArray         plaintext origin request header as 'Name: value'; repeatable
      --retry-duration int32               maximum retry selection window in seconds (default 5)
      --retry-interval-ms int32            delay between retry selections in milliseconds (default 250)
      --status string                      status: active | disabled | error (default "active")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream delete

```text
Delete an upstream pool

Usage:
  tiyi upstream delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream get

```text
Get an upstream pool

Usage:
  tiyi upstream get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream health

```text
List Caddy-reported upstream endpoint health by node

Usage:
  tiyi upstream health [upstream-id] [flags]

Flags:
  -h, --help   help for health

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream list

```text
List upstream pools

Usage:
  tiyi upstream list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or description

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream update

```text
Update an upstream pool

Usage:
  tiyi upstream update <id> [flags]

Flags:
      --description string                 upstream pool description
      --endpoint-url stringArray           backend URL; repeatable
      --endpoint-weight int32Slice         endpoint weight 1..100 in --endpoint-url order (default [])
      --failover-retry                     retry safe requests against another available endpoint (default true)
      --health-check-method string         active health-check method: GET | HEAD (default "GET")
      --health-check-path string           pool-level active health-check path; empty disables
      --health-expected-body string        optional RE2 response-body expression
      --health-expected-status int32       expected HTTP status or class (for example 200 or 2) (default 200)
      --health-follow-redirects            follow redirects during active health checks
      --health-healthy-threshold int32     consecutive passes before Caddy marks an endpoint healthy (default 2)
      --health-host string                 optional Host header for backend probes
      --health-interval int32              probe interval in seconds (default 30)
      --health-timeout int32               probe timeout in seconds (default 5)
      --health-unhealthy-threshold int32   consecutive failures before Caddy marks an endpoint unhealthy (default 3)
  -h, --help                               help for update
      --name string                        upstream pool name
      --passive-fail-duration int32        seconds to remember each proxy failure (default 30)
      --passive-health                     eject endpoints after real proxy failures (default true)
      --passive-max-fails int32            remembered failures before an endpoint is ejected (default 2)
      --request-header stringArray         plaintext origin request header as 'Name: value'; repeatable
      --retry-duration int32               maximum retry selection window in seconds (default 5)
      --retry-interval-ms int32            delay between retry selections in milliseconds (default 250)
      --status string                      status: active | disabled | error

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user assign-roles

```text
Replace a user's role assignments

Usage:
  tiyi user assign-roles <user-id> [flags]

Flags:
  -h, --help              help for assign-roles
      --role-id strings   role IDs; may be repeated

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user create

```text
Create a user

Usage:
  tiyi user create [flags]

Flags:
      --display-name string   display name
      --email string          email address
  -h, --help                  help for create
      --password string       password (required)
      --role-id strings       role IDs to assign; may be repeated
      --username string       username (required)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user delete

```text
Delete a user

Usage:
  tiyi user delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user get

```text
Get one user

Usage:
  tiyi user get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user list

```text
List users

Usage:
  tiyi user list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by username, email, or name

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user lock

```text
Lock a user account

Usage:
  tiyi user lock <user-id> [flags]

Flags:
  -h, --help   help for lock

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user reset-password

```text
Reset a user's password

Usage:
  tiyi user reset-password <user-id> [flags]

Flags:
  -h, --help              help for reset-password
      --password string   new password (required)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user unlock

```text
Unlock a user account

Usage:
  tiyi user unlock <user-id> [flags]

Flags:
  -h, --help   help for unlock

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel apply

```text
Associate an alert channel with one or more existing rules

Usage:
  tiyi alert channel apply <channel-id> <rule-id> [rule-id...] [flags]

Flags:
  -h, --help   help for apply

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel delete

```text
Delete an alert channel

Usage:
  tiyi alert channel delete <channel-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel get

```text
Get one alert channel

Usage:
  tiyi alert channel get <channel-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel list

```text
List alert channels

Usage:
  tiyi alert channel list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel test

```text
Send a test notification through a saved alert channel

Usage:
  tiyi alert channel test <channel-id> [flags]

Flags:
  -h, --help   help for test

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel upsert

```text
Create or replace an alert channel

Usage:
  tiyi alert channel upsert [flags]

Flags:
      --config-json string   channel config JSON object (default "{}")
      --enabled              enable channel; pass --enabled=false to disable (default true)
  -h, --help                 help for upsert
      --id string            existing channel id to replace
      --kind string          kind: webhook | slack | pagerduty | feishu | wecom | email (default "webhook")
      --name string          alert channel name

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule delete

```text
Delete an alert rule

Usage:
  tiyi alert rule delete <rule-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule get

```text
Get an alert rule

Usage:
  tiyi alert rule get <rule-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule list

```text
List alert rules

Usage:
  tiyi alert rule list [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule preview

```text
Preview an unsaved rule notification without sending

Usage:
  tiyi alert rule preview [flags]

Flags:
      --channel-id stringArray     notification channel id; repeatable
      --enabled                    enable rule; pass --enabled=false to disable
      --event string               lifecycle event: firing | repeat | auto_remediation_succeeded | auto_remediation_failed | resolved | operator_resolved (default "firing")
      --expression-json string     rule expression JSON (default "{\"kind\":\"security_threshold\",\"windowSeconds\":300,\"minCount\":1}")
  -h, --help                       help for preview
      --id string                  existing rule id to replace
      --name string                alert rule name
      --notification-json string   rule notification content JSON, keyed by locales and lifecycle events (default "{}")
      --severity string            severity: info | warning | critical (default "warning")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule upsert

```text
Create or replace an alert rule

Usage:
  tiyi alert rule upsert [flags]

Flags:
      --channel-id stringArray     notification channel id; repeatable
      --enabled                    enable rule; pass --enabled=false to disable (default true)
      --expression-json string     rule expression JSON (default "{\"kind\":\"security_threshold\",\"windowSeconds\":300,\"minCount\":1,\"outcome\":\"blocked\"}")
  -h, --help                       help for upsert
      --id string                  existing rule id to replace
      --name string                alert rule name
      --notification-json string   rule notification content JSON, keyed by locales and lifecycle events (default "{}")
      --severity string            severity: info | warning | critical (default "warning")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence create

```text
Create a silence active from now for the given duration

Usage:
  tiyi alert silence create [flags]

Flags:
      --duration-minutes int     silence duration in minutes from now (default 60)
  -h, --help                     help for create
      --matcher stringToString   matcher key=value (severity|kind|siteId|agentId|ruleId); repeatable (default [])
      --reason string            reason recorded on the silence

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence delete

```text
Delete a silence

Usage:
  tiyi alert silence delete <silence-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence list

```text
List silences

Usage:
  tiyi alert silence list [flags]

Flags:
      --active            only list silences whose window is currently active
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence preview

```text
Count and sample current unresolved alerts matching a proposed silence

Usage:
  tiyi alert silence preview [flags]

Flags:
  -h, --help                     help for preview
      --matcher stringToString   severity|kind|siteId|agentId|ruleId=value; repeatable (default [])

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider create

```text
Register a new ACME DNS-01 provider

Usage:
  tiyi cert dns-provider create [flags]

Flags:
      --credentials-file string     path to a JSON file containing driver credentials
      --credentials-json string     inline JSON credentials (use --credentials-file in production)
  -h, --help                        help for create
      --name string                 human-readable provider name
      --propagation-seconds int32   max wait for authoritative-NS propagation before letting the CA validate (default 120)
      --provider string             driver: cloudflare | route53 | aliyun
      --setting stringArray         driver setting in key=value form (repeatable); use sparingly — most drivers run with defaults
      --zones strings               apex zones the provider can publish into; repeatable or comma-separated; empty means catch-all

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider delete

```text
Delete an ACME DNS-01 provider (soft delete)

Usage:
  tiyi cert dns-provider delete <id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider drivers

```text
List the DNS provider drivers the server registry knows

Usage:
  tiyi cert dns-provider drivers [flags]

Aliases:
  drivers, list-drivers

Flags:
  -h, --help   help for drivers

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider get

```text
Get one ACME DNS-01 provider

Usage:
  tiyi cert dns-provider get <id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider list

```text
List ACME DNS-01 providers

Usage:
  tiyi cert dns-provider list [flags]

Flags:
  -h, --help              help for list
      --provider string   filter by driver: cloudflare | route53 | aliyun
      --status string     filter by status: active | disabled

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider update

```text
Update an ACME DNS-01 provider. All fields are required because the proto
contract is replace-shaped — pass --status, --provider, --name, --zones, and
--propagation-seconds with the desired values. Omit --credentials-file and
--credentials-json to keep the stored credentials unchanged.

Usage:
  tiyi cert dns-provider update <id> [flags]

Flags:
      --credentials-file string     path to a JSON file containing driver credentials
      --credentials-json string     inline JSON credentials (use --credentials-file in production)
  -h, --help                        help for update
      --name string                 human-readable provider name
      --propagation-seconds int32   max wait for authoritative-NS propagation before letting the CA validate (default 120)
      --provider string             driver: cloudflare | route53 | aliyun
      --setting stringArray         driver setting in key=value form (repeatable); use sparingly — most drivers run with defaults
      --status string               provider status: active | disabled (default "active")
      --zones strings               apex zones the provider can publish into; repeatable or comma-separated; empty means catch-all

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log access export

```text
Export matching access events as NDJSON

Usage:
  tiyi log access export [flags]

Flags:
      --agent-id string          filter by agent id
      --client-ip-cidr strings   client IP CIDR filter; repeat or comma-separate
      --end string               exclusive RFC3339 end time
  -h, --help                     help for export
      --method string            HTTP method filter
  -o, --out string               write NDJSON output to file instead of stdout
      --path-prefix string       request path prefix filter
      --route-id string          path route id filter
      --site-id string           filter by site id
      --start string             inclusive RFC3339 start time
      --status strings           HTTP status code filter; repeat or comma-separate
      --unique-id string         filter by unique request/event id
      --upstream-id string       resolved upstream pool id filter

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log access get

```text
Get one access event

Usage:
  tiyi log access get <event-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log access list

```text
List access events

Usage:
  tiyi log access list [flags]

Flags:
      --agent-id string          filter by agent id
      --client-ip-cidr strings   client IP CIDR filter; repeat or comma-separate
      --cursor string            cursor returned by a previous page
      --end string               exclusive RFC3339 end time
  -h, --help                     help for list
      --method string            HTTP method filter
      --page-size int32          page size (default 50)
      --path-prefix string       request path prefix filter
      --route-id string          path route id filter
      --site-id string           filter by site id
      --start string             inclusive RFC3339 start time
      --status strings           HTTP status code filter; repeat or comma-separate
      --unique-id string         filter by unique request/event id
      --upstream-id string       resolved upstream pool id filter

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log error export

```text
Export filtered error events as NDJSON

Usage:
  tiyi log error export [flags]

Flags:
      --agent-id string    filter by agent id
      --end string         exclusive RFC3339 end time
  -h, --help               help for export
      --level string       log level filter
      --logger string      literal logger substring (case sensitive)
      --message string     literal message substring (case sensitive)
  -o, --out string         write NDJSON output to file instead of stdout
      --site-id string     filter by site id
      --start string       inclusive RFC3339 start time
      --unique-id string   filter by unique request/event id

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log error get

```text
Get one error event

Usage:
  tiyi log error get <event-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log error list

```text
List error events

Usage:
  tiyi log error list [flags]

Flags:
      --agent-id string    filter by agent id
      --cursor string      cursor returned by a previous page
      --end string         exclusive RFC3339 end time
  -h, --help               help for list
      --level string       log level filter
      --logger string      literal logger substring (case sensitive)
      --message string     literal message substring (case sensitive)
      --page-size int32    page size (default 50)
      --site-id string     filter by site id
      --start string       inclusive RFC3339 start time
      --unique-id string   filter by unique request/event id

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log security export

```text
Export matching security events as NDJSON

Usage:
  tiyi log security export [flags]

Flags:
      --agent-id string          filter by agent id
      --attack-type strings      attack type filter; repeat or comma-separate
      --client-ip-cidr strings   client IP CIDR filter; repeat or comma-separate
      --end string               exclusive RFC3339 end time
  -h, --help                     help for export
  -o, --out string               write NDJSON output to file instead of stdout
      --outcome string           transaction outcome: any, blocked, or passed (default "any")
      --rule-id strings          CRS/custom rule id filter; repeat or comma-separate
      --site-id string           filter by site id
      --start string             inclusive RFC3339 start time
      --target string            exact target identity filter
      --unique-id string         filter by unique request/event id

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log security get

```text
Get one security event

Usage:
  tiyi log security get <event-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log security list

```text
List security events

Usage:
  tiyi log security list [flags]

Flags:
      --agent-id string          filter by agent id
      --attack-type strings      attack type filter; repeat or comma-separate
      --client-ip-cidr strings   client IP CIDR filter; repeat or comma-separate
      --cursor string            cursor returned by a previous page
      --end string               exclusive RFC3339 end time
  -h, --help                     help for list
      --outcome string           transaction outcome: any, blocked, or passed (default "any")
      --page-size int32          page size (default 50)
      --rule-id strings          CRS/custom rule id filter; repeat or comma-separate
      --site-id string           filter by site id
      --start string             inclusive RFC3339 start time
      --target string            exact target identity filter
      --unique-id string         filter by unique request/event id

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy layer replace

```text
Replace one complete WAF policy layer. The supplied JSON is the new layer, not a merge patch; omitted fields return to their inherited or default values.

Usage:
  tiyi policy layer replace <policy-id> <crs-core|http-policy|arg-limits> [flags]

Flags:
      --file string    read the complete layer from a JSON file
  -h, --help           help for replace
      --json string    complete layer as a JSON object
      --revision int   expected current revision

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule binding delete

```text
Delete an IP-list binding

Usage:
  tiyi rule binding delete <binding-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule binding list

```text
List IP-list bindings for a policy (optionally filtered to a site)

Usage:
  tiyi rule binding list <policy-id> [flags]

Flags:
  -h, --help             help for list
      --site-id string   filter to bindings for this site (plus policy-wide bindings)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule binding upsert

```text
Create or update an IP-list binding

Usage:
  tiyi rule binding upsert [flags]

Flags:
      --action string           binding action: allow | deny | monitor (default "deny")
      --address-source string   address identity: client_ip | peer_ip (default "client_ip")
      --bypass-mode string      allow behavior: ip_lists_only | all_waf (default "ip_lists_only")
  -h, --help                    help for upsert
      --id string               binding id (update when set)
      --ip-list-id string       IP list id
      --match-mode string       membership relation: in_list | not_in_list (default "in_list")
      --path-prefix string      optional URI prefix that scopes the binding
      --policy-id string        policy id
      --site-id string          optional site id — make the binding site-scoped
      --sort-order int32        deterministic emit order

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country catalog

```text
Show countries available in the active MMDB

Usage:
  tiyi rule country catalog [flags]

Flags:
  -h, --help   help for catalog

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country delete

```text
Delete and atomically remove a country access rule

Usage:
  tiyi rule country delete <rule-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country get

```text
Get one country access rule

Usage:
  tiyi rule country get <rule-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country list

```text
List country access rules

Usage:
  tiyi rule country list [flags]

Flags:
  -h, --help   help for list

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country set

```text
Create or update and atomically apply a country access rule

Usage:
  tiyi rule country set [rule-id] [flags]

Flags:
      --action string           decision: deny | allow | monitor (default "deny")
      --address-source string   address identity: client_ip | peer_ip (default "client_ip")
      --bypass string           allow behavior: ip_lists_only | all_waf (default "ip_lists_only")
      --country strings         ISO alpha-2 country code, repeat or comma-separate
      --description string      operator note
      --enabled                 enable the rule (default true)
      --global                  apply to all sites
  -h, --help                    help for set
      --match string            match mode: in_list | not_in_list (default "in_list")
      --name string             rule name (required on create)
      --policy-id strings       target policy id, repeat or comma-separate
      --site-id strings         target site id, repeat or comma-separate
      --sort-order int32        rule priority within its scope

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom create

```text
Create a custom SecLang rule

Usage:
  tiyi rule custom create <policy-id> [flags]

Flags:
      --description string    custom rule description
      --enabled               enable the custom rule (default true)
  -h, --help                  help for create
      --name string           custom rule name
      --phase int32           ModSecurity phase (default 2)
      --rule-id int           Tiyi custom rule id in 8000000..8999999
      --seclang string        raw SecLang directive
      --seclang-file string   read raw SecLang from a file
      --site-id string        optional site id; empty means policy-wide
      --sort-order int32      custom rule sort order

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom delete

```text
Delete a custom rule

Usage:
  tiyi rule custom delete <custom-rule-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom get

```text
Get one custom rule

Usage:
  tiyi rule custom get <custom-rule-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom list

```text
List custom rules for a policy

Usage:
  tiyi rule custom list <policy-id> [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom preview

```text
Preview one custom SecLang rule

Usage:
  tiyi rule custom preview [flags]

Flags:
      --description string    custom rule description
      --enabled               enable the custom rule (default true)
  -h, --help                  help for preview
      --name string           custom rule name
      --phase int32           ModSecurity phase (default 2)
      --rule-id int           Tiyi custom rule id in 8000000..8999999
      --seclang string        raw SecLang directive
      --seclang-file string   read raw SecLang from a file
      --sort-order int32      custom rule sort order

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom update

```text
Update a custom SecLang rule

Usage:
  tiyi rule custom update <custom-rule-id> [flags]

Flags:
      --description string    custom rule description
      --enabled               enable the custom rule
  -h, --help                  help for update
      --name string           custom rule name
      --phase int32           ModSecurity phase
      --rule-id int           Tiyi custom rule id in 8000000..8999999
      --seclang string        raw SecLang directive
      --seclang-file string   read raw SecLang from a file
      --site-id string        optional site id; empty means policy-wide
      --sort-order int32      custom rule sort order

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list create

```text
Create a manual IP list

Usage:
  tiyi rule ip-list create [flags]

Flags:
      --description string   IP list description
      --entry strings        IP or CIDR entry, repeat or comma-separate
  -h, --help                 help for create
      --name string          IP list name

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list delete

```text
Delete an IP list

Usage:
  tiyi rule ip-list delete <ip-list-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list get

```text
Get one IP list

Usage:
  tiyi rule ip-list get <ip-list-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list list

```text
List IP lists

Usage:
  tiyi rule ip-list list [flags]

Flags:
  -h, --help              help for list
      --mode string       filter by management mode: manual | subscription
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or description

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list lookup

```text
Look up an IP address in a list

Usage:
  tiyi rule ip-list lookup <ip-list-id> <ip> [flags]

Flags:
  -h, --help   help for lookup

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list pause

```text
Pause scheduled subscription syncs

Usage:
  tiyi rule ip-list pause <ip-list-id> [flags]

Flags:
  -h, --help   help for pause

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list replace

```text
Atomically replace a manual list's complete content

Usage:
  tiyi rule ip-list replace <ip-list-id> [flags]

Flags:
      --description string   new description
      --etag string          opaque concurrency token; fetched automatically when omitted
  -f, --file string          file containing one IP or CIDR per line
  -h, --help                 help for replace
      --name string          new list name; defaults to the current name

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list resume

```text
Resume and immediately sync a subscription

Usage:
  tiyi rule ip-list resume <ip-list-id> [flags]

Flags:
  -h, --help   help for resume

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list source-test

```text
Fetch and validate a saved source without applying it

Usage:
  tiyi rule ip-list source-test <ip-list-id> [flags]

Flags:
  -h, --help   help for source-test

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list subscribe

```text
Create a managed IP-list subscription

Usage:
  tiyi rule ip-list subscribe [flags]

Flags:
      --description string       subscription description
      --format string            plain-v1 | json-v1 | dns-spf-v1 (default "plain-v1")
  -h, --help                     help for subscribe
      --interval string          sync interval (default "6h")
      --json-path stringArray    RFC 9535 JSONPath selecting IP/CIDR strings; repeat the flag for multiple expressions
      --max-delete-ratio float   maximum automatic deletion ratio (default 0.5)
      --max-entries int32        maximum accepted entry count (default 500000)
      --min-entries int32        minimum accepted entry count (default 1)
      --name string              subscription name
      --secret-header strings    Name:stdin, Name:file=/path, or Name:literal
      --url string               HTTP(S) or dns:// source URL

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list sync

```text
Queue an immediate subscription sync

Usage:
  tiyi rule ip-list sync <ip-list-id> [flags]

Flags:
  -h, --help   help for sync

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list sync-status

```text
Show recent subscription sync runs

Usage:
  tiyi rule ip-list sync-status <ip-list-id> [flags]

Flags:
  -h, --help          help for sync-status
      --limit int32   number of recent runs (default 20)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override delete

```text
Delete a CRS rule override

Usage:
  tiyi rule override delete <override-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override get

```text
Get one CRS rule override

Usage:
  tiyi rule override get <override-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override list

```text
List CRS rule overrides for a policy

Usage:
  tiyi rule override list <policy-id> [flags]

Flags:
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override upsert

```text
Create or update a CRS rule override

Usage:
  tiyi rule override upsert <policy-id> [flags]

Flags:
      --action string           override verb: default | disable | log_only | score_override (default "default")
      --add-target strings      add a CRS target, repeat or comma-separate
      --crs-rule-id string      CRS rule id to override
  -h, --help                    help for upsert
      --rationale string        operator rationale
      --remove-target strings   remove a CRS target, repeat or comma-separate
      --scope string            URI prefix that scopes the override (CRS @beginsWith)
      --score-override int32    override the rule's anomaly contribution (0 silences it)
      --site-id string          limit the override to one site (empty = policy-wide)
      --tag strings             operator tag, repeat or comma-separate

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule rate-limit delete

```text
Delete a rate-limit endpoint

Usage:
  tiyi rule rate-limit delete <endpoint-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule rate-limit list

```text
List rate-limit endpoints for a policy (optionally filtered to a site)

Usage:
  tiyi rule rate-limit list <policy-id> [flags]

Flags:
  -h, --help             help for list
      --site-id string   filter to endpoints for this site (plus policy-wide endpoints)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule rate-limit upsert

```text
Create a rate-limit endpoint, or update one by id

Usage:
  tiyi rule rate-limit upsert [flags]

Flags:
      --action string                   block | ban | challenge (default "block")
      --ban-scope string                temporary ban scope: site | global (required for ban)
      --bind-network                    custom only: check the browser again after its /24 or /56 network changes
      --challenge-profile string        browser-check treatment: comfort | standard | strict | custom (default "standard")
      --challenge-ttl int32             custom only: maximum browser-check completion time in seconds (30-600)
      --clearance-ttl int32             custom only: time before the browser is checked again in seconds (60-86400)
      --counting-key string             client identity: ip | session | header:<name> (default "ip")
      --enforcement-mode string         observe | enforce (default "observe")
  -h, --help                            help for upsert
      --id string                       existing endpoint id (required for update; omit only when creating)
      --method-mode string              explicit method mode: any | include (default "any")
      --methods strings                 HTTP methods for include mode, for example POST,PUT
      --mitigation-seconds int32        fixed action duration; blocked requests do not extend it (default 600)
      --path-pattern string             URI path pattern (compiler supports @beginsWith-style matches)
      --policy-id string                policy id
      --proof-difficulty int32          custom only: SHA-256 work factor in leading-zero bits (12-24)
      --request-count int32             requests allowed in the rolling window (default 5)
      --site-id string                  optional site id — make the endpoint site-scoped
      --sort-order int32                deterministic emit order
      --verified-request-count int32    custom only: requests allowed after the browser check (maximum 600)
      --verified-window-seconds int32   custom only: rolling window after the browser check
      --window-seconds int32            rolling-window duration in seconds (default 60)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override delete

```text
Remove a per-site policy override

Usage:
  tiyi site policy-override delete <site-id> [flags]

Flags:
  -h, --help   help for delete

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override get

```text
Show the policy override (if any) for a site

Usage:
  tiyi site policy-override get <site-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override set

```text
Set a per-site override for any of:
	--blocking-pl / --executing-pl  (CRS docs § 2-2)
	--inbound-threshold / --outbound-threshold  (CRS docs § 2-1)
	--sampling-percentage  (CRS docs § 2-4)

Unset flags inherit the attached policy's values. --policy-id is optional; when
omitted, the site's currently attached policy is used.

Usage:
  tiyi site policy-override set <site-id> [flags]

Flags:
      --blocking-pl int32           blocking paranoia level override (1..4) (default 1)
      --executing-pl int32          executing (detection) paranoia level override (1..4) (default 1)
  -h, --help                        help for set
      --inbound-threshold int32     inbound anomaly score threshold override (default 5)
      --outbound-threshold int32    outbound anomaly score threshold override (default 4)
      --policy-id string            policy id (defaults to the site's attached WAF policy)
      --rationale string            short note explaining why the override exists
      --sampling-percentage int32   sampling percentage override (0..100) (default 100)

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site routing get

```text
Show a site's path routing

Usage:
  tiyi site routing get <site-id> [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site routing set

```text
Replace the complete set of path routes for a site.

Each --route is PREFIX=UPSTREAM_ID with an optional :strip suffix to strip the
matched prefix before proxying (default: preserve the original path):

  tiyi site routing set s1 \
    --route /api=11111111-1111-1111-1111-111111111111 \
    --route /static=22222222-2222-2222-2222-222222222222:strip \
    --unmatched 404

Path prefixes are matched case-insensitively and on segment boundaries
(/admin matches /admin and /admin/x, never /administrator); the server stores
them canonicalized (lowercased, no trailing slash). --unmatched is "default"
(fall through to the site's default upstream — which the site must then have)
or "404" (strict allowlist).

Usage:
  tiyi site routing set <site-id> [flags]

Flags:
  -h, --help                help for set
      --revision int        expected site revision for optimistic concurrency (0 = unchecked)
      --route stringArray   a route as PREFIX=UPSTREAM_ID[:strip] (repeatable)
      --unmatched string    unmatched-path action: "default" or "404" (default "default")

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system settings get

```text
Read all persisted system settings

Usage:
  tiyi system settings get [flags]

Flags:
  -h, --help   help for get

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system settings update

```text
Update one or more persisted system settings.

Known setting namespaces:

  siem.*                          SIEM egress configuration.
    siem.destinations             JSON array of producer-owned destinations.


  security.responses.config       Shared protection response configuration.
                                  Complete templates + six scenario objects.
                                  See QUICKSTART: Interception responses.

	  Logging and evidence policy is a revision-CAS LogService resource, not a
	  system_setting namespace. Manage it through Administration → Settings →
	  Logs & evidence or the typed LogService policy RPCs.

  ai.*                            AI log analysis and advisory layer
                                  (optional, default-off). The provider API
                                  key is NOT a setting — set it through
                                  SetAIProviderSecret or the web UI.
    ai.enabled                    bool   Enable the AI layer (default false).
    ai.provider                   string openai_compatible | azure_openai.
    ai.base_url                   string Provider base URL.
    ai.model_summary              string Summary/analysis model id.
    ai.model_reasoning            string Reasoning model id (proposals).
    ai.timeout_seconds            int    Per-call timeout seconds (default 30).
    ai.max_requests_per_minute    int    Shared analysis rate cap (default 60).
    ai.max_output_tokens          int    Max streamed analysis tokens (default 2048).
    ai.redaction_profile          string Redaction profile (default strict).
Public template variables:
  {response.status_code}, {response.kind}, {response.source},
  {response.title}, {response.message}, {request.id}, {request.time}.
Request data, rule/list IDs, thresholds and internal errors are not public inputs.

Example (replace the complete shared configuration atomically):
  tiyi system settings update --values-json '{
  "security.responses.config": {
    "templates": {
      "active": "auto",
      "html": {"body":"<h1>{response.title}</h1><p>{response.message}</p><p>{request.id}</p>","contentType":"text/html; charset=utf-8"},
      "json": {"body":"{\"status\":{response.status_code},\"title\":\"{response.title}\",\"message\":\"{response.message}\",\"request_id\":\"{request.id}\"}","contentType":"application/problem+json"},
      "plain": {"body":"{response.title}. {response.message} Request ID: {request.id}","contentType":"text/plain; charset=utf-8"},
      "custom": {"body":"{response.title}. {response.message}","contentType":"text/plain; charset=utf-8"}
    },
    "scenarios": {
      "waf_block": {"statusCode":403,"title":"Request blocked","message":"Contact the site owner with the request ID."},
      "ip_deny": {"statusCode":403,"title":"Access denied","message":"Access is not allowed."},
      "country_deny": {"statusCode":403,"title":"Access denied","message":"Access is not allowed."},
      "rate_limit": {"statusCode":429,"title":"Too many requests","message":"Please try again later."},
      "bot_block": {"statusCode":403,"title":"Browser verification required","message":"Use a browser over HTTPS or contact the site owner for API access."},
      "service_unavailable": {"statusCode":503,"title":"Service unavailable","message":"Please try again later."}
    }
  }
}'

Usage:
  tiyi system settings update [flags]

Flags:
  -h, --help                 help for update
      --set stringArray      setting assignment key=value; repeatable
      --values-json string   JSON object of settings to update

Global Flags:
      --admin-socket string   local admin Unix socket (default "/run/user/1000/tiyi/admin.sock")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```
