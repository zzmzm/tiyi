# Configuration templates

Tiyi has two YAML surfaces. `tiyi.yaml` controls process startup. A declarative
manifest controls durable application resources. One cannot be pasted into the
other.

| File | Controls | Activation |
|---|---|---|
| [`templates/tiyi.yaml`](templates/tiyi.yaml) | API/proxy listeners, state path, authentication, update and Geo settings | Start/restart `tiyi run --config ...` |
| [`templates/apply.yaml`](templates/apply.yaml) | Sites, upstream pools, basic WAF policies and IP-list addresses | `tiyi diff -f ...`, then `tiyi apply -f ...` |

Console system settings, certificates, policy layers, rules, IP-list bindings,
Country Access, alert/SIEM configuration, users and roles are durable too, but
are not supported apply kinds. Use their dedicated UI, CLI or API.

## Install and validate `tiyi.yaml`

The template contains every current process key. Omitted keys keep built-in
defaults.

```sh
# Create the service identity/unit without starting it.
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo install -m 0640 -o root -g tiyi \
  docs/en/templates/tiyi.yaml /etc/tiyi/tiyi.yaml
sudo editor /etc/tiyi/tiyi.yaml

# Read-only config and startup diagnostics.
sudo tiyi --config /etc/tiyi/tiyi.yaml doctor --mode run

# Pre-create the administrator, print its one-time password here, and start.
sudo tiyi install --now
```

When reading these files outside a repository checkout, download the linked
template first or copy its complete YAML block. The packaged unit reads
`/etc/tiyi/tiyi.yaml`. A direct foreground process can use another path with
`tiyi --config /path/to/tiyi.yaml run`.

Precedence is built-in defaults, YAML, supported `TIYI_*` config environment
variables, then explicit CLI flags. Important safety points:

- Set `auth.jwt_secret` to a private random value of at least 32 bytes before
  production. Empty makes existing sessions invalid after every restart.
- An empty `crypto.kek_file` uses the persistent
  `<state-db-dir>/kek.bin`; Tiyi creates it once. Back it up with `state.db`.
  An external KEK path is optional and must point to an existing/readable
  32-byte file (or a location the service can create).
- Leave all bootstrap fields empty for the one-time random administrator
  password. Do not retain a real bootstrap password in a readable file.
- Set `auth.refresh_cookie_secure: true` for an HTTPS console.

## Preview and apply durable resources

```sh
cp docs/en/templates/apply.yaml desired.yaml
editor desired.yaml
tiyi crs list                   # verify crsRulesetRef
tiyi diff -f desired.yaml       # read-only preview
tiyi apply -f desired.yaml --dry-run
tiyi apply -f desired.yaml
tiyi system health
```

Add `--api URL --token JWT` when operating remotely. Use `-f -` for stdin.

Every document requires `apiVersion: tiyi.io/v1`, a supported `kind`,
`metadata.name`, and `spec`. Supported kinds are exactly `Upstream`, `Site`,
`Policy`, and `IpList`. Documents are separated by `---`.

Apply rules that prevent surprises:

- Matching is case-insensitive by `(kind, metadata.name)`. Changing a name
  creates another resource; it does not rename or delete the old one.
- `metadata.id` is an optional UUID used only at creation. The authenticated
  caller selects the tenant, so `metadata.tenant` is rejected.
- References (`upstreamRef`, `policyRef`, `certRef`, `crsRulesetRef`) resolve by
  resource name, CRS ID, or CRS version before writes. Forward references in
  the same file work.
- A supplied `spec` fully replaces the apply-managed fields. Omitted optional
  fields return to defaults/empty values; apply is not a merge patch.
- Unknown fields and API/database aliases are rejected. Apply never deletes a
  resource that is absent from the file.
- Database writes for one manifest use one SQLite transaction. A parse,
  reference, or mutation failure rolls the whole transaction back.
- Proxy publication happens after commit. `proxy apply failed` therefore means
  rows are durable but the proxy retained its last-good runtime config. Fix the
  cause and re-apply the same manifest.

## Supported spec fields

| Kind | Current apply fields |
|---|---|
| `Upstream` | Required `backends[]` (`url`, `weight`, `healthCheckPath`); `loadBalance` (`round_robin`); `healthCheck` (`path`, `method`, `expectedStatus`, `intervalSeconds`, `timeoutSeconds`, `unhealthyThreshold`, `healthyThreshold`, `followRedirects`, `expectedBody`, `host`); `status` (`active`, `disabled`). An empty health path disables active probes. |
| `Site` | `primaryHost`; `aliases[]`; at most one of `upstreamRef` and `upstreamsInline[]`; `tls` (`mode`, `certRef`, `minVersion`, `httpBehavior`); `waf` (`enabled`, `policyRef`, `mode`); `botProtection` (`mode`, challenge/clearance TTLs, proof difficulty, network binding, exempt paths, trusted IP-list refs; active modes require HTTPS-only); `status`. |
| `Policy` | `engineState` (`on`, `detection_only`, `off`); `blockingMode` (`anomaly`, `self_contained`); `crsRulesetRef`; `status` (`draft`, `active`, `archived`). Active requires a ruleset. Layers/rules/bindings are separate resources. |
| `IpList` | `description`; `entries[]` (`cidr`, `description`, RFC 3339 `expireAt`). Single IPs normalize to `/32` or `/128`. `geo:*` is rejected. Applying a list does not enforce it until a binding is created. |

Certificates are not an apply kind. Create or issue one with the certificate UI
or CLI, then reference its name from `Site.spec.tls.certRef`.
