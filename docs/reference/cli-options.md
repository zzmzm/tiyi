# Tiyi CLI command reference

Generated from the binary's Cobra command tree. Do not edit by hand.

Flags show compile-time defaults with TIYI environment variables cleared. Environment variables, config files, permissions and current runtime state can change actual behavior. This lists command syntax, not execution approval. The admin-socket default is host dependent: TIYI_ADMIN_SOCKET overrides it; otherwise an existing system socket or root uses /run/tiyi/admin.sock, then XDG_RUNTIME_DIR/tiyi/admin.sock or the temporary directory tiyi-UID/admin.sock. Hidden internal commands are excluded. No command is executed during generation.

## tiyi

Tiyi — single-binary WAF-enabled reverse proxy

```text
tiyi [flags]
```

Flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
  -h, --help               help for tiyi
      --log-level string   override log level: debug | info | warn | error
  -v, --version            version for tiyi
```

## tiyi admin

Local administrator maintenance

```text
tiyi admin [flags]
```

Flags:

```text
  -h, --help   help for admin
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi admin init

Create the first local administrator

```text
tiyi admin init [flags]
```

Flags:

```text
      --display-name string   admin display name
      --email string          admin email
  -h, --help                  help for init
      --password string       admin password; can also use TIYI_AUTH_BOOTSTRAP_ADMIN_PASSWORD
      --state-db string       override path to state.db (default "/var/lib/tiyi/state.db")
      --username string       admin username; defaults to auth.bootstrap_admin_username or admin
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi agent

Run a remote data plane (Caddy + Coraza, receives config from Tiyi)

```text
tiyi agent [flags]
```

Flags:

```text
      --agent-id string             existing enrolled agent id; defaults to state-dir identity
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default
                                    "/var/lib/tiyi/caddy-admin.sock")
      --controller-url string       Tiyi instance URL
      --enrollment-token string     enrollment token for first startup
      --fingerprint string          stable agent fingerprint; generated on first startup when
                                    omitted
  -h, --help                        help for agent
      --no-proxy                    receive and cache bundles without starting embedded Caddy
      --once                        connect once, apply at most one pending bundle, then exit
      --once-wait duration          maximum wait for a config update when --once is set
                                    (default 5s)
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites
                                    (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites
                                    (default ":443")
      --state-dir string            agent state directory (default "/var/lib/tiyi/agent")
      --stream-token string         existing agent stream token; defaults to state-dir identity
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi agent reset-enroll

Back up stopped Agent state and prepare for enrollment again

```text
tiyi agent reset-enroll [flags]
```

Flags:

```text
  -h, --help               help for reset-enroll
      --state-dir string   dedicated agent state directory (default "/var/lib/tiyi/agent")
      --yes                confirm backup and reset of stopped Agent state
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi agent-group

Manage agent groups

```text
tiyi agent-group [flags]
```

Aliases: agent-groups

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for agent-group
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi agent-group create

Create an agent group

```text
tiyi agent-group create [flags]
```

Flags:

```text
      --agent-id strings   explicit agent IDs; may be repeated
  -h, --help               help for create
      --name string        group name (required)
      --tag strings        tag selectors; may be repeated
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agent-group delete

Delete an agent group

```text
tiyi agent-group delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agent-group get

Get one agent group

```text
tiyi agent-group get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agent-group list

List agent groups

```text
tiyi agent-group list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents

Manage enrolled remote agents

```text
tiyi agents [flags]
```

Aliases: agent-status

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for agents
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi agents bundle

Get one config bundle

```text
tiyi agents bundle <bundle-id> [flags]
```

Flags:

```text
  -h, --help   help for bundle
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents bundles

List config bundles

```text
tiyi agents bundles [agent-id] [flags]
```

Flags:

```text
  -h, --help              help for bundles
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents get

Get one agent

```text
tiyi agents get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents install-command

Generate an expiring installation command with a node limit

```text
tiyi agents install-command [flags]
```

Flags:

```text
      --controller-url string   Tiyi URL used by tiyi agent --controller-url
      --foreground              print the foreground command instead of installing a service
  -h, --help                    help for install-command
      --json                    return both commands, full scripts and the installation
                                receipt as JSON
      --max-nodes int32         maximum distinct nodes registered with this command (1–1000)
                                (default 1)
      --tag strings             tag attached to the enrolled node; may be repeated
      --ttl-seconds int32       enrollment lifetime in seconds (60–2592000) (default 86400)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents issue-token

Issue a bounded remote-agent enrollment token

```text
tiyi agents issue-token [flags]
```

Flags:

```text
  -h, --help                help for issue-token
      --max-nodes int32     maximum distinct nodes registered with this token (1–1000)
                            (default 1)
      --tag strings         tag attached to agents enrolled with this token; may be repeated
      --ttl-seconds int32   token TTL in seconds (default 86400)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi agents list

List enrolled remote agents

```text
tiyi agents list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name, fingerprint, or hostname
      --status string     filter by status: online | offline | error
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert

Manage alerts, alert rules, and notification channels

```text
tiyi alert [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for alert
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi alert ack

Acknowledge an open alert

```text
tiyi alert ack <alert-id> [flags]
```

Flags:

```text
  -h, --help          help for ack
      --note string   optional note recorded on the alert timeline
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel

Manage alert channels

```text
tiyi alert channel [flags]
```

Flags:

```text
  -h, --help   help for channel
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel apply

Associate an alert channel with one or more existing rules

```text
tiyi alert channel apply <channel-id> <rule-id> [rule-id...] [flags]
```

Flags:

```text
  -h, --help   help for apply
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel delete

Delete an alert channel

```text
tiyi alert channel delete <channel-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel get

Get one alert channel

```text
tiyi alert channel get <channel-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel list

List alert channels

```text
tiyi alert channel list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel test

Send a test notification through a saved alert channel

```text
tiyi alert channel test <channel-id> [flags]
```

Flags:

```text
  -h, --help   help for test
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert channel upsert

Create or replace an alert channel

```text
tiyi alert channel upsert [flags]
```

Flags:

```text
      --config-json string   channel config JSON object (default "{}")
      --enabled              enable channel; pass --enabled=false to disable (default true)
  -h, --help                 help for upsert
      --id string            existing channel id to replace
      --kind string          kind: webhook | slack | pagerduty | feishu | wecom | email
                             (default "webhook")
      --name string          alert channel name
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert get

Get one alert

```text
tiyi alert get <alert-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert list

List alerts

```text
tiyi alert list [flags]
```

Flags:

```text
      --end string        opening time upper bound, RFC3339 (exclusive)
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
      --query string      search alert title and message
      --rule-id string    filter by rule id
      --severity string   filter by severity: info | warning | critical
      --site-id string    filter by site id
      --start string      opening time lower bound, RFC3339 (inclusive)
      --status string     filter by status: active | open | acked | resolved | all (default
                          "active")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert notes

List the timeline notes for an alert

```text
tiyi alert notes <alert-id> [flags]
```

Flags:

```text
  -h, --help   help for notes
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert resolve

Resolve an open or acknowledged alert

```text
tiyi alert resolve <alert-id> [flags]
```

Flags:

```text
  -h, --help          help for resolve
      --note string   optional note recorded on the alert timeline
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule

Manage alert rules

```text
tiyi alert rule [flags]
```

Flags:

```text
  -h, --help   help for rule
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule delete

Delete an alert rule

```text
tiyi alert rule delete <rule-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule get

Get an alert rule

```text
tiyi alert rule get <rule-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule list

List alert rules

```text
tiyi alert rule list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule preview

Preview an unsaved rule notification without sending

```text
tiyi alert rule preview [flags]
```

Flags:

```text
      --channel-id stringArray     notification channel id; repeatable
      --enabled                    enable rule; pass --enabled=false to disable
      --event string               lifecycle event: firing | repeat |
                                   auto_remediation_succeeded | auto_remediation_failed |
                                   resolved | operator_resolved (default "firing")
      --expression-json string     rule expression JSON (default
                                   "{\"kind\":\"security_threshold\",\"windowSeconds\":300,\"minCount\":1}")
  -h, --help                       help for preview
      --id string                  existing rule id to replace
      --name string                alert rule name
      --notification-json string   rule notification content JSON, keyed by locales and
                                   lifecycle events (default "{}")
      --severity string            severity: info | warning | critical (default "warning")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert rule upsert

Create or replace an alert rule

```text
tiyi alert rule upsert [flags]
```

Flags:

```text
      --channel-id stringArray     notification channel id; repeatable
      --enabled                    enable rule; pass --enabled=false to disable (default true)
      --expression-json string     rule expression JSON (default
                                   "{\"kind\":\"security_threshold\",\"windowSeconds\":300,\"minCount\":1,\"outcome\":\"blocked\"}")
  -h, --help                       help for upsert
      --id string                  existing rule id to replace
      --name string                alert rule name
      --notification-json string   rule notification content JSON, keyed by locales and
                                   lifecycle events (default "{}")
      --severity string            severity: info | warning | critical (default "warning")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence

Manage maintenance-window silences

```text
tiyi alert silence [flags]
```

Flags:

```text
  -h, --help   help for silence
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence create

Create a silence active from now for the given duration

```text
tiyi alert silence create [flags]
```

Flags:

```text
      --duration-minutes int     silence duration in minutes from now (default 60)
  -h, --help                     help for create
      --matcher stringToString   matcher key=value (severity|kind|siteId|agentId|ruleId);
                                 repeatable (default [])
      --reason string            reason recorded on the silence
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence delete

Delete a silence

```text
tiyi alert silence delete <silence-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence list

List silences

```text
tiyi alert silence list [flags]
```

Flags:

```text
      --active            only list silences whose window is currently active
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi alert silence preview

Count and sample current unresolved alerts matching a proposed silence

```text
tiyi alert silence preview [flags]
```

Flags:

```text
  -h, --help                     help for preview
      --matcher stringToString   severity|kind|siteId|agentId|ruleId=value; repeatable (default [])
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document

Import API declarations and control request validation

```text
tiyi api-document [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for api-document
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi api-document binding

Call the API document service with an explicit JSON request

```text
tiyi api-document binding [flags]
```

Flags:

```text
  -h, --help                  help for binding
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document bindings

Call the API document service with an explicit JSON request

```text
tiyi api-document bindings [flags]
```

Flags:

```text
  -h, --help                  help for bindings
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document bindings-stage

Call the API document service with an explicit JSON request

```text
tiyi api-document bindings-stage [flags]
```

Flags:

```text
  -h, --help                  help for bindings-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declaration

Call the API document service with an explicit JSON request

```text
tiyi api-document declaration [flags]
```

Flags:

```text
  -h, --help                  help for declaration
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declaration-preview

Call the API document service with an explicit JSON request

```text
tiyi api-document declaration-preview [flags]
```

Flags:

```text
  -h, --help                  help for declaration-preview
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declaration-stage

Call the API document service with an explicit JSON request

```text
tiyi api-document declaration-stage [flags]
```

Flags:

```text
  -h, --help                  help for declaration-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document declarations

Call the API document service with an explicit JSON request

```text
tiyi api-document declarations [flags]
```

Flags:

```text
  -h, --help                  help for declarations
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document detection

Call the API document service with an explicit JSON request

```text
tiyi api-document detection [flags]
```

Flags:

```text
  -h, --help                  help for detection
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning

Call the API document service with an explicit JSON request

```text
tiyi api-document learning [flags]
```

Flags:

```text
  -h, --help                  help for learning
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-change

Call the API document service with an explicit JSON request

```text
tiyi api-document learning-change [flags]
```

Flags:

```text
  -h, --help                  help for learning-change
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-export

Call the API document service with an explicit JSON request

```text
tiyi api-document learning-export [flags]
```

Flags:

```text
  -h, --help                  help for learning-export
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-snapshot

Call the API document service with an explicit JSON request

```text
tiyi api-document learning-snapshot [flags]
```

Flags:

```text
  -h, --help                  help for learning-snapshot
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document learning-stage

Call the API document service with an explicit JSON request

```text
tiyi api-document learning-stage [flags]
```

Flags:

```text
  -h, --help                  help for learning-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document preview

Call the API document service with an explicit JSON request

```text
tiyi api-document preview [flags]
```

Flags:

```text
  -h, --help                  help for preview
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document profile

Call the API document service with an explicit JSON request

```text
tiyi api-document profile [flags]
```

Flags:

```text
  -h, --help                  help for profile
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document profile-stage

Call the API document service with an explicit JSON request

```text
tiyi api-document profile-stage [flags]
```

Flags:

```text
  -h, --help                  help for profile-stage
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document profiles

Call the API document service with an explicit JSON request

```text
tiyi api-document profiles [flags]
```

Flags:

```text
  -h, --help                  help for profiles
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document publish

Call the API document service with an explicit JSON request

```text
tiyi api-document publish [flags]
```

Flags:

```text
  -h, --help                  help for publish
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document report

Call the API document service with an explicit JSON request

```text
tiyi api-document report [flags]
```

Flags:

```text
  -h, --help                  help for report
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document reports

Call the API document service with an explicit JSON request

```text
tiyi api-document reports [flags]
```

Flags:

```text
  -h, --help                  help for reports
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document source

Call the API document service with an explicit JSON request

```text
tiyi api-document source [flags]
```

Flags:

```text
  -h, --help                  help for source
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document sources

Call the API document service with an explicit JSON request

```text
tiyi api-document sources [flags]
```

Flags:

```text
  -h, --help                  help for sources
  -f, --request-file string   strict protobuf JSON request file, or - for stdin (16 MiB
                              maximum) (default "-")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi api-document upload

Stage an OpenAPI 3.0/3.1/3.2 or Swagger 2.0 JSON/YAML file

```text
tiyi api-document upload [flags]
```

Flags:

```text
  -f, --file string              source document path (8 MiB maximum)
  -h, --help                     help for upload
      --idempotency-key string   stable key for exact retries
      --site string              site UUID
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi apply

Apply a YAML manifest (kubectl-style declarative management)

```text
tiyi apply [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
      --dry-run               preview only; do not persist
  -f, --file string           manifest file or '-' for stdin
  -h, --help                  help for apply
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi audit

Query audit events and verify the audit chain

```text
tiyi audit [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for audit
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi audit get

Get one audit event

```text
tiyi audit get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi audit list

List audit events

```text
tiyi audit list [flags]
```

Flags:

```text
      --action string          filter by action, e.g. site.update
      --actor-id string        filter by actor user id
      --cursor string          opaque cursor from a previous audit list response
      --end string             exclusive RFC3339 end time
  -h, --help                   help for list
      --page-size int32        page size (default 50)
      --resource-id string     filter by resource id
      --resource-type string   filter by resource type
      --start string           inclusive RFC3339 start time
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi audit status

Show audit chain health

```text
tiyi audit status [flags]
```

Flags:

```text
  -h, --help   help for status
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi audit verify

Verify audit-chain integrity

```text
tiyi audit verify [flags]
```

Flags:

```text
      --end string     exclusive RFC3339 end time
  -h, --help           help for verify
      --start string   inclusive RFC3339 start time
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi auth

Authenticate against the Tiyi API

```text
tiyi auth [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for auth
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi auth access-codes

Print the current user's access codes

```text
tiyi auth access-codes [flags]
```

Flags:

```text
  -h, --help   help for access-codes
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi auth login

Login and print an access token response

```text
tiyi auth login [flags]
```

Flags:

```text
  -h, --help              help for login
  -p, --password string   password
  -u, --username string   username
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi auth user

Print the current authenticated user

```text
tiyi auth user [flags]
```

Flags:

```text
  -h, --help   help for user
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert

Manage TLS certificates

```text
tiyi cert [flags]
```

Aliases: certs, certificate, certificates

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for cert
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi cert delete

Delete a certificate

```text
tiyi cert delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider

Manage ACME DNS-01 providers

```text
tiyi cert dns-provider [flags]
```

Aliases: dns-providers

Flags:

```text
  -h, --help   help for dns-provider
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider create

Register a new ACME DNS-01 provider

```text
tiyi cert dns-provider create [flags]
```

Flags:

```text
      --credentials-file string     path to a JSON file containing driver credentials
      --credentials-json string     inline JSON credentials (use --credentials-file in production)
  -h, --help                        help for create
      --name string                 human-readable provider name
      --propagation-seconds int32   max wait for authoritative-NS propagation before letting
                                    the CA validate (default 120)
      --provider string             driver: cloudflare | route53 | aliyun
      --setting stringArray         driver setting in key=value form (repeatable); use
                                    sparingly — most drivers run with defaults
      --zones strings               apex zones the provider can publish into; repeatable or
                                    comma-separated; empty means catch-all
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider delete

Delete an ACME DNS-01 provider (soft delete)

```text
tiyi cert dns-provider delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider drivers

List the DNS provider drivers the server registry knows

```text
tiyi cert dns-provider drivers [flags]
```

Aliases: list-drivers

Flags:

```text
  -h, --help   help for drivers
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider get

Get one ACME DNS-01 provider

```text
tiyi cert dns-provider get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider list

List ACME DNS-01 providers

```text
tiyi cert dns-provider list [flags]
```

Flags:

```text
  -h, --help              help for list
      --provider string   filter by driver: cloudflare | route53 | aliyun
      --status string     filter by status: active | disabled
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert dns-provider update

Update an ACME DNS-01 provider

```text
tiyi cert dns-provider update <id> [flags]
```

Update an ACME DNS-01 provider. All fields are required because the proto
contract is replace-shaped — pass --status, --provider, --name, --zones, and
--propagation-seconds with the desired values. Omit --credentials-file and
--credentials-json to keep the stored credentials unchanged.

Flags:

```text
      --credentials-file string     path to a JSON file containing driver credentials
      --credentials-json string     inline JSON credentials (use --credentials-file in production)
  -h, --help                        help for update
      --name string                 human-readable provider name
      --propagation-seconds int32   max wait for authoritative-NS propagation before letting
                                    the CA validate (default 120)
      --provider string             driver: cloudflare | route53 | aliyun
      --setting stringArray         driver setting in key=value form (repeatable); use
                                    sparingly — most drivers run with defaults
      --status string               provider status: active | disabled (default "active")
      --zones strings               apex zones the provider can publish into; repeatable or
                                    comma-separated; empty means catch-all
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert download

Download certificate PEM material

```text
tiyi cert download <id> [flags]
```

Flags:

```text
  -h, --help                  help for download
      --include-private-key   include private key in the PEM bundle
  -o, --out string            write PEM output to file instead of stdout
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert get

Get certificate metadata

```text
tiyi cert get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert issue

Issue an ACME certificate for one or more domains

```text
tiyi cert issue <domain> [domain...] [flags]
```

Flags:

```text
      --acme-issuer string      ACME issuer: letsencrypt | letsencrypt-staging | custom
      --challenge-type string   challenge type: http-01 (default) or dns-01
      --directory-url string    custom ACME directory URL (required with --acme-issuer=custom)
      --email string            ACME account email
  -h, --help                    help for issue
      --name string             certificate display name (defaults to first domain)
      --staging                 use Let's Encrypt staging directory
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert list

List certificates

```text
tiyi cert list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name, DNS name, or fingerprint
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert renew

Renew a managed certificate

```text
tiyi cert renew <id> [flags]
```

Flags:

```text
      --force   renew even if the certificate is not near expiry
  -h, --help    help for renew
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi cert upload

Upload certificate and private key PEM files

```text
tiyi cert upload [flags]
```

Flags:

```text
      --cert-pem string         leaf certificate PEM file
      --chain-pem stringArray   intermediate certificate PEM file; repeatable
  -h, --help                    help for upload
      --key-pem string          private key PEM file
      --name string             certificate name
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi completion

Generate the autocompletion script for the specified shell

```text
tiyi completion [flags]
```

Generate the autocompletion script for tiyi for the specified shell.
See each sub-command's help for details on how to use the generated script.


Flags:

```text
  -h, --help   help for completion
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi completion bash

Generate the autocompletion script for bash

```text
tiyi completion bash
```

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


Flags:

```text
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi completion fish

Generate the autocompletion script for fish

```text
tiyi completion fish [flags]
```

Generate the autocompletion script for the fish shell.

To load completions in your current shell session:

	tiyi completion fish | source

To load completions for every new session, execute once:

	tiyi completion fish > ~/.config/fish/completions/tiyi.fish

You will need to start a new shell for this setup to take effect.


Flags:

```text
  -h, --help              help for fish
      --no-descriptions   disable completion descriptions
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi completion powershell

Generate the autocompletion script for powershell

```text
tiyi completion powershell [flags]
```

Generate the autocompletion script for powershell.

To load completions in your current shell session:

	tiyi completion powershell | Out-String | Invoke-Expression

To load completions for every new session, add the output of the above command
to your powershell profile.


Flags:

```text
  -h, --help              help for powershell
      --no-descriptions   disable completion descriptions
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi completion zsh

Generate the autocompletion script for zsh

```text
tiyi completion zsh [flags]
```

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


Flags:

```text
  -h, --help              help for zsh
      --no-descriptions   disable completion descriptions
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi crs

Import and browse OWASP CRS rulesets

```text
tiyi crs [flags]
```

Aliases: rulesets

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for crs
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi crs categories

List CRS rule categories

```text
tiyi crs categories <ruleset-id> [flags]
```

Flags:

```text
  -h, --help   help for categories
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs delete

Delete an imported CRS ruleset

```text
tiyi crs delete <ruleset-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs get

Get one imported CRS ruleset

```text
tiyi crs get <ruleset-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs ingest

Import a CRS ruleset (local path, vendored tree, GitHub tag, or offline archive)

```text
tiyi crs ingest [flags]
```

Aliases: import

Flags:

```text
      --archive string   local path to a tar.gz or zip archive for offline installs (takes
                         precedence over --path when --tag is not set)
  -h, --help             help for ingest
      --path string      server-local CRS root path; defaults to the vendored
                         reference/coreruleset-4.25.0
      --tag string       GitHub release tag (e.g. v4.11.0); when set, fetches and extracts the
                         upstream tarball
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs list

List imported CRS rulesets

```text
tiyi crs list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs plugin-schema

Get a CRS plugin config schema

```text
tiyi crs plugin-schema <plugin-id> [flags]
```

Flags:

```text
  -h, --help   help for plugin-schema
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs plugins

List CRS plugin hooks

```text
tiyi crs plugins <ruleset-id> [flags]
```

Flags:

```text
  -h, --help   help for plugins
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs releases

List CRS releases from github.com/coreruleset/coreruleset

```text
tiyi crs releases [flags]
```

Flags:

```text
  -h, --help                 help for releases
      --include-prerelease   include pre-release and draft releases
      --limit int32          maximum number of releases to list (max 100) (default 20)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs rule

Get one CRS rule

```text
tiyi crs rule <ruleset-id> <rule-id> [flags]
```

Flags:

```text
  -h, --help   help for rule
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi crs rules

List CRS rules in a ruleset

```text
tiyi crs rules <ruleset-id> [flags]
```

Flags:

```text
      --category string        filter by exact CRS category code, such as 942
  -h, --help                   help for rules
      --page int32             page number (default 1)
      --page-size int32        page size (default 50)
      --paranoia-level int32   filter by exact CRS paranoia level
      --phase int32            filter by exact CRS phase
  -q, --query string           filter by id, file, category, message, severity, or tag
      --severity string        filter by exact CRS severity
      --tag strings            require exact CRS tag; repeat or comma-separate
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi dashboard

Serve the optional stateless UI client

```text
tiyi dashboard [flags]
```

Flags:

```text
      --addr string                 override HTTP listen address (default "0.0.0.0:8080")
      --admin-socket string         local Unix socket for passwordless operator CLI; empty
                                    disables (default "<automatic local socket>")
      --admin-socket-group string   group owner for the local admin socket
      --admin-socket-mode string    file mode for the local admin socket (default "0600")
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default
                                    "/var/lib/tiyi/caddy-admin.sock")
  -h, --help                        help for dashboard
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites
                                    (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites
                                    (default ":443")
      --state-db string             override path to state.db (default "/var/lib/tiyi/state.db")
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi diff

Show the diff between a manifest and current state

```text
tiyi diff [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -f, --file string           manifest file or '-' for stdin
  -h, --help                  help for diff
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi doctor

Check local installation prerequisites and common startup blockers

```text
tiyi doctor [flags]
```

Check the local host before starting Tiyi.

Doctor loads the same config and CLI overrides as the runtime commands,
then checks systemd availability, sudo PATH visibility, service state
ownership when a systemd unit is installed, and TCP port listeners that
commonly block a first install.

Flags:

```text
      --addr string                 override HTTP listen address (default "0.0.0.0:8080")
      --admin-socket string         local Unix socket for passwordless operator CLI; empty
                                    disables (default "<automatic local socket>")
      --admin-socket-group string   group owner for the local admin socket
      --admin-socket-mode string    file mode for the local admin socket (default "0600")
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default
                                    "/var/lib/tiyi/caddy-admin.sock")
      --fix-state-ownership         repair configured state directory ownership for the
                                    service user (requires root)
  -h, --help                        help for doctor
      --mode string                 mode to check: run | agent | dashboard (default "run")
      --no-color                    disable ANSI color in the report
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites
                                    (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites
                                    (default ":443")
      --service-group string        service group expected to own state (default "tiyi")
      --service-user string         service user expected to own state (default "tiyi")
      --state-db string             override path to state.db (default "/var/lib/tiyi/state.db")
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi get

Read resources declaratively

```text
tiyi get <kind> [name] [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for get
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi help

Help about any command

```text
tiyi help [command] [flags]
```

Help provides help for any command in the application.
Simply type tiyi help [path to command] for full details.

Flags:

```text
  -h, --help   help for help
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi install

Install a hardened systemd unit and (with --now) enable + start it

```text
tiyi install [flags]
```

Install Tiyi as a systemd service.

Creates the tiyi service user/group (and the tiyi-admin socket group),
writes a hardened Type=simple unit to /etc/systemd/system, and runs
`systemctl daemon-reload`. With --now it also enables and starts the unit;
a first run-mode install prints the one-time administrator login here.

The unit runs unprivileged and binds ports 80/443 via CAP_NET_BIND_SERVICE.
Preview the generated unit without root using `tiyi install --print`.

Flags:

```text
      --admin-group string   group that owns the local admin socket; empty disables group
                             ownership (default "tiyi-admin")
      --binary-path string   tiyi binary path baked into ExecStart (default: this executable)
      --group string         service group to create and run as (default "tiyi")
  -h, --help                 help for install
      --mode string          run mode the unit launches: run | agent (default "run")
      --now                  enable and start the unit immediately (systemctl enable --now)
      --print                print the generated unit to stdout and exit (no root required)
      --unit-name string     systemd unit name (without .service) (default "tiyi")
      --user string          service user to create and run as (default "tiyi")
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi log

Query security, access, and error logs

```text
tiyi log [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for log
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi log access

Query access events

```text
tiyi log access [flags]
```

Flags:

```text
  -h, --help   help for access
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log access export

Export matching access events as NDJSON

```text
tiyi log access export [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log access get

Get one access event

```text
tiyi log access get <event-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log access list

List access events

```text
tiyi log access list [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log error

Query error events

```text
tiyi log error [flags]
```

Flags:

```text
  -h, --help   help for error
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log error export

Export filtered error events as NDJSON

```text
tiyi log error export [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log error get

Get one error event

```text
tiyi log error get <event-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log error list

List error events

```text
tiyi log error list [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log security

Query security events

```text
tiyi log security [flags]
```

Flags:

```text
  -h, --help   help for security
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log security export

Export matching security events as NDJSON

```text
tiyi log security export [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log security get

Get one security event

```text
tiyi log security get <event-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log security list

List security events

```text
tiyi log security list [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi log tail-security

Stream live security events as JSON lines

```text
tiyi log tail-security [flags]
```

Flags:

```text
      --agent-id string   filter by agent id
      --count int         stop after this many events; 0 tails until interrupted
  -h, --help              help for tail-security
      --site-id string    filter by site id
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy

Manage WAF policies

```text
tiyi policy [flags]
```

Aliases: policies

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for policy
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi policy bind-plugin

Bind a CRS plugin to a WAF policy

```text
tiyi policy bind-plugin <policy-id> [flags]
```

Flags:

```text
      --config-json string                        plugin config JSON object (default "{}")
      --disabled                                  bind the plugin but keep it disabled
  -h, --help                                      help for bind-plugin
      --plugin-id tiyi crs plugins <ruleset-id>   CRS plugin id from tiyi crs plugins <ruleset-id>
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy create

Create a WAF policy

```text
tiyi policy create [flags]
```

Flags:

```text
      --blocking-mode string    blocking mode: anomaly | self-contained (default "anomaly")
      --crs-ruleset-id string   active CRS ruleset id
      --description string      policy description
      --engine-state string     engine state: on | detection-only | off (default "on")
  -h, --help                    help for create
      --name string             policy name
      --status string           status: draft | active | archived (default "draft")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy create-from-template

Create a WAF policy from a template

```text
tiyi policy create-from-template [flags]
```

Flags:

```text
      --description string   policy description
  -h, --help                 help for create-from-template
      --name string          policy name
      --template-id string   template policy id
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy delete

Delete a WAF policy

```text
tiyi policy delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy diff

Diff two policy versions

```text
tiyi policy diff <left-version-id> <right-version-id> [flags]
```

Flags:

```text
  -h, --help   help for diff
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy get

Get a WAF policy

```text
tiyi policy get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy layer

Manage typed WAF policy layers

```text
tiyi policy layer [flags]
```

Flags:

```text
  -h, --help   help for layer
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy layer replace

Replace one complete WAF policy layer

```text
tiyi policy layer replace <policy-id> <crs-core|http-policy|arg-limits> [flags]
```

Replace one complete WAF policy layer. The supplied JSON is the new layer, not a merge patch; omitted fields return to their inherited or default values.

Flags:

```text
      --file string    read the complete layer from a JSON file
  -h, --help           help for replace
      --json string    complete layer as a JSON object
      --revision int   expected current revision
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy list

List WAF policies

```text
tiyi policy list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or description
      --templates-only    list policy templates only
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy preview-impact

Preview CRS rule impact for a WAF policy

```text
tiyi policy preview-impact <id> [flags]
```

Flags:

```text
      --crs-ruleset-id string   candidate CRS ruleset id
  -h, --help                    help for preview-impact
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy preview-seclang

Preview compiled SecLang for a WAF policy

```text
tiyi policy preview-seclang <id> [flags]
```

Aliases: preview

Flags:

```text
  -h, --help   help for preview-seclang
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy rollback

Rollback a WAF policy to a saved version

```text
tiyi policy rollback <policy-id> [flags]
```

Flags:

```text
  -h, --help                help for rollback
      --version-id string   version id to restore
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy set-crs

Set a WAF policy active CRS ruleset

```text
tiyi policy set-crs <id> [flags]
```

Flags:

```text
      --crs-ruleset-id string   CRS ruleset id
  -h, --help                    help for set-crs
      --revision int            expected current revision
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy set-engine

Set a WAF policy engine state

```text
tiyi policy set-engine <id> [flags]
```

Flags:

```text
      --engine-state string   engine state: on | detection-only | off
  -h, --help                  help for set-engine
      --revision int          expected current revision
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy templates

List WAF policy templates

```text
tiyi policy templates [flags]
```

Flags:

```text
  -h, --help              help for templates
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy test

Test saved policy rules and optional site request controls

```text
tiyi policy test <id> [flags]
```

Flags:

```text
      --body string          request body
      --client-ip string     simulated client IP; no proxy trust resolution (default "192.0.2.1")
      --header stringArray   request header as 'Name: value' (repeatable)
  -h, --help                 help for test
      --method string        request method (default "GET")
      --peer-ip string       simulated connection peer IP; defaults to client IP
      --protocol string      request protocol: HTTP/1.0 | HTTP/1.1 | HTTP/2 | HTTP/3 (default
                             "HTTP/1.1")
      --site-id string       optional site using this policy, including overlays and native
                             request checks
      --url string           request URL or path (default "/")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy unbind-plugin

Remove a CRS plugin binding from a WAF policy

```text
tiyi policy unbind-plugin <policy-id> [flags]
```

Flags:

```text
  -h, --help               help for unbind-plugin
      --plugin-id string   CRS plugin id
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy update

Update a WAF policy

```text
tiyi policy update <id> [flags]
```

Flags:

```text
      --blocking-mode string    blocking mode: anomaly | self-contained
      --crs-ruleset-id string   active CRS ruleset id
      --description string      policy description
      --engine-state string     engine state: on | detection-only | off
  -h, --help                    help for update
      --name string             policy name
      --revision int            expected current revision
      --status string           status: draft | active | archived
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy version

Get a policy version

```text
tiyi policy version <version-id> [flags]
```

Flags:

```text
  -h, --help   help for version
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi policy versions

List policy versions

```text
tiyi policy versions <policy-id> [flags]
```

Flags:

```text
  -h, --help              help for versions
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release

Import and roll out Tiyi binary releases

```text
tiyi release [flags]
```

Aliases: releases

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for release
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi release apply

Roll a binary release out to matching agents

```text
tiyi release apply <release-id> [flags]
```

Queues an APPLY_BINARY command for every agent whose OS and arch
match the release. Each agent downloads the replacement from the
Controller's /bootstrap/binary endpoint, verifies the SHA-256, and
exits so the supervisor restarts into the new binary. Use
--agent-id (repeatable) to narrow the fan-out to specific agents,
for example when rolling through waves.

Flags:

```text
      --agent-id strings   limit fan-out to these agent ids (repeatable)
  -h, --help               help for apply
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release check-updates

Ask the server whether binary or CRS updates are available

```text
tiyi release check-updates [flags]
```

Flags:

```text
  -h, --help   help for check-updates
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release delete

Delete an imported binary release

```text
tiyi release delete <release-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release get

Show a single binary release

```text
tiyi release get <release-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release import

Import a binary release (from a tarball or a source URL)

```text
tiyi release import [flags]
```

Flags:

```text
  -h, --help                help for import
      --source-url string   server-reachable URL the import path will fetch
      --tarball string      local path to a binary release tarball
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release list

List imported binary releases

```text
tiyi release list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release rollback

Roll agents back to the previous binary

```text
tiyi release rollback [flags]
```

Flags:

```text
      --agent-id strings   limit rollback to these agent ids (repeatable)
  -h, --help               help for rollback
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release run-cancel

Cancel an in-flight upgrade run

```text
tiyi release run-cancel <run-id> [flags]
```

Flags:

```text
  -h, --help   help for run-cancel
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release run-get

Show details for a single upgrade run (including wave plan)

```text
tiyi release run-get <run-id> [flags]
```

Flags:

```text
  -h, --help   help for run-get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi release runs

List binary upgrade runs

```text
tiyi release runs [flags]
```

Flags:

```text
  -h, --help              help for runs
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role

Manage roles and permissions

```text
tiyi role [flags]
```

Aliases: roles

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for role
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi role create

Create a custom role

```text
tiyi role create [flags]
```

Flags:

```text
      --description string   role description
  -h, --help                 help for create
      --name string          role name (required)
      --permission strings   permission codes; may be repeated
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role delete

Delete a custom role

```text
tiyi role delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role get

Get one role

```text
tiyi role get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role list

List roles

```text
tiyi role list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi role permissions

List all available permission codes

```text
tiyi role permissions [flags]
```

Flags:

```text
  -h, --help   help for permissions
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule

Manage WAF rule tuning

```text
tiyi rule [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for rule
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi rule binding

Manage IP-list bindings (policy-wide and per-site, with optional path_prefix)

```text
tiyi rule binding [flags]
```

Flags:

```text
  -h, --help   help for binding
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule binding delete

Delete an IP-list binding

```text
tiyi rule binding delete <binding-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule binding list

List IP-list bindings for a policy (optionally filtered to a site)

```text
tiyi rule binding list <policy-id> [flags]
```

Flags:

```text
  -h, --help             help for list
      --site-id string   filter to bindings for this site (plus policy-wide bindings)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule binding upsert

Create or update an IP-list binding

```text
tiyi rule binding upsert [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country

Manage first-class country access rules

```text
tiyi rule country [flags]
```

Flags:

```text
  -h, --help   help for country
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country catalog

Show countries available in the active MMDB

```text
tiyi rule country catalog [flags]
```

Flags:

```text
  -h, --help   help for catalog
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country delete

Delete and atomically remove a country access rule

```text
tiyi rule country delete <rule-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country get

Get one country access rule

```text
tiyi rule country get <rule-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country list

List country access rules

```text
tiyi rule country list [flags]
```

Flags:

```text
  -h, --help   help for list
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule country set

Create or update and atomically apply a country access rule

```text
tiyi rule country set [rule-id] [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom

Manage custom SecLang rules

```text
tiyi rule custom [flags]
```

Flags:

```text
  -h, --help   help for custom
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom create

Create a custom SecLang rule

```text
tiyi rule custom create <policy-id> [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom delete

Delete a custom rule

```text
tiyi rule custom delete <custom-rule-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom get

Get one custom rule

```text
tiyi rule custom get <custom-rule-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom history

Summarize retained execution samples by frozen rule definition

```text
tiyi rule custom history [custom-rule-id] [flags]
```

Flags:

```text
      --end string            fixed historical window end (RFC3339); defaults to now
  -h, --help                  help for history
      --logical-rule-id int   historical rule number, also usable after deletion
      --lookback duration     retained sample window (1s to 168h, whole seconds) (default 1h0m0s)
      --policy-id string      historical policy identity, used with --logical-rule-id
      --site-id string        restrict retained samples to a site
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom list

List custom rules for a policy

```text
tiyi rule custom list <policy-id> [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom preview

Preview one custom SecLang rule

```text
tiyi rule custom preview [flags]
```

Flags:

```text
      --description string    custom rule description
      --enabled               enable the custom rule (default true)
  -h, --help                  help for preview
      --name string           custom rule name
      --phase int32           ModSecurity phase (default 2)
      --rule-id int           Tiyi custom rule id in 8000000..8999999
      --seclang string        raw SecLang directive
      --seclang-file string   read raw SecLang from a file
      --sort-order int32      custom rule sort order
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule custom update

Update a custom SecLang rule

```text
tiyi rule custom update <custom-rule-id> [flags]
```

Flags:

```text
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
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list

Manage reusable IP lists

```text
tiyi rule ip-list [flags]
```

Flags:

```text
  -h, --help   help for ip-list
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list create

Create a manual IP list

```text
tiyi rule ip-list create [flags]
```

Flags:

```text
      --description string   IP list description
      --entry strings        IP or CIDR entry, repeat or comma-separate
  -h, --help                 help for create
      --name string          IP list name
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list delete

Delete an IP list

```text
tiyi rule ip-list delete <ip-list-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list get

Get one IP list

```text
tiyi rule ip-list get <ip-list-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list list

List IP lists

```text
tiyi rule ip-list list [flags]
```

Flags:

```text
  -h, --help              help for list
      --mode string       filter by management mode: manual | subscription
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or description
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list lookup

Look up an IP address in a list

```text
tiyi rule ip-list lookup <ip-list-id> <ip> [flags]
```

Flags:

```text
  -h, --help   help for lookup
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list pause

Pause scheduled subscription syncs

```text
tiyi rule ip-list pause <ip-list-id> [flags]
```

Flags:

```text
  -h, --help   help for pause
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list replace

Atomically replace a manual list's complete content

```text
tiyi rule ip-list replace <ip-list-id> [flags]
```

Flags:

```text
      --description string   new description
      --etag string          opaque concurrency token; fetched automatically when omitted
  -f, --file string          file containing one IP or CIDR per line
  -h, --help                 help for replace
      --name string          new list name; defaults to the current name
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list resume

Resume and immediately sync a subscription

```text
tiyi rule ip-list resume <ip-list-id> [flags]
```

Flags:

```text
  -h, --help   help for resume
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list source-test

Fetch and validate a saved source without applying it

```text
tiyi rule ip-list source-test <ip-list-id> [flags]
```

Flags:

```text
  -h, --help   help for source-test
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list subscribe

Create a managed IP-list subscription

```text
tiyi rule ip-list subscribe [flags]
```

Flags:

```text
      --description string       subscription description
      --format string            plain-v1 | json-v1 | dns-spf-v1 (default "plain-v1")
  -h, --help                     help for subscribe
      --interval string          sync interval (default "6h")
      --json-path stringArray    RFC 9535 JSONPath selecting IP/CIDR strings; repeat the flag
                                 for multiple expressions
      --max-delete-ratio float   maximum automatic deletion ratio (default 0.5)
      --max-entries int32        maximum accepted entry count (default 500000)
      --min-entries int32        minimum accepted entry count (default 1)
      --name string              subscription name
      --secret-header strings    Name:stdin, Name:file=/path, or Name:literal
      --url string               HTTP(S) or dns:// source URL
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list sync

Queue an immediate subscription sync

```text
tiyi rule ip-list sync <ip-list-id> [flags]
```

Flags:

```text
  -h, --help   help for sync
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule ip-list sync-status

Show recent subscription sync runs

```text
tiyi rule ip-list sync-status <ip-list-id> [flags]
```

Flags:

```text
  -h, --help          help for sync-status
      --limit int32   number of recent runs (default 20)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override

Manage CRS rule overrides

```text
tiyi rule override [flags]
```

Flags:

```text
  -h, --help   help for override
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override delete

Delete a CRS rule override

```text
tiyi rule override delete <override-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override get

Get one CRS rule override

```text
tiyi rule override get <override-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override list

List CRS rule overrides for a policy

```text
tiyi rule override list <policy-id> [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule override upsert

Create or update a CRS rule override

```text
tiyi rule override upsert <policy-id> [flags]
```

Flags:

```text
      --action string           override verb: default | disable | log_only | score_override
                                (default "default")
      --add-target strings      add a CRS target, repeat or comma-separate
      --crs-rule-id string      CRS rule id to override
  -h, --help                    help for upsert
      --host strings            limit to these exact hosts; repeat or comma-separate (empty = all)
      --id string               edit or move this saved exception; omit to add without
                                replacing existing targets
      --method strings          limit to these HTTP methods; repeat or comma-separate (empty = all)
      --name string             descriptive exception name
      --path-exact              match only the exact --scope path, preserving its trailing slash
      --plan-token string       require the configuration and draft from this preview token
      --preview                 preview the exact change without saving
      --rationale string        operator rationale
      --remove-target strings   remove a CRS target, repeat or comma-separate
      --scope string            path and child paths; empty = all paths within the selected
                                site/policy
      --score-override int32    override the rule's anomaly contribution (0 silences it)
      --site-id string          limit the override to one site (empty = policy-wide)
      --tag strings             operator tag, repeat or comma-separate
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule rate-limit

Manage persisted rate-limit endpoints (policy-wide and per-site)

```text
tiyi rule rate-limit [flags]
```

Flags:

```text
  -h, --help   help for rate-limit
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule rate-limit delete

Delete a rate-limit endpoint

```text
tiyi rule rate-limit delete <endpoint-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule rate-limit list

List rate-limit endpoints for a policy (optionally filtered to a site)

```text
tiyi rule rate-limit list <policy-id> [flags]
```

Flags:

```text
  -h, --help             help for list
      --site-id string   filter to endpoints for this site (plus policy-wide endpoints)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi rule rate-limit upsert

Create a rate-limit endpoint, or update one by id

```text
tiyi rule rate-limit upsert [flags]
```

Flags:

```text
      --action string                   block | ban | challenge (default "block")
      --ban-scope string                temporary ban scope: site | global (required for ban)
      --bind-network                    custom only: check the browser again after its /24 or
                                        /56 network changes
      --challenge-profile string        browser-check treatment: comfort | standard | strict |
                                        custom (default "standard")
      --challenge-ttl int32             custom only: maximum browser-check completion time in
                                        seconds (30-600)
      --clearance-ttl int32             custom only: time before the browser is checked again
                                        in seconds (60-86400)
      --counting-key string             client identity: ip | session | header:<name> (default
                                        "ip")
      --enforcement-mode string         observe | enforce (default "observe")
  -h, --help                            help for upsert
      --id string                       existing endpoint id (required for update; omit only
                                        when creating)
      --method-mode string              explicit method mode: any | include (default "any")
      --methods strings                 HTTP methods for include mode, for example POST,PUT
      --mitigation-seconds int32        fixed action duration; blocked requests do not extend
                                        it (default 600)
      --path-pattern string             URI path pattern (compiler supports @beginsWith-style
                                        matches)
      --policy-id string                policy id
      --proof-difficulty int32          custom only: SHA-256 work factor in leading-zero bits
                                        (12-24)
      --request-count int32             requests allowed in the rolling window (default 5)
      --site-id string                  optional site id — make the endpoint site-scoped
      --sort-order int32                deterministic emit order
      --verified-request-count int32    custom only: requests allowed after the browser check
                                        (maximum 600)
      --verified-window-seconds int32   custom only: rolling window after the browser check
      --window-seconds int32            rolling-window duration in seconds (default 60)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi run

Run the complete Tiyi instance with its built-in local data plane

```text
tiyi run [flags]
```

Flags:

```text
      --addr string                 override HTTP listen address (default "0.0.0.0:8080")
      --admin-socket string         local Unix socket for passwordless operator CLI; empty
                                    disables (default "<automatic local socket>")
      --admin-socket-group string   group owner for the local admin socket
      --admin-socket-mode string    file mode for the local admin socket (default "0600")
      --caddy-admin-socket string   embedded Caddy admin Unix socket (default
                                    "/var/lib/tiyi/caddy-admin.sock")
  -h, --help                        help for run
      --proxy-http-addr string      embedded Caddy HTTP listen address for TLS-disabled sites
                                    (default ":80")
      --proxy-https-addr string     embedded Caddy HTTPS listen address for TLS-enabled sites
                                    (default ":443")
      --state-db string             override path to state.db (default "/var/lib/tiyi/state.db")
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi site

Manage sites

```text
tiyi site [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for site
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi site create

Create a site

```text
tiyi site create [flags]
```

Flags:

```text
      --alias stringArray                 host alias; repeatable; supports '*.example.com';
                                          quote wildcard values
      --bot string                        site-wide bot protection: off | browser-check |
                                          human-verification (default "off")
      --bot-bind-network                  bind clearance to the client network
      --bot-challenge-ttl int             browser challenge lifetime in seconds (30-600)
                                          (default 120)
      --bot-clearance-ttl int             site clearance lifetime in seconds (300-86400)
                                          (default 3600)
      --bot-exempt-path stringArray       literal path prefix exempt from bot protection;
                                          repeatable
      --bot-proof-difficulty int          proof-of-work leading zero bits (12-24) (default 16)
      --bot-trusted-ip-list stringArray   IP list id exempt from bot protection; repeatable
      --health-check-path string          inline upstream active health-check path
  -h, --help                              help for create
      --host string                       primary host; '*.example.com' matches one subdomain
                                          level, not the root domain
      --name string                       site display name
      --tls string                        TLS mode: none | managed-acme | uploaded (default
                                          "managed-acme")
      --tls-cert-id string                uploaded certificate id when --tls uploaded
      --tls-http-behavior string          HTTP behavior for TLS sites: redirect | acme-only |
                                          serve-both (default "redirect")
      --tls-min-version string            minimum TLS version: 1.2 | 1.3
      --upstream-url stringArray          inline upstream URL; repeatable
      --waf                               enable WAF (default true)
      --waf-mode string                   WAF mode: blocking | detection (default "blocking")
      --waf-policy string                 WAF policy id for live enforcement
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site delete

Delete a site

```text
tiyi site delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site disable

Disable a site

```text
tiyi site disable <id> [flags]
```

Flags:

```text
  -h, --help           help for disable
      --revision int   expected current revision
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site enable

Enable a site

```text
tiyi site enable <id> [flags]
```

Flags:

```text
  -h, --help           help for enable
      --revision int   expected current revision
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site export

Export all sites by default, or one site by ID, including referenced TLS private key material

```text
tiyi site export [id] [flags]
```

Flags:

```text
      --force           overwrite an existing output file
  -h, --help            help for export
  -o, --output string   output file (default: server-provided name; use - for stdout)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site get

Get a site

```text
tiyi site get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site import

Import one site configuration or an all-sites archive as new resources

```text
tiyi site import <file> [flags]
```

Flags:

```text
  -h, --help   help for import
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site list

List sites

```text
tiyi site list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or primary host
      --status string     filter by status: active | disabled | deleted | error
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override

Manage per-site policy overrides

```text
tiyi site policy-override [flags]
```

Flags:

```text
  -h, --help   help for policy-override
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override delete

Remove a per-site policy override

```text
tiyi site policy-override delete <site-id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override get

Show the policy override (if any) for a site

```text
tiyi site policy-override get <site-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site policy-override set

Upsert a per-site policy override

```text
tiyi site policy-override set <site-id> [flags]
```

Set a per-site override for any of:
	--blocking-pl / --executing-pl  (CRS docs § 2-2)
	--inbound-threshold / --outbound-threshold  (CRS docs § 2-1)
	--sampling-percentage  (CRS docs § 2-4)

Unset flags inherit the attached policy's values. --policy-id is optional; when
omitted, the site's currently attached policy is used.

Flags:

```text
      --blocking-pl int32           blocking paranoia level override (1..4) (default 1)
      --executing-pl int32          executing (detection) paranoia level override (1..4)
                                    (default 1)
  -h, --help                        help for set
      --inbound-threshold int32     inbound anomaly score threshold override (default 5)
      --outbound-threshold int32    outbound anomaly score threshold override (default 4)
      --policy-id string            policy id (defaults to the site's attached WAF policy)
      --rationale string            short note explaining why the override exists
      --sampling-percentage int32   sampling percentage override (0..100) (default 100)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site routing

Manage a site's path routing

```text
tiyi site routing [flags]
```

Flags:

```text
  -h, --help   help for routing
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site routing get

Show a site's path routing

```text
tiyi site routing get <site-id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site routing set

Replace a site's path routing

```text
tiyi site routing set <site-id> [flags]
```

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

Flags:

```text
  -h, --help                help for set
      --revision int        expected site revision for optimistic concurrency (0 = unchecked)
      --route stringArray   a route as PREFIX=UPSTREAM_ID[:strip] (repeatable)
      --unmatched string    unmatched-path action: "default" or "404" (default "default")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi site update

Update a site

```text
tiyi site update <id> [flags]
```

Flags:

```text
      --alias stringArray                 host alias; repeatable; supports '*.example.com';
                                          quote wildcard values
      --bot string                        site-wide bot protection: off | browser-check |
                                          human-verification
      --bot-bind-network                  bind clearance to the client network
      --bot-challenge-ttl int             browser challenge lifetime in seconds (30-600)
      --bot-clearance-ttl int             site clearance lifetime in seconds (300-86400)
      --bot-exempt-path stringArray       literal path prefix exempt from bot protection;
                                          repeatable
      --bot-proof-difficulty int          proof-of-work leading zero bits (12-24)
      --bot-trusted-ip-list stringArray   IP list id exempt from bot protection; repeatable
      --health-check-path string          inline upstream active health-check path
  -h, --help                              help for update
      --host string                       primary host; '*.example.com' matches one subdomain
                                          level, not the root domain
      --name string                       site display name
      --revision int                      expected current revision
      --tls string                        TLS mode: none | managed-acme | uploaded
      --tls-cert-id string                uploaded certificate id when --tls uploaded
      --tls-http-behavior string          HTTP behavior for TLS sites: redirect | acme-only |
                                          serve-both
      --tls-min-version string            minimum TLS version: 1.2 | 1.3
      --upstream-url stringArray          inline upstream URL; repeatable
      --waf                               enable WAF
      --waf-mode string                   WAF mode: blocking | detection
      --waf-policy string                 WAF policy id for live enforcement
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system

Read system health and manage settings

```text
tiyi system [flags]
```

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for system
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi system attack-distribution

Read dashboard attack-tag distribution

```text
tiyi system attack-distribution [flags]
```

Flags:

```text
      --end string     exclusive RFC3339 end time
  -h, --help           help for attack-distribution
      --limit int32    maximum number of rows (default 10)
      --start string   inclusive RFC3339 start time
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system health

Read system health

```text
tiyi system health [flags]
```

Flags:

```text
  -h, --help   help for health
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system set-ai-key

Store the AI provider API key from stdin (write-only, encrypted)

```text
tiyi system set-ai-key [flags]
```

Store the AI provider API key under the KEK/DEK envelope (requires system:write).

The key is read from stdin to keep it out of argv and shell history, is never
returned by any RPC, and an empty value is a no-op that preserves the stored key.

  printf %s "$OPENAI_API_KEY" | tiyi system set-ai-key

Flags:

```text
  -h, --help   help for set-ai-key
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system settings

Manage persisted system settings

```text
tiyi system settings [flags]
```

Flags:

```text
  -h, --help   help for settings
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system settings get

Read all persisted system settings

```text
tiyi system settings get [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system settings update

Update persisted system settings

```text
tiyi system settings update [flags]
```

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
    ai.timeout_seconds            int    Whole-task timeout (default 30, max 120).
    ai.max_requests_per_minute    int    Actual provider calls per minute (default 60).
    ai.max_output_tokens          int    Streamed tokens (default 2048, range 256..8192).
    ai.redaction_profile          string Legacy; external AI always uses strict redaction.
    ai.web.enabled                bool   Public advisory/CVE research (default false).
    ai.web.search_url             string SearXNG JSON search endpoint (optional).
                                  Administrator-selected HTTP(S) URL; no credentials,
                                  query or fragment. Only this endpoint may be private.
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

Flags:

```text
  -h, --help                 help for update
      --set stringArray      setting assignment key=value; repeatable
      --values-json string   JSON object of settings to update
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system stats

Read global node, site, certificate and log health

```text
tiyi system stats [flags]
```

Flags:

```text
  -h, --help   help for stats
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system top-attackers

Read dashboard top client IP attackers

```text
tiyi system top-attackers [flags]
```

Flags:

```text
      --end string     exclusive RFC3339 end time
  -h, --help           help for top-attackers
      --limit int32    maximum number of rows (default 10)
      --start string   inclusive RFC3339 start time
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system traffic

Read dashboard traffic timeseries

```text
tiyi system traffic [flags]
```

Flags:

```text
      --bucket-size string   bucket size: 1m | 5m | 15m | 1h | 1d (default "1h")
      --end string           exclusive RFC3339 end time
  -h, --help                 help for traffic
      --start string         inclusive RFC3339 start time
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi system version

Read server build metadata

```text
tiyi system version [flags]
```

Flags:

```text
  -h, --help   help for version
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust

Configure how Tiyi identifies the client IP for each request

```text
tiyi trust [flags]
```

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


Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for trust
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi trust reset

Restore the safe default (no proxies trusted, no headers honoured)

```text
tiyi trust reset [flags]
```

Flags:

```text
  -h, --help          help for reset
      --site string   reset only the per-site override
      --yes           confirm the destructive operation
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust set

Set or replace the trust profile

```text
tiyi trust set [flags]
```

Replace the trust profile with stable IP-list references and an
ordered Header list. --proxy expects NAME=IP_LIST_ID and may be repeated;
distinct names become ordered proxy hops. Source URLs, credentials, schedules,
and content are managed only through
`tiyi rule ip-list`.

Verified --header rules require a proxy path. --fixed-header is the explicit
no-topology escape path. Use --file for alternatives or sparse topologies.

Flags:

```text
  -f, --file string             YAML/JSON profile file ('-' for stdin)
      --fixed-header strings    unverified fixed-position Header (repeatable; ordered)
      --fixed-position uint32   one-based N for --fixed-selector nth-from-right
      --fixed-selector string   fixed extraction: single, leftmost, rightmost, or
                                nth-from-right (default "single")
      --force                   allow non-safelisted forwarded headers (audited)
      --header strings          verified forwarded Header (repeatable; ordered)
  -h, --help                    help for set
      --proxy strings           proxy node as "name=ip-list-id" (repeatable; ordered)
      --site string             apply as per-site override
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust show

Show the active trust profile

```text
tiyi trust show [flags]
```

Flags:

```text
      --format string   yaml | json | table (default "table")
  -h, --help            help for show
      --site string     show the per-site override (empty ⇒ deployment default)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi trust test

Replay a request against the active profile and explain the result

```text
tiyi trust test [flags]
```

Flags:

```text
      --header strings   header line; repeatable; format "Name: value"
  -h, --help             help for test
      --peer string      the peer address (e.g. 198.51.100.7)
      --site string      evaluate against a per-site override
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi uninstall

Stop and remove the systemd unit (preserves data unless --purge)

```text
tiyi uninstall [flags]
```

Disable and stop the unit, remove it from /etc/systemd/system, and
reload systemd. State under /var/lib/tiyi, config under /etc/tiyi, and
the service user/group are preserved unless --purge is given.

Flags:

```text
  -h, --help               help for uninstall
      --purge              also remove /var/lib/tiyi, /etc/tiyi, and the service user/group
                           (DESTRUCTIVE, irreversible)
      --unit-name string   systemd unit name (without .service) (default "tiyi")
  -y, --yes                skip the --purge confirmation prompt
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi update

Download, verify, and install the latest signed Tiyi release

```text
tiyi update [flags]
```

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

Flags:

```text
      --api-base-url string   GitHub API base URL override (default: update.api_base_url)
      --channel string        release channel: stable | prerelease (default: update.channel)
      --check                 only report whether an update is available
  -h, --help                  help for update
      --mirror string         download mirror: auto | github | gitee (default: update.mirror)
      --repo string           GitHub owner/name for github/auto (default: update.repo /
                              TIYI_UPDATE_REPO)
      --yes                   download, verify, and install without prompting
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi upstream

Manage reusable upstream pools

```text
tiyi upstream [flags]
```

Aliases: upstreams

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for upstream
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi upstream create

Create an upstream pool

```text
tiyi upstream create [flags]
```

Flags:

```text
      --description string                 upstream pool description
      --endpoint-url stringArray           backend URL; repeatable
      --endpoint-weight int32Slice         endpoint weight 1..100 in --endpoint-url order
                                           (default [])
      --failover-retry                     retry safe requests against another available
                                           endpoint (default true)
      --health-check-method string         active health-check method: GET | HEAD (default "GET")
      --health-check-path string           pool-level active health-check path; empty disables
      --health-expected-body string        optional RE2 response-body expression
      --health-expected-status int32       expected HTTP status or class (for example 200 or
                                           2) (default 200)
      --health-follow-redirects            follow redirects during active health checks
      --health-healthy-threshold int32     consecutive passes before Caddy marks an endpoint
                                           healthy (default 2)
      --health-host string                 optional Host header for backend probes
      --health-interval int32              probe interval in seconds (default 30)
      --health-timeout int32               probe timeout in seconds (default 5)
      --health-unhealthy-threshold int32   consecutive failures before Caddy marks an endpoint
                                           unhealthy (default 3)
  -h, --help                               help for create
      --name string                        upstream pool name
      --passive-fail-duration int32        seconds to remember each proxy failure (default 30)
      --passive-health                     eject endpoints after real proxy failures (default true)
      --passive-max-fails int32            remembered failures before an endpoint is ejected
                                           (default 2)
      --request-header stringArray         plaintext origin request header as 'Name: value';
                                           repeatable
      --retry-duration int32               maximum retry selection window in seconds (default 5)
      --retry-interval-ms int32            delay between retry selections in milliseconds
                                           (default 250)
      --status string                      status: active | disabled | error (default "active")
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream delete

Delete an upstream pool

```text
tiyi upstream delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream get

Get an upstream pool

```text
tiyi upstream get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream health

List Caddy-reported upstream endpoint health by node

```text
tiyi upstream health [upstream-id] [flags]
```

Flags:

```text
  -h, --help   help for health
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream list

List upstream pools

```text
tiyi upstream list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by name or description
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi upstream update

Update an upstream pool

```text
tiyi upstream update <id> [flags]
```

Flags:

```text
      --description string                 upstream pool description
      --endpoint-url stringArray           backend URL; repeatable
      --endpoint-weight int32Slice         endpoint weight 1..100 in --endpoint-url order
                                           (default [])
      --failover-retry                     retry safe requests against another available
                                           endpoint (default true)
      --health-check-method string         active health-check method: GET | HEAD (default "GET")
      --health-check-path string           pool-level active health-check path; empty disables
      --health-expected-body string        optional RE2 response-body expression
      --health-expected-status int32       expected HTTP status or class (for example 200 or
                                           2) (default 200)
      --health-follow-redirects            follow redirects during active health checks
      --health-healthy-threshold int32     consecutive passes before Caddy marks an endpoint
                                           healthy (default 2)
      --health-host string                 optional Host header for backend probes
      --health-interval int32              probe interval in seconds (default 30)
      --health-timeout int32               probe timeout in seconds (default 5)
      --health-unhealthy-threshold int32   consecutive failures before Caddy marks an endpoint
                                           unhealthy (default 3)
  -h, --help                               help for update
      --name string                        upstream pool name
      --passive-fail-duration int32        seconds to remember each proxy failure (default 30)
      --passive-health                     eject endpoints after real proxy failures (default true)
      --passive-max-fails int32            remembered failures before an endpoint is ejected
                                           (default 2)
      --request-header stringArray         plaintext origin request header as 'Name: value';
                                           repeatable
      --retry-duration int32               maximum retry selection window in seconds (default 5)
      --retry-interval-ms int32            delay between retry selections in milliseconds
                                           (default 250)
      --status string                      status: active | disabled | error
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user

Manage users

```text
tiyi user [flags]
```

Aliases: users

Flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -h, --help                  help for user
      --token string          remote bearer access token (or TIYI_TOKEN)
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```

## tiyi user assign-roles

Replace a user's role assignments

```text
tiyi user assign-roles <user-id> [flags]
```

Flags:

```text
  -h, --help              help for assign-roles
      --role-id strings   role IDs; may be repeated
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user create

Create a user

```text
tiyi user create [flags]
```

Flags:

```text
      --display-name string   display name
      --email string          email address
  -h, --help                  help for create
      --password string       password (required)
      --role-id strings       role IDs to assign; may be repeated
      --username string       username (required)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user delete

Delete a user

```text
tiyi user delete <id> [flags]
```

Flags:

```text
  -h, --help   help for delete
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user get

Get one user

```text
tiyi user get <id> [flags]
```

Flags:

```text
  -h, --help   help for get
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user list

List users

```text
tiyi user list [flags]
```

Flags:

```text
  -h, --help              help for list
      --page int32        page number (default 1)
      --page-size int32   page size (default 50)
  -q, --query string      filter by username, email, or name
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user lock

Lock a user account

```text
tiyi user lock <user-id> [flags]
```

Flags:

```text
  -h, --help   help for lock
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user reset-password

Reset a user's password

```text
tiyi user reset-password <user-id> [flags]
```

Flags:

```text
  -h, --help              help for reset-password
      --password string   new password (required)
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi user unlock

Unlock a user account

```text
tiyi user unlock <user-id> [flags]
```

Flags:

```text
  -h, --help   help for unlock
```

Inherited flags:

```text
      --admin-socket string   local admin Unix socket (default "<automatic local socket>")
      --api string            remote ConnectRPC API base URL; defaults to local admin socket
  -c, --config string         path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string      override log level: debug | info | warn | error
      --token string          remote bearer access token (or TIYI_TOKEN)
```

## tiyi version

Print version, commit, and build metadata

```text
tiyi version [flags]
```

Flags:

```text
  -h, --help   help for version
```

Inherited flags:

```text
  -c, --config string      path to the Tiyi config file (default "/etc/tiyi/tiyi.yaml")
      --log-level string   override log level: debug | info | warn | error
```
