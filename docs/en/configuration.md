# Configuration and templates

For **v3.8.0**. Choose a file by the task you want to complete; each format has its own entry point and field names.

| Task | File / download | Use it with |
|---|---|---|
| Change listeners, state paths, or startup authentication | [Full tiyi.yaml](templates/tiyi.yaml) | `/etc/tiyi/tiyi.yaml`, then restart |
| Create a first site or repeatedly deploy named resources | [Minimal first-site.yaml](templates/first-site.yaml) | `tiyi diff` → `tiyi apply` |
| Define a basic policy, IP list, site, and upstream | [Four-kind apply.yaml](templates/apply.yaml) | Edit, then `tiyi diff` → `tiyi apply` |
| Import a new site with its dependencies | [site-import.json](templates/site-import.json) | [Site import](site-import.md); `tiyi site import` or the site page |
| Describe your application's request fields | [orders-openapi.yaml](templates/orders-openapi.yaml) | [API Assets import](api-protection.md), separate from site import |

The copyable starters below work without a repository checkout. The full templates are references; new users do not need to fill every option.

<a id="startup"></a>
## 1. Startup configuration for a fresh installation

This uses the default `0.0.0.0:8080` management listener and website ports 80/443. Open `http://SERVER_IP:8080` in your browser, using the Tiyi host's IP address.
Run after installing the binary on a **fresh host, before starting the service**. For an existing installation, back up and edit your file instead of overwriting it.

```sh
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo tee /etc/tiyi/tiyi.yaml >/dev/null <<'YAML'
server:
  addr: "0.0.0.0:8080"
store:
  state_db: "/var/lib/tiyi/state.db"
proxy:
  http_addr: ":80"
  https_addr: ":443"
  caddy_admin_socket: "/var/lib/tiyi/caddy-admin.sock"
log:
  level: "info"
auth:
  refresh_cookie_secure: false
geo:
  auto_update: true
update:
  repo: "zzmzm/tiyi"
  channel: "stable"
  mirror: "auto"
YAML
sudo chown root:tiyi /etc/tiyi/tiyi.yaml
sudo chmod 0640 /etc/tiyi/tiyi.yaml
sudo tiyi --config /etc/tiyi/tiyi.yaml doctor --mode run
sudo tiyi install --now
```

`doctor` checks startup prerequisites, not website reachability. Follow with `sudo tiyi system health` and an actual request.
For a foreground process, use `sudo tiyi --config /etc/tiyi/tiyi.yaml run`.
After editing an existing service's YAML, run `sudo systemctl restart tiyi`.
Sites and policies are saved through the UI/CLI/API and normally publish without restarting or editing startup YAML.

<a id="ports"></a>
## 2. Use different ports alongside another web server

Replace the corresponding sections in the starter:

```yaml
server:
  addr: "0.0.0.0:8081"
proxy:
  http_addr: ":8180"
  https_addr: ":18443"
  caddy_admin_socket: "/var/lib/tiyi/caddy-admin.sock"
```

For an existing service, back up the startup file, edit these fields while preserving the rest, and restart:

```sh
sudo cp -a /etc/tiyi/tiyi.yaml /etc/tiyi/tiyi.yaml.before-ports
sudoedit /etc/tiyi/tiyi.yaml
sudo systemctl restart tiyi
sudo systemctl status tiyi --no-pager
sudo tiyi system health
curl -i -H 'Host: quickstart.test' http://127.0.0.1:8180/
```

Choose a different backup filename if it exists. A default installation may not have YAML yet; create it using the preceding section first. For the first startup of a fresh installation, use `sudo tiyi install --now`.
This probe requires the existing `quickstart.test` site and running origin; otherwise finish the [quickstart](getting-started.md) first.

Open `http://SERVER_IP:8081` in your browser. Management now uses 8081; website HTTP requests use 8180, while the origin port is unchanged.
For a TLS site, test `curl --resolve app.example.com:18443:SERVER_IP https://app.example.com:18443/` with your real domain/IP and a covering certificate.

Inspect the journal on failure. To undo this change, restore its `tiyi.yaml.before-ports` backup to `tiyi.yaml` and restart.
Public ACME HTTP-01 still uses public port 80; changing the local listener does not change the CA's destination. When another web server occupies the ports, decide which service owns public ingress before moving ports or adding forwarding.

## 3. Stable secrets and precedence

Defaults → YAML → supported `TIYI_*` environment variables → explicit CLI flags; later values win.
For example, `TIYI_SERVER_ADDR` maps to `server.addr`. The [annotated template](templates/tiyi.yaml) includes startup keys, defaults, and LDAP/RADIUS options.
Configure the admin socket through `--admin-socket`, `--admin-socket-mode`, and `--admin-socket-group`; these are not keys in this YAML.

