# Tiyi documentation

Tiyi combines reverse proxying, HTTPS, Web/API protection, and a management console in one executable. These docs start with your first run, then show you how to connect an application, inspect protection results, and move on to production deployment and daily operations.

## Start here

If you've never run Tiyi before, follow [Quickstart](getting-started.md). Install, sign in, create one site, and watch the WAF block real attacks. Then continue with [Practice and advanced use](practice.md), or connect your own application with the [Operations guide](operations.md).

On a fresh Linux host, install and start the system service with the default ports:

```sh
curl -fsSL https://www.tiyisec.com/install.sh | bash && sudo tiyi install --now
```

Websites use 80/443 and the management console uses 8080. The first password appears in your terminal; HTTPS needs a site and certificate.
Quickstart also covers [manual steps](getting-started.md#manual), [custom ports](getting-started.md#custom-ports), and [offline installation](getting-started.md#offline).
For an existing installation, read [upgrade and migration](upgrade-migration.md) first.

## Guides

- [Installation](installation.md): install and verify release packages, manage the service, and choose how to run Tiyi.
- [Configuration and templates](configuration.md): complete startup and site YAML, with commands to write, apply, and verify it.
- [Site import and export](site-import.md): connect or move sites using files, with conflict and certificate handling.
- [API and upload protection](api-protection.md): import OpenAPI, learn JSON structures, and verify validation with real requests.
- [Protection responses](responses.md): customize block pages, status codes, and API error formats.
- [How it works](concepts.md): understand how sites, origins, certificates, policies, and nodes fit together.
- [CLI](cli.md) and [API](api.md): start automating with authentication and request examples; you can also [install the AI operator skill](../../README.md#ai-agent-skill).
- [Deployment](deployment.md) and [backup and recovery](upgrade-migration.md#backup): prepare for production, connect monitoring, expand to remote nodes, and practice restoration.
- [Troubleshooting](troubleshooting.md): find your next check for startup, login, routing, TLS, or protection problems.

## Templates and full reference

[Startup tiyi.yaml](templates/tiyi.yaml) · [Minimal site YAML](templates/first-site.yaml) · [Four-kind YAML](templates/apply.yaml) ·
[Site import JSON](templates/site-import.json) · [OpenAPI YAML](templates/orders-openapi.yaml) · [Local demo API](templates/demo-origin.py) ·
[Protection response JSON](templates/security-responses.json).

[All RPCs](../reference/rpc-index.md) · [Permissions](../reference/permissions.md) · [All CLI flags](../reference/cli-options.md).

**Upgrading an existing installation to v3.8.0 requires backup, fresh state, and re-enrollment of all remote Agents.**
Read the [v3.8.0 notes](release-3.8.0.md) and [migration procedure](upgrade-migration.md) before replacing the binary and restarting.
History: [v3.7.2](release-3.7.2.md) · [v3.7.1](release-3.7.1.md) · [v3.7.0](release-3.7.0.md).
