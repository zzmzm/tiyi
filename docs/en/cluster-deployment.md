# Cluster deployment: one Controller, multiple Agents, and a load balancer

For **v3.8.0**, reviewed **2026-09-30**. **One Controller + two or more remote Agents behind an external HA load balancer is the recommended topology when you need traffic-node redundancy or horizontal capacity.** For a first installation or a small workload with maintenance windows, [one Controller with its built-in Agent](single-deployment.md) is simpler.

```text
Business traffic
Visitors ──> HA load balancer / VIP ──┬─> Agent A ──┬─> Application origins
                                     └─> Agent B ──┘

Management and configuration
Administrators ──> HTTPS management gateway ──> One Controller
Agent A / Agent B ── outbound HTTPS stream ───> One Controller
```

The LB business pool contains **Agent traffic listeners**, usually 80/443. Use a separate stable management URL for the Controller. For this topology, leave the Controller's built-in data plane out of the business pool so its host maintenance and resource use do not consume a traffic node. It still exists and receives configuration; no Controller-only runtime switch is required.

This is a centrally managed WAF fleet. Tiyi has one writable Controller and no built-in election, state replication, or automatic Controller failover. An external LB distributes traffic; Tiyi's upstream pools separately distribute accepted traffic to application origins.

<a id="prepare"></a>
## 1. Prepare the hosts and network

Start with one Controller, two Agents on different hosts/failure domains, and a managed HA LB or two LB instances with a tested VIP/failover arrangement. A single LB host remains a single point of failure. Use private networking between tiers and preserve enough capacity to serve peak load after one Agent is removed.

| Connection | Allow | Purpose |
|---|---|---|
| Visitors → LB | Business 80/443 | Public site entry; point business DNS here |
| LB → Agents | Configured HTTP/HTTPS listeners | Business forwarding and health probes |
| Administrators → management gateway | HTTPS 443, restricted management sources | Console and API |
| Agents → management gateway → Controller | Outbound HTTPS 443 → management 8080 | Enrollment, long-lived stream, configuration and observation |
| Controller and all receiving nodes → origins | Actual application ports | Save-time validation and runtime proxying |
| Nodes → DNS, time service, configured SIEM; Controller → CA/DNS provider | Required destinations only | Name resolution, clock synchronization, external delivery and certificate renewal |

Restrict Agent traffic ingress to the LB and authorized probe/administration sources; restrict origin ingress to Tiyi. Preserve required application dependencies. Do not expose privileged admin sockets or Caddy administration over the network.

Use persistent local disk on each node and independent Agent identity/state. Do not share one Agent state directory or SQLite database across hosts. Synchronize clocks. Keep one reviewed Tiyi build across the fleet; Community allows the built-in node but **zero remote Agents**, so import a signed license with enough remote-node capacity before enrollment.

<a id="controller"></a>
## 2. Install the Controller and enroll Agents