Before first production startup, set a stable JWT secret so sessions survive restarts. For a **fresh installation without this file**, create a root-readable systemd environment file below.
If `tiyi.env` already exists, add only the missing key and preserve the existing secret and settings.

```sh
sudo sh -c 'umask 077; printf "TIYI_AUTH_JWT_SECRET=%s\n" "$(openssl rand -hex 32)" > /etc/tiyi/tiyi.env'
sudo systemctl restart tiyi
```

The default KEK persists as `kek.bin` beside the state database. Back it up with state; encrypted certificates and secrets need it.
Use `auth.refresh_cookie_secure: true` for an HTTPS console; keep false for the HTTP-only demo.
The `auth.bootstrap_admin_*` settings or their environment variables provision the first user only; they do not reset an existing user's password.

<a id="apply"></a>
## 4. Create a protected site from a file

First make `http://127.0.0.1:9000` reachable (the [demo origin](getting-started.md) works).
Copy the whole block. For your own app, change the domain, origin URL, and two resource names first.
WAF-enabled sites without `policyRef` use the built-in Light policy.

```sh
cat > first-site.yaml <<'YAML'
apiVersion: tiyi.io/v1
kind: Upstream
metadata:
  name: example-origin
spec:
  backends:
    - url: http://127.0.0.1:9000
      weight: 100
  loadBalance: round_robin
  status: active
---
apiVersion: tiyi.io/v1
kind: Site
metadata:
  name: example-site
spec:
  primaryHost: app.example.com
  upstreamRef: example-origin
  tls:
    mode: none
  waf:
    enabled: true
    mode: blocking
  status: active
YAML
sudo tiyi diff -f first-site.yaml
sudo tiyi apply -f first-site.yaml --dry-run
sudo tiyi apply -f first-site.yaml
curl -i -H 'Host: app.example.com' http://127.0.0.1/
```

Expect the same normal response as the origin. The file has two documents separated by `---`.
These local service commands use `sudo`; for a custom foreground instance, supply its `--admin-socket`.

For a [wildcard site](operations.md#wildcard-hosts), use `primaryHost: "*.example.com"` in the Site document above. Quote wildcard values in YAML. The same one-subdomain-level rule applies to `aliases`; add `example.com` separately for the root domain and the exact API hosts needed by OpenAPI/Schema mappings. Prepare a covering certificate before enabling HTTPS.

## 5. How apply handles existing resources

- Resources match by case-insensitive `(kind, metadata.name)`. Changing a name creates a resource; it does not rename the old one.
- `spec` replaces the fields managed by apply; omitted optional fields may reset or clear. Review the diff: this is not a merge patch.
- Removing a resource from the file does not delete the live resource. Unknown keys are rejected.
- `upstreamRef`, `policyRef`, and `certRef` resolve names; CRS accepts IDs or versions. Forward references within a file are supported.
- Optional `metadata.id` supplies a UUID only on creation. The authenticated identity determines the tenant; `metadata.tenant` is rejected.
- Database writes for one manifest share a transaction. Proxy publication follows commit: on publication failure the saved resources remain, while traffic uses the last valid configuration. Fix, retry, and check node results.

## 6. Supported kinds and limits

| Kind | Main fields | Notes |
|---|---|---|
| `Upstream` | `backends[].url/weight/healthCheckPath`, `loadBalance`, `healthCheck`, `status` | `round_robin` balancing; an empty health-check `path` disables active probes |
| `Site` | `primaryHost`, `aliases`, `upstreamRef` or `upstreamsInline`, `tls`, `waf`, `botProtection`, `status` | The two upstream choices are exclusive; Bot protection requires HTTPS-only; create certificates separately first |
| `Policy` | `engineState`, `blockingMode`, `crsRulesetRef`, `status` | An active policy needs an existing CRS; manage advanced layers, rules, and bindings separately |
| `IpList` | `description`, `entries[].cidr/description/expireAt` | Addresses alone do not enforce: add a binding; expiry is RFC 3339; `geo:*` is unsupported |

See the [four-kind template](templates/apply.yaml) for complete fields and comments.
Certificates, routes, rate limits, API documents, users, alerts, and SIEM are not apply kinds. Use [operations](operations.md), [CLI](cli.md), or [API](api.md).
API JSON has a different schema: for example, apply `backends` corresponds to API upstream `endpoints`.

Current apply rejects nonempty `trustedIpListRefs` name references. Keep it empty in the manifest and bind the list in site Bot settings after creation.
