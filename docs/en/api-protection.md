# Discover, document, and protect APIs

For **v3.8.0**. In **Application Delivery → API Assets**, select a site to inspect observed endpoints,
import OpenAPI/Swagger, review request definitions, and choose off, observe, or enforce per endpoint.

| What you have | Start here | Result |
|---|---|---|
| An OpenAPI/Swagger file | Import an API document | Reviewable catalog, request definitions, and capability report |
| JSON traffic without a specification | Traffic learning | Saved structural versions and an OpenAPI draft to review |
| File-upload requirements | Site policy request inspection + endpoint request definition | Site capacity limits and endpoint file-field requirements |
| A question about actual enforcement | Endpoint validation, serving-node results, detection statistics | Deployment results and observed request outcomes |

Catalog membership, hiding a row, traffic learning, and validation mode are independent. Importing a document or adding an endpoint to the catalog does not automatically enable blocking.

## 1. Prepare a reproducible API

First create `quickstart.test` using the [quickstart](getting-started.md). Stop its static Python origin and run this API on the same host.
It accepts arbitrary small bodies, so you can verify that Tiyi performs validation. It is a local demo, not a production application.

```sh
cat > demo-origin.py <<'PY'
#!/usr/bin/env python3
"""Local documentation origin. Bind to loopback; do not expose as an app."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json

class Demo(BaseHTTPRequestHandler):
    def reply(self, status, data):
        body = json.dumps(data).encode()
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        self.reply(200, {'message': 'Hello from the origin'})

    def do_POST(self):
        size = int(self.headers.get('Content-Length', '0'))
        if size > 65536:
            self.reply(413, {'error': 'demo limit is 64 KiB'})
            return
        self.rfile.read(size)
        # Deliberately accepts any small body: Tiyi performs validation.
        self.reply(200, {'message': 'Order received'})

ThreadingHTTPServer(('127.0.0.1', 9000), Demo).serve_forever()
PY
python3 demo-origin.py
```

Leave it running, then send a valid request from another terminal:

```sh
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":2}' http://127.0.0.1/api/orders
```

Expect **200** and `Order received`. This real request also starts discovery of `POST /api/orders` in API Assets.
Download: [demo-origin.py](templates/demo-origin.py).

## 2. Copy an OpenAPI document

Paste the whole block to create the uploadable `orders-openapi.yaml`:

```sh
cat > orders-openapi.yaml <<'YAML'
openapi: 3.0.3
info:
  title: Orders API
  version: 1.0.0
servers:
  - url: http://quickstart.test
paths:
  /api/orders:
    post:
      operationId: createOrder
      summary: Create an order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [sku, quantity]
              properties:
                sku:
                  type: string
                quantity:
                  type: integer
            example:
              sku: BOOK-1
              quantity: 2
      responses:
        '200':
          description: Order received
YAML
```

Download: [orders-openapi.yaml](templates/orders-openapi.yaml). For your app, edit the server URL, path, method, fields, and required list.
The server URL has no `/api` prefix because the operation path already contains `/api/orders`; avoid doubling the prefix.

Import accepts OpenAPI **3.0 / 3.1 / 3.2** and Swagger **2.0** as JSON or YAML, up to **8 MiB**.
Upload a file rather than a URL; remote references are not fetched automatically. For a root mapping, send `basePath: ""`, not `/`.
Recognizing a document version does not mean every constraint is executable: read the capability report for unsupported checks.
Response definitions are documentation; do not treat them as enabled response-body validation or application authorization.

## 3. Review and publish in the console

