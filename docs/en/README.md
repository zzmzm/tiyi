# Tiyi documentation

Tiyi is a single-binary application gateway: Caddy terminates and proxies the
request, Coraza and OWASP CRS inspect it, and the embedded control plane records
the result. Use the path that matches the job in front of you.

## Choose a path

| Goal | Start here |
|---|---|
| Install one node and block a test attack | [Getting started](getting-started.md) |
| Publish sites, tune WAF, investigate traffic, and operate agents | [Operations](operations.md) |
| Diagnose startup, routing, TLS, WAF, login, agent, or telemetry problems | [Troubleshooting](troubleshooting.md) |
| Move a development/test installation to v3.2 | [v3.2 state reset](upgrade-v3.2.md) |
| Browse the full CLI, API, deployment, and concepts reference | [tiyisec.com/docs](https://www.tiyisec.com/docs/) |

## The request path

```text
client -> listener/TLS -> site + path route -> WAF policy -> upstream
                              |                    |
                              +-> access facts     +-> findings/incidents
                                                     -> campaigns/alerts/SIEM
```

Start investigations with a site, time range, and `X-Request-Id`. Tiyi keeps
exact hot-path counters separate from retained evidence and export delivery, so
an unavailable SIEM or a slow analytical worker cannot hold up proxy traffic.

## Supported operator interfaces

- **Web UI** for guided workflows and visual investigation.
- **Local CLI** over the root-owned admin Unix socket; no JWT is required on the
  same host when socket permissions allow access.
- **Remote CLI/API** over ConnectRPC with `--api` and `--token`.
- **Declarative apply** with `tiyi diff -f FILE` and `tiyi apply -f FILE`.

Run `tiyi <command> --help` for the exact flags supported by your installed
binary. If a reference and the binary disagree, the binary is authoritative.

