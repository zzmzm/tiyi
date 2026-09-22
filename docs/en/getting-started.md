# Quickstart

Go from a clean Linux host to Tiyi blocking real attacks in a few minutes. We'll install Tiyi, open the console, create one site, and send a few requests to see the WAF at work.

<a id="prerequisites"></a>

## Before you start

- A **Linux amd64 or arm64** host. The default installation uses sudo and systemd.
- **curl, tar, sha256sum**, and access to the release downloads for online installation.
- An HTTP application Tiyi can reach. If you don't have one ready, the example below starts a demo origin with Python 3.

This guide uses **80 / 443** for websites and **8080** for management. For [manual steps](#manual), [custom ports](#custom-ports), or [offline installation](#offline), jump to the relevant section.

> **Already running Tiyi?** Read [upgrade and migration](upgrade-migration.md) first. The installation commands below are for a fresh host.

<a id="install"></a>
<a id="one-line"></a>

## 1. Install and start Tiyi

Run on the Tiyi host:

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

The first part downloads and verifies the latest stable binary and installs it in `/usr/local/bin`. The second installs the systemd service, starts it, and enables it at boot.
Websites use **80 / 443** and the console uses **8080** by default. HTTPS becomes available after you configure a TLS site and certificate; no listener on 443 yet is normal.

On first installation, this terminal shows the login details. Use the password from your actual output:

```text
Tiyi administrator created
  username:  admin
  password:  <your-generated-one-time-password>
```

Check the installed version and running instance:

```sh
tiyi --version
sudo tiyi system health
```

If startup fails, run `sudo journalctl -u tiyi -n 100 --no-pager` and follow [troubleshooting](troubleshooting.md). For hosts without systemd, see [foreground mode](installation.md#foreground).

<a id="run"></a>
<a id="login"></a>

## 2. Open the console

Open `http://SERVER_IP:8080` in your browser, replacing `SERVER_IP` with the IP address of the host running Tiyi.
Tiyi listens on `0.0.0.0:8080` by default. Sign in with **admin** and the password printed during installation; you'll reach Overview, where you can watch traffic and protection results.

If the page does not open, check that the service is running and that port 8080 is reachable through the server firewall or cloud security group.

> **The first password is shown once.** Change it after signing in. If you lose it, [reset it through the local CLI](troubleshooting.md#reset-password) on the Tiyi host; you don't need to delete the database.

<a id="upstream"></a>

## 3. Start an origin

Open another terminal on the Tiyi host and start a small HTTP server:

```sh
mkdir -p "$HOME/tiyi-demo"
printf 'Hello from the origin\n' > "$HOME/tiyi-demo/index.html"
python3 -m http.server 9000 --bind 127.0.0.1 --directory "$HOME/tiyi-demo"
```

Leave it running. If you already have an application, use its origin address instead: replace `http://127.0.0.1:9000` in the next step with a URL the Tiyi host can reach.
The demo origin listens only on loopback, so you don't need to open port 9000 to visitors.

<a id="site"></a>

## 4. Create your first site

Return to another terminal on the Tiyi host. The CLI connects to the system service through the local admin channel, without a separate login or token:

```sh
sudo tiyi site create --name quickstart --host quickstart.test \
  --upstream-url http://127.0.0.1:9000 --tls none
```

The site becomes active immediately and uses the built-in **Light** WAF policy by default. You can also use **Application Delivery → Sites → Create** in the console: enter the same name, domain, and origin, disable TLS, keep WAF and the Light policy enabled, then save. Choose either the CLI or the UI to create the site.

`quickstart.test` is just the demo domain. The requests below supply it directly, so no DNS change is needed. Configure a certificate and HTTPS when you move to a real domain.

Both the primary host and aliases accept `*.example.com` for one subdomain level, such as `api.example.com`. It does not match `example.com` or `a.b.example.com`; add the root domain separately if needed. See [wildcard setup, certificates, and API bindings](operations.md#wildcard-hosts).

<a id="verify"></a>

## 5. Watch the WAF block attacks

On the Tiyi host, send a normal request followed by three common attacks against your new demo site. Each command prints only the HTTP status code; comments show the expected result:

```sh
# Normal request → 200
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H 'Host: quickstart.test' http://127.0.0.1/

# SQL injection → 403
curl -sS -o /dev/null -w '%{http_code}\n' --get \
  -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/

# XSS → 403
curl -sS -o /dev/null -w '%{http_code}\n' --get \
  -H 'Host: quickstart.test' \
  --data-urlencode 'q=<script>alert(1)</script>' http://127.0.0.1/

# Path traversal → 403; --path-as-is stops curl normalizing the path first
curl -sS -o /dev/null -w '%{http_code}\n' --path-as-is \
  -H 'Host: quickstart.test' http://127.0.0.1/../../../../etc/passwd
```

Send the normal request once more; it should still return **200**. To see the body and headers, replace `-sS -o /dev/null -w '%{http_code}\n'` with `-i`. A normal response shows `Hello from the origin`; an attack response includes an `X-Request-Id` you can use to find the matching log.

Back in the console, check traffic and outcomes in Overview and matched rules in **Logs → Attack Logs**. Detail retention and visibility depend on your logging and sampling settings; confirm blocking from the actual HTTP response first.
If you get 502, check that the origin is still running. If an attack passes, check the site's WAF switch, policy mode, and exceptions; see [troubleshooting](troubleshooting.md).

<a id="alternatives"></a>

## Other installation methods

Choose one of these instead of the one-line installation in step 1. Once the service is running, continue with [Open the console](#login).

<a id="manual"></a>

### Install in separate steps

To inspect the script, install the binary, and start the service separately:

```sh
curl -fsSL https://www.tiyisec.com/install.sh -o /tmp/tiyi-install.sh
less /tmp/tiyi-install.sh
bash /tmp/tiyi-install.sh
tiyi --version
sudo tiyi doctor
sudo tiyi install --now
```

Press `q` to leave less, or use `cat` if less is unavailable. Running the script only installs the binary; the final line starts the service and prints the first password.
To pin a version, replace the script execution with `TIYI_VERSION=vX.Y.Z bash /tmp/tiyi-install.sh`, using a published release tag.
See [installation](installation.md#prebuilt) for install directories, the Gitee mirror, and verification details.

<a id="custom-ports"></a>

### Choose your own ports

If another service already uses 80, 443, or 8080, write the configuration before starting Tiyi. For a fresh installation, this example selects **8081** for management and **8180 / 18443** for websites:

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash
sudo tiyi install
sudo install -d -m 0750 -o root -g tiyi /etc/tiyi
sudo tee /etc/tiyi/tiyi.yaml >/dev/null <<'YAML'
server:
  addr: "0.0.0.0:8081"
proxy:
  http_addr: ":8180"
  https_addr: ":18443"
YAML
sudo chown root:tiyi /etc/tiyi/tiyi.yaml
sudo chmod 0640 /etc/tiyi/tiyi.yaml
sudo tiyi install --now
```

Without `--now`, `install` prepares the system service without starting it. Once started, open `http://SERVER_IP:8081` in your browser, using the Tiyi host's IP address.
Change the later test URLs to `http://127.0.0.1:8180/`; the demo origin stays on 9000.
If you already have a configuration, preserve its other fields and edit only the listeners you need; see [ports and configuration](configuration.md#ports).

<a id="offline"></a>

### Install offline

On a connected computer, download the release archive matching the target host's architecture, its `SHA256SUMS` and `SHA256SUMS.sig`, and the official `release-key.pub`. Transfer all four files to the offline host.
Follow the [complete offline procedure](installation.md#offline) to verify the signature and checksum before extraction and installation. The offline host doesn't need to run the online `install.sh`.

After installing the binary and offline configuration, start the system service with the same command:

```sh
sudo tiyi install --now
```

For custom ports, write the YAML above before starting. The embedded WAF rules work offline. Use uploaded certificates for HTTPS; public certificate issuance and external subscriptions need their own network access.

<a id="next"></a>

## What to read next

- [Practice and advanced use](practice.md): keep using this demo site to explore observe/block modes, rule tuning, API validation, and automation.
- [Operations](operations.md): connect a real domain and HTTPS, then configure origins, routes, and alerts.
- [Configuration and templates](configuration.md): copy startup and site YAML; you can also [import and export existing sites](site-import.md).
- [How it works](concepts.md) and the [CLI reference](cli.md): understand sites and policies, then find more commands.

When you're done, delete `quickstart` from the Sites page and press Ctrl+C in the demo origin terminal. Keep Tiyi running to connect your own application next.
