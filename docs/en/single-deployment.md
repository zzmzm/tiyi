# Single-server deployment: the simplest way to use Tiyi

For **v3.8.0**, reviewed **2026-09-30**. Start with one Tiyi server unless you already need multiple traffic nodes or host-failure tolerance. One `tiyi run` process contains the Controller, console, and built-in Agent/data plane. Installation starts them together; no separate Agent enrollment or remote-node license is needed.

```text
Visitors ── HTTP/HTTPS ──> Tiyi server ──> Application origins
                          ├─ Controller + console
                          └─ Built-in Agent: TLS, proxy, WAF
Administrators ─────────> Management console / local CLI
```

This is the recommended quickstart and a practical deployment for small workloads that can accept a maintenance window. The server is a single failure domain: a host or process outage interrupts both traffic and management. When that becomes unacceptable, follow [cluster deployment](cluster-deployment.md).

<a id="install"></a>
## 1. Install on a fresh Linux host

Use Linux amd64/arm64, persistent disk, sudo, systemd, and an application reachable from this host. Reserve website ports **80/443** and management port **8080**. If these ports are already occupied, use [custom ports](getting-started.md#custom-ports) or the [existing Nginx integration guide](https://www.tiyisec.com/docs/existing-site.html).

Run on the Tiyi host. Pin the version used by this guide:

```sh
curl -fsSL https://www.tiyisec.com/install.sh | TIYI_VERSION=v3.8.0 bash
sudo tiyi install --now
tiyi --version
sudo tiyi system health
```

The installer verifies the signed binary; `install --now` creates, enables, and starts the systemd service. Save the one-time administrator password shown in the terminal. The version should be v3.8.0 and health should report a working instance. HTTPS starts after a TLS site and certificate are configured.

For an existing installation, use [upgrade and migration](upgrade-migration.md). Offline and foreground alternatives are in [Installation](installation.md).

<a id="first-site"></a>
## 2. Sign in and connect your first site

From your browser, open `http://SERVER_IP:8080`, replacing `SERVER_IP` with this host's actual address. Sign in as **admin**, then change the initial password. Restrict initial management access to your administration network.

For a short local rehearsal, run this in a second terminal on the Tiyi host:

```sh
mkdir -p "$HOME/tiyi-demo"
printf 'Hello from the origin\n' > "$HOME/tiyi-demo/index.html"
python3 -m http.server 9000 --bind 127.0.0.1 --directory "$HOME/tiyi-demo"
```

Leave that terminal open. In another terminal on the same host:

```sh
sudo tiyi site create --name quickstart --host quickstart.test \
  --upstream-url http://127.0.0.1:9000 --tls none
```

The site uses the built-in Light WAF policy. `quickstart.test` needs no DNS change for the following checks. For a real application, use **Application Delivery → Sites → Create**, enter its domain and a reachable origin, and configure HTTPS using [certificate operations](operations.md#https). An origin URL must point to the application, not back to the site's public Tiyi address.

<a id="verify"></a>
## 3. Verify traffic and protection

Run on the Tiyi host against the rehearsal site:

```sh
# Normal request: 200 and Hello from the origin
curl -i -H 'Host: quickstart.test' http://127.0.0.1/

# Controlled SQL injection probe: 403 with the default blocking policy
curl -i --get -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/

# Normal traffic must still work
curl -i -H 'Host: quickstart.test' http://127.0.0.1/
```

Inspect Overview and **Logs → Attack Logs**, using the response's `X-Request-Id` when available. A saved site or healthy process alone does not prove requests reach the origin or that the WAF blocks. If results differ, use [Troubleshooting](troubleshooting.md).

Delete the `quickstart` site and stop the Python terminal when finished. Keep Tiyi running to connect your own application.

<a id="production"></a>
## 4. Prepare the single server for production

- Configure the business domain, certificate, and HTTPS before moving public DNS. Keep the origin private and allow application ingress from Tiyi. Test login, callbacks, WebSockets, uploads, and ordinary requests with your actual application.
- Give the console a dedicated HTTPS management URL, set `auth.refresh_cookie_secure: true`, and restrict management ingress to administrators. Preserve SSH/local CLI recovery. A separate HTTPS gateway avoids depending on a business site's health for console access; see [management access](deployment.md#management).
- Use persistent disk for `/var/lib/tiyi`, retain the KEK and configuration, and set realistic log/evidence quotas. Monitor disk, CPU, memory, origin failures, certificate expiry, and observation delivery. Use the [metrics-only setup](operations.md#prometheus).
- If a CDN or proxy precedes Tiyi, configure [verified client-IP extraction](deployment.md#client-ip), restrict direct ingress, and verify spoofed forwarding headers cannot replace the real client address.
- Start with the default policy and review false positives against real traffic. Detailed evidence may be sampled or expire; HTTP outcomes and exact counters serve different purposes.
- Take a consistent [backup](upgrade-migration.md#backup) and rehearse same-version restoration. Schedule a traffic interruption for cold backup, restart, or incompatible upgrade. A site export alone does not preserve the installation.

Measure capacity with your rules, TLS, payloads, and retained evidence. This guide sets no universal CPU/RAM or QPS promise.

<a id="grow"></a>
## 5. Grow when the workload requires it

An existing CDN/LB can front a single Tiyi node, but one node still has one host failure domain. For node redundancy or more capacity, enroll remote Agents and put their traffic listeners behind an external HA load balancer. Keep a single writable Controller and plan its recovery separately.

Follow [Cluster deployment: one Controller, multiple Agents, and a load balancer](cluster-deployment.md) for enrollment, TLS, health checks, client-IP trust, rolling maintenance, and failover acceptance.
