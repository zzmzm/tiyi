# How Tiyi protects your application

Start with the request path, then configure the features your application needs.

## What happens to a request

The client connects to Tiyi on 80/443 → the Host selects a site → the path selects an upstream → enabled protections run → accepted traffic reaches the origin.
Protection stages include Bot admission, rate/challenge controls, IP/country access, resource limits, and WAF/CRS. API request definitions can add structural validation.
A request terminated by a protection stage does not continue to the origin. Normal traffic should retain the application's response.

## What to configure

| What you want to change | Where to set it |
|---|---|
| Domain, TLS, default origin, path routing | Application Delivery → Sites |
| Backends, probes, request headers, retries | Application Delivery → Upstream Pools |
| Certificates and renewal | Application Delivery → Certificates / DNS Providers |
| WAF strength, exceptions, custom rules, body/upload capacity | Protection policies attached to sites |
| API catalog, parameter/body definitions, validation modes | Application Delivery → API Assets |
| Reusable IP ranges and subscriptions | Protection → IP Lists, then bind an action |
| Client addresses behind a proxy | Client-IP trust settings |
| What people and automation may do | System Administration → Users / Roles / Authentication |

Startup `tiyi.yaml` sets listeners and storage. Application resources live in state and change through UI/CLI/API, not that startup file.
Socket paths, UUIDs, and revisions matter for automation and diagnosis; routine work starts with site names, current status, and next actions.

## How to know a change is active

Saving means Tiyi accepted the input. Publication results identify nodes that accepted or rejected it. Real requests verify final behavior.
For several nodes, check every target: success on the local node does not verify remote nodes.
Overview counters describe volume and trends; security events and attack logs support investigation; optional request evidence retains further details.
Sampling, retention, and node gaps can make details fewer than counters. An empty view is not proof that no attack occurred.

## Boundaries

WAF does not replace application fixes or business authorization. Schema checks do not prove business semantics; learned JSON drafts need review; Bot challenges verify visitors.
Community includes all local-node features; remote nodes consume licensed capacity. Each deployment has one writable Controller without built-in control-plane HA.
Public installation supports Linux amd64/arm64. Offline operation can use local rules and state; external ACME, subscriptions, notifications, and AI still need their respective connections.
