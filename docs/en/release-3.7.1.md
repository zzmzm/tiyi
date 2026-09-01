# Tiyi v3.7.1 release notes

Released 2026-09-01. v3.7.1 is a compatible hardening release on the v3.7
state contract.

## Highlights

- **Built-in Light for new sites:** newly created sites default to Light. CRS
  attack scoring, multipart validation, request-body ceilings, and
  argument/upload guards remain enforcing, while unlisted MIME types and
  JSON/XML parse failures become non-blocking compatibility observations.
  Connect RPC framing is handled as raw data.
- **Existing policy behavior is preserved:** existing site bindings are never
  migrated, and Standard retains its prior strict MIME/parser blocking
  behavior.
- **Operable IP-list relationships:** manual and subscription rows show a
  bounded action-and-target summary. **Manage applications** loads the complete
  relationship set, can stop ordinary access bindings without deleting shared
  content, and links rule/trust consumers to their owning configuration.
- **Safe private-network example:** fresh installations include one ordinary,
  editable manual list with RFC 1918 IPv4 ranges and IPv6 ULA `fc00::/7`. It is
  unbound, never trusted automatically, and can be edited or deleted.
- **Accurate sampling alerts:** per-client fairness shedding remains visible in
  pipeline diagnostics but no longer fires the global Observation Sampling
  Pressure alert. True global-budget and queue pressure still do.

## Upgrade

v3.7.0 installations can use the routine signed update flow:

```sh
sudo tiyi update --check
sudo tiyi update --yes                 # GitHub with Gitee fallback
sudo tiyi update --yes --mirror gitee # force Gitee
sudo systemctl restart tiyi
tiyi --version
sudo tiyi system health
```

The earlier clean-state boundary still applies when moving from v3.6.0 or
older state into the v3.7 line. Follow
[Upgrade and migration](upgrade-migration.md) before that transition.

Downloads, `SHA256SUMS`, its Ed25519 signature, and the release manifest are on
the [GitHub release](https://github.com/zzmzm/tiyi/releases/tag/v3.7.1) and the
[Gitee mirror](https://gitee.com/tiyisec/tiyi/releases/tag/v3.7.1).