Install the Controller using [single-server steps](single-deployment.md#install). Put its management listener behind a trusted HTTPS gateway at, for example, `https://control.example.com`. Configure the gateway to reach the Controller's management port, support the Agent's long-lived bidirectional stream, and avoid short idle timeouts or buffering that breaks streaming. Verify enrollment and continued connection through that gateway.

Keep this management gateway separate from the Agent business pool. A Tiyi site pointing at `127.0.0.1:8080` is distributed to every node and refers to each node's own loopback; it cannot route the entire fleet's management traffic to the Controller. If a gateway shares the Controller host, assign distinct IPs/ports so it does not conflict with Tiyi listeners. Use a covering certificate and `auth.refresh_cookie_secure: true` for browser access.

Import the license under **System Administration → About**. In **Nodes → Install**, select the stable HTTPS URL, expiry and maximum nodes, then generate the systemd installation command. The equivalent command, run on the Controller host, is:

```sh
sudo tiyi agents install-command --controller-url https://control.example.com \
  --tag edge --ttl-seconds 3600 --max-nodes 2
```

Run the generated command on each of the two intended Agent hosts before expiry. It contains enrollment credentials; keep it private and omit installer query strings from gateway access logs. The generated script installs `tiyi-agent`; do not install another Controller service on those hosts. The download uses the Controller's own platform binary, so the generated workflow requires matching OS/architecture. For heterogeneous hosts, use the same version's correctly signed platform binary and the documented advanced installation path.

On the Controller, inspect `sudo tiyi agents list` and the Nodes page. Confirm each Agent's configuration was applied; online status alone is insufficient. Agents inherit the Controller's effective data-plane listener addresses, so reserve the same listener ports on every Agent.

<a id="site"></a>
## 3. Publish the application and choose TLS

Create an upstream pool and a site on the Controller, using an origin address reachable from **the Controller, its built-in node, and every remote Agent**. `127.0.0.1` means each individual host; use real private application addresses for shared origins. Save the site, enable the intended WAF policy, configure certificates, and verify each serving node's result before adding it to the LB.

Site saves distribute to the built-in node and all enrolled Agents. Groups/tags organize nodes; they do not restrict site deployment. A multi-region design must account for this origin reachability and shared site configuration.

| TLS topology | Use when | Requirements |
|---|---|---|
| Client HTTPS → L7 LB → verified HTTPS Agent | General-purpose starting point when the LB can terminate TLS | LB and Agent certificates, backend CA/name verification, preserved Host/SNI, verified forwarding headers |
| Client HTTPS → source-preserving L4 LB → Agent TLS | TLS termination must stay at Tiyi | Agent certificates, proven client source preservation, site-aware TLS/HTTP health checks |
| Client HTTPS → L7 LB → HTTP Agent | An explicitly accepted private-network boundary | Protect the unencrypted backend link and maintain client-IP/scheme forwarding |

An L4 LB that replaces client source addresses cannot inject `X-Forwarded-For` into encrypted requests. The v3.8.0 Tiyi configuration surface does not expose a PROXY-protocol listener; do not enable `send-proxy`/`send-proxy-v2` and assume it works. Prefer verified L7 forwarding or an actually source-preserving L4 service.

For Agent TLS, Tiyi's Controller issues/renews managed certificates and distributes them; Agents do not issue independently. DNS-01 avoids LB routing of HTTP challenges and supports wildcard issuance; v3.8.0 supports Cloudflare DNS-01, while Route53/Aliyun drivers are unavailable. Uploaded certificates are another option. With HTTP-01, keep public port 80 and `/.well-known/acme-challenge/` reaching the active Agent challenge handlers; remove disconnected nodes before issuance/renewal. Verify renewal through the actual LB. Certificate installation/renewal on an external TLS-terminating LB is a separate operator responsibility. See [TLS operations](operations.md#https) and [Let's Encrypt challenge types](https://letsencrypt.org/docs/challenge-types/).

<a id="load-balancer"></a>
## 4. Configure forwarding, client IP, and health checks

Preserve the business Host and backend SNI, request method/body, and required protocol features. Start with round-robin for similar short HTTP workloads; consider least-connections for long-lived workloads after measurement. Avoid broad retries of POST/payments/uploads that might already have reached an origin.

At the first trusted L7 edge, overwrite client-supplied forwarding headers with verified values. In **Protection → Client IP**, describe the actual proxy path and trust only the LB's real egress IPs using permanent IP-list entries. For CDN → LB → Tiyi, validate the CDN-to-LB hop too; replacing the header with the CDN peer address loses the visitor IP. Verify resolution on each Agent and test a forged header. See [client-IP setup](deployment.md#client-ip).

Use an application-owned, cheap `GET /_edge/ready` endpoint that returns 200 only when that application's required dependencies are ready. This is an example endpoint you must implement at the origin, **not a built-in Tiyi route**. Probe it through each Agent with the business Host and HTTPS SNI so TLS, routing, WAF admission, and origin connectivity participate. A successful probe does not establish every site's health or WAF blocking; separately test important sites and controlled attacks. Scope any Bot/auth exception to the probe endpoint and actual probe sources, without bypassing all WAF checks.

Do not use Controller `/healthz` as Agent readiness: it is management-process liveness. `/readyz` is on the local privileged admin socket, not a public Agent LB target. LB membership must not depend solely on Controller connectivity; an already configured Agent can keep serving during its outage.

### HAProxy starter for one business hostname

This example uses an L7 TLS-terminating LB with verified TLS to two Agents. Review it against your installed [HAProxy configuration manual](https://docs.haproxy.org/2.8/configuration.html). Install HAProxy through your OS's supported package/service procedure. Download the [complete starter](templates/haproxy-cluster.cfg) on the LB host:

```sh
curl -fsS https://www.tiyisec.com/docs/templates/haproxy-cluster.cfg \
  -o haproxy-cluster.cfg
```

Edit the hostname, Agent IPs/ports, CA file and frontend PEM path. Prepare `/etc/haproxy/certs/app.example.com.pem` with the LB certificate chain and private key, install a covering Agent certificate through Tiyi, and implement the probe endpoint first. The LB certificate file contains a private key; restrict its permissions. The download does not install certificates or create HA.

```text
global
    log /dev/log local0

defaults
    log global
    mode http
    option httplog
    timeout connect 5s
    timeout client 60s
    timeout server 60s
    timeout tunnel 1h

frontend public_http
    bind :80
    http-request redirect scheme https code 301

frontend public_https
    bind :443 ssl crt /etc/haproxy/certs/app.example.com.pem
    acl app_host hdr(host) -i app.example.com app.example.com:443
    http-request deny deny_status 421 unless app_host
    http-request del-header Forwarded
    http-request del-header X-Real-IP
    http-request set-header X-Forwarded-For %[src]
    http-request set-header X-Forwarded-Proto https
    http-request set-header X-Forwarded-Host %[req.hdr(Host)]
    default_backend tiyi_agents

backend tiyi_agents
    balance roundrobin
    option httpchk
    http-check connect ssl sni app.example.com
    http-check send meth GET uri /_edge/ready ver HTTP/1.1 hdr Host app.example.com
    http-check expect status 200
    default-server inter 3s fall 3 rise 2
    server agent_a 10.20.0.21:443 ssl verify required ca-file /etc/ssl/certs/ca-certificates.crt verifyhost app.example.com sni str(app.example.com) check
    server agent_b 10.20.0.22:443 ssl verify required ca-file /etc/ssl/certs/ca-certificates.crt verifyhost app.example.com sni str(app.example.com) check
```

This starter assumes visitors connect directly to the LB, one business hostname, and DNS-01 or uploaded certificates. Its port-80 redirect does **not** explicitly forward Tiyi HTTP-01 challenges; design that route before choosing HTTP-01. Expand per-host routing/probes for more sites and tune timeouts for actual uploads/streams. The failure/rise settings are starting values, not a detection-time guarantee. Tiyi's health checks for application upstreams are separate from these LB checks for Agents.

On the LB host, validate before installing. Preserve the current configuration if one exists, then install and reload during a reviewed traffic window:

```sh
sudo haproxy -c -f ./haproxy-cluster.cfg
sudo install -m 0644 haproxy-cluster.cfg /etc/haproxy/haproxy.cfg
sudo systemctl reload haproxy
```

Syntax validation must succeed. Check service status, both backends' probe results, and public requests. If activation fails, restore the saved configuration, validate and reload it. A new HAProxy service may need its initial start rather than reload. Apply equivalent configuration and test failover on both LB instances, or use a managed HA service.

<a id="acceptance"></a>
## 5. Verify every Agent, then switch business DNS

From an authorized probe host, replace the example address/domain and use valid certificates:

```sh
# Agent A directly, preserving both Host and TLS SNI: expected 200
curl --fail --resolve app.example.com:443:10.20.0.21 \
  https://app.example.com/_edge/ready

# Agent B directly: expected 200
curl --fail --resolve app.example.com:443:10.20.0.22 \
  https://app.example.com/_edge/ready

# Controlled WAF probe on Agent A: default blocking policy should return 403
curl -i --resolve app.example.com:443:10.20.0.21 --get \
  --data-urlencode 'q=1 UNION SELECT password FROM users' https://app.example.com/
```

Repeat the WAF probe on Agent B and the LB VIP before changing DNS; use a test site/path you own. Match expected responses to your actual policy and configured response status. Do not disable certificate verification with `-k` as acceptance. Verify real client IP and spoof protection through the LB, then move business DNS to its VIP and repeat the checks publicly. Confirm requests reach both Agents through node-tagged observations or LB backend counters; browser refreshes alone do not prove distribution.

Rehearse failure and recovery before calling the topology highly available:

| Rehearsal | Expected result |
|---|---|
| Drain one Agent, then stop its service | New requests use remaining healthy Agents; already broken connections may need client reconnect; remaining capacity meets the target |
| Restore that Agent | Correct version/configuration, real requests and probes pass before rejoining |
| Interrupt Controller connectivity in a controlled window | Already admitted Agents serve their last accepted configuration; management, new publication/enrollment and central freshness are unavailable |
| Fail the active LB | Managed-service/VIP failover restores new connections within the measured target; existing connections can break |
| Make an application origin fail | Origin-pool behavior and Agent probes reflect the intended application policy; no route bypasses WAF |

If all Agents are unhealthy, fail closed with an error; do not silently send traffic straight to unprotected origins.

<a id="operate"></a>
## 6. Maintain capacity, state, and recovery

- **Scale and upgrade:** enroll a node outside the LB pool, verify applied configuration and traffic, then admit it. To remove or update a node, drain it and wait for connections before stopping. Use rolling updates only for explicitly compatible state/protocol versions; the older-release → v3.8.0 transition requires [fresh state and re-enrollment](upgrade-migration.md), not an ordinary rolling update.
- **Stateful behavior:** rate windows and runtime temporary mitigation are node-local. A per-node limit is not one exact fleet-wide budget. Sticky routing may help application sessions or identity locality but does not create shared state. Test Bot clearance, reconnects, and application sessions across nodes; use an appropriate shared admission layer if the business requires an exact global limit.
- **Observation:** monitor every node's CPU/memory/disk, WAF outcomes, upstream health, bounded spool/backlog and coverage gaps, plus LB backend failures. A prolonged Controller outage can exhaust observation retention even while traffic continues. Configure SIEM connectivity from every producing node and monitor expiry/renewal before certificates run out.
- **Controller recovery:** define acceptable management RTO/RPO, take a consistent backup of complete state/config/KEK/license/certificates and matching binary, and rehearse [restore](upgrade-migration.md#restore). Retain the stable management URL. Fence/stop the old Controller before starting a restored copy; never run two writable copies of cloned state. Restoring an old backup can lag node identities or accepted configuration—check reconnect/reconciliation and recover deliberately.

The topology provides traffic-node redundancy only when the LB, origins, network and remaining capacity also meet the availability target. Controller recovery remains an operator procedure; Agents cannot perform certificate renewal or obtain new policy changes from an unavailable Controller.