**Wildcard sites:** `*.example.com` routes matching requests but is not a concrete API mapping. First add each actual API hostname, such as `api.example.com`, to the site as its primary host or an alias, then map that exact name. Neither wildcard routing nor a wildcard certificate enables Schema validation across all subdomains. See [wildcard hostname setup](operations.md#wildcard-hosts).

1. Open **Application Delivery → API Assets**, select `quickstart`, and import the file.
2. Confirm host `quickstart.test` with an empty base path (root). The preview should show `POST /api/orders`; fix duplicate `/api` prefixes or incorrect hosts before proceeding.
3. Review matches to existing endpoints, additions, and coverage. This document describes one demo endpoint; it is not a complete inventory of an unrelated application.
4. Apply the reviewed document. Open the endpoint's **Request definition**: `sku` should be a required string and `quantity` a required integer.
5. Choose **Observe** first, preview and apply. Check serving-node results; saved, queued, failed, and applied are different states.

Uploading, saving a draft, and previewing do not publish. If a constraint is unsupported, reduce the specification to supported checks and preview again; do not bypass capability checks and claim enforcement is active.

## 4. Observe, then verify blocking

Send an invalid type while observation is enabled:

```sh
curl -i -H 'Host: quickstart.test' -H 'Content-Type: application/json' \
  --data '{"sku":"BOOK-1","quantity":"two"}' http://127.0.0.1/api/orders
```

With this demo's Light policy and no extra rules, expect **200** with a recorded validation violation. Other WAF rules can still block independently.
Send the valid example too and confirm both map to the same endpoint. Statistics aggregate completed time buckets; allow refresh and keep the same site, endpoint, and time window.

After the capability report confirms support, switch this endpoint to **Enforce**, preview, apply, and wait for serving-node results.
The invalid request should now return **403** before reaching the demo origin, while the valid request stays 200.
Use the response and request detection/enforcement detail for the exact rejection reason.
If legitimate traffic is affected, restore Observe and republish, or restore a reviewed version from publication history, then repeat both probes.

The undeclared-endpoint allow/observe/block policy is separate and limited to published document coverage.
Keep it at allow when first importing a partial specification; review health checks, callbacks, static paths, and older legitimate clients before restricting it.

## 5. Learn from JSON when no document exists

Open **Traffic learning** for eligible POST/PUT/PATCH endpoints and send successful legitimate JSON requests through Tiyi.
Learning retains bounded field structures, types, and counts without field values. Review saved versions, save the current version for review,
download an OpenAPI draft, or create an editable request definition. Continue through the same review, preview, and publication steps.
Learning does not overwrite manual definitions or turn on enforcement. Check the displayed state for insufficient samples, error responses, unmatched traffic, or paused learning.
Field names can themselves be sensitive; pause collection or clear learning records when needed.

## 6. Uploads and request size

Use the site's policy **Request inspection** settings for ordinary body size, per-file size, total uploads, parameter counts, and structural limits.
Use the endpoint **Request definition** for allowed file fields and supported type/count requirements.
Test valid files, oversized files, wrong fields, and cancellation; inspect both the actual response and whether the origin received the request.
Structural upload checks do not scan for malware or moderate content. Use a dedicated application service for those needs.

## 7. CLI and API automation

These commands require `jq`. Upload creates a draft and preview leaves live request handling unchanged:

```sh
sudo tiyi site list
SITE_ID='replace-with-quickstart-site-id'
sudo tiyi api-document upload --site "$SITE_ID" --file orders-openapi.yaml \
  --idempotency-key orders-v1 > source-result.json
jq '{siteId: .source.siteId, sourceId: .source.id,
     mappings: [{host:"quickstart.test",basePath:"",
                 serverUrl:"http://quickstart.test",approved:true}]}' \
  source-result.json > declaration-preview.json
sudo tiyi api-document declaration-preview -f declaration-preview.json > preview-result.json
jq -r '.reportJson' preview-result.json | base64 -d
```

Other `api-document` commands accept `--request-file FILE` (`-f -` for strict protobuf JSON on stdin).
Bytes fields such as `reportJson` are base64 in JSON; decode them before parsing the enclosed report.
For publication, review and stage the declaration, prepare validation profiles/bindings, preview control, and submit the returned approval.
See the [API workflow](api.md#api-documents) and [full ApiSchemaService definition](../reference/services/api_schema.md) for order, fields, and permissions.
Never invent hashes or revisions or reuse an outdated preview. A successful call still needs serving-node and real-request verification.
