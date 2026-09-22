# Practice and advanced use

In [Quickstart](getting-started.md), we let normal requests through and blocked attacks. Now keep using that demo: switch between observe and block, investigate rules, then try API protection, a real application, automation, and daily operations.

The first two exercises reuse your own `quickstart.test` site and origin on port 9000; leave the origin running. Run commands on the Tiyi host with `sudo` for the default service. If you changed port 80, use your proxy port below; a custom instance also needs `--admin-socket`.

<a id="observe-block"></a>
## 1. Observe and block the same request

Use your own demo site. Find the `quickstart` ID, then change **that site's** WAF mode:

```sh
sudo tiyi site list
SITE_ID='replace-with-quickstart-site-id'
sudo tiyi site update "$SITE_ID" --waf-mode detection
curl -i --get -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/
sudo tiyi site update "$SITE_ID" --waf-mode blocking
curl -i --get -H 'Host: quickstart.test' \
  --data-urlencode 'q=1 UNION SELECT password FROM users' http://127.0.0.1/
curl -i -H 'Host: quickstart.test' http://127.0.0.1/
```

With the unchanged quickstart configuration, expect **200, 403, 200**. Inspect outcomes in Overview and find the matching rules in Attack Logs by request ID.
`detection` changes this site's WAF behavior; Bot, rate, IP, and API definition controls can still block independently. It is not a global observation switch for every protection.
If you stop midway, run the `--waf-mode blocking` command above to restore the demo site.

<a id="tune"></a>
## 2. Start tuning from an actual request

Record the site, time, request ID, rule ID, matched field, and response status from Attack Logs. Confirm the request reached the intended site and determine whether it represents legitimate business input.

To simulate a request without sending it to the origin, use the policy test page or obtain the site's actual policy ID and run:

```sh
sudo tiyi site get "$SITE_ID"
sudo tiyi policy list
POLICY_ID='replace-with-this-sites-policy-id'
sudo tiyi policy test "$POLICY_ID" --site-id "$SITE_ID" \
  --method GET --url '/?q=1%20UNION%20SELECT%20password%20FROM%20users'
```

Inspect executed stages, matched rules, and the blocking outcome. Policy testing covers native IP/country rules and Coraza request inspection.
It does not execute the full proxy path, Bot, rate limits, upload/Schema guards, or response inspection. Follow it with real request checks.

To practice a precise rule, use a separate policy for your demo site. In the **Custom rules** visual editor, block requests whose path equals `/lab-denied`.
Preview, save, and wait for application, then request `/lab-denied` and `/`: the former should be rejected while the latter still works.
Delete the exercise rule or restore the original policy afterwards and confirm `/lab-denied` works again. Review all consumers before changing a shared policy.

For a real false positive, use the narrowest supported exception for the site, path, parameter, and rule, then replay the legitimate request and this guide's SQL injection probe.
`log_only` removes that rule's blocking-score contribution; other rules may still block. A global client allowlist broadens access beyond the affected request.
Retain the previous policy version. If results are wrong, roll back through policy history, check referenced dependencies, and repeat real probes.

<a id="api"></a>
## 3. Accept valid API structure and reject invalid input

Follow [API protection](api-protection.md) to replace the static origin with the demo order API, import `orders-openapi.yaml`, and publish Observe mode first.
Uploading a document alone does not enable validation. Review the capability report and endpoint scope, wait for serving-node results, then test:

```sh
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":2}' http://127.0.0.1/api/orders
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":"two"}' http://127.0.0.1/api/orders
```

In the demo's Observe mode both return 200, with a type violation for the second. After publishing Enforce, expect 200 and 403 respectively.
Check detection statistics for the same site, endpoint, time window, and coverage. Restore Observe and republish if legitimate clients are affected.

Without a specification, send successful legitimate JSON through an eligible POST/PUT/PATCH endpoint. Review field names and types in **Traffic learning**, save a version, and export a draft.
Complete the real field and requiredness requirements before previewing and applying it. Learning never enables enforcement automatically.
For uploads, test valid files, wrong fields, wrong types, and oversized files. Site policies set capacity; endpoint definitions set file-field requirements.

<a id="publish"></a>
## 4. Move from the demo to a real application

Prepare a real domain, Tiyi ingress IP, origins reachable by every serving node, and a covering certificate. Follow [HTTPS and path routing](operations.md#https).
Use `curl --resolve` to direct the domain to a candidate node while keeping certificate verification enabled:

```sh
# Replace the domain and IP with your real values
curl -i --resolve app.example.com:443:192.0.2.10 https://app.example.com/
```

`192.0.2.10` is a documentation address. HTTP-01 issuance requires public DNS and port 80 to reach the challenge-serving ingress during validation.
To prepare a certificate before moving application DNS, use an existing certificate or supported DNS-01.

Test login, search, payment callbacks, uploads, WebSockets/long-lived connections if used, every path route, and unmatched paths.
Configure client-IP trust first when behind a CDN. Check each node separately. Keep the old ingress and configuration until the new path is verified.
Use your original traffic-routing mechanism to return to the old ingress if needed; DNS rollback still depends on caches and TTLs.

<a id="automation"></a>
## 5. Make repeatable changes reviewable

Start with the [minimal site YAML](configuration.md#apply). It creates a separate example site and does not replace `quickstart`.

```sh
sudo tiyi diff -f first-site.yaml
sudo tiyi apply -f first-site.yaml --dry-run
sudo tiyi apply -f first-site.yaml
curl -i -H 'Host: app.example.com' http://127.0.0.1/
sudo tiyi audit verify
```

Run `diff` again and check for unexpected remaining differences. `apply` replaces its managed fields; removing a resource from a file does not delete the online resource.
Retain the prior manifest when updating existing resources and preview rollback too. At the end of a demo, explicitly delete the new site and any newly unused upstream.
Site export is for moving sites, not full recovery. Preserve [complete state and configuration](upgrade-migration.md) for installation backups.

For remote scripts, obtain a properly scoped token through [API authentication](api.md#authentication). CLI login does not persist a session for later commands.
Paginate complete lists, retain server-returned revisions, and reread/review after conflicts. Do not hard-code resource IDs or skip publication results.

<a id="operate"></a>
## 6. Establish a daily operating routine

Start with three outcomes you can verify:

1. Configure an on-call destination in [notification channels](operations.md#notifications), send a test, and confirm actual receipt. Then bind a useful alert rule. Testing sends a real message.
2. Make a [complete backup](upgrade-migration.md) and rehearse restoration on an isolated host with a matching version. Verify login, sites, certificates, and requests.
3. Check `sudo tiyi system health`, certificate expiry, disk, node application results, and the log pipeline. Use the [Prometheus guide](operations.md#prometheus) for external monitoring.

Add [remote nodes](deployment.md#nodes) when you need more ingress points. Community includes full local functionality; remote nodes require licensed capacity.
An online node still needs configuration, origin reachability, and real request verification.
Expand one control at a time: IP/country, rate limits, Bot, uploads, or API validation. Record a legitimate probe, an invalid probe, the outcome, and how to undo each change.
