# Tiyi v3.7.2 release notes

Released 2026-09-03. v3.7.2 is a compatible operations patch on the v3.7
state contract.

## Highlights

- **Protection chain on Overview:** one unfiltered Enforcement summary folds
  all eight sources into the five stages a request actually traverses — Bot
  gate → rate/challenge → IP/country → resource guards → WAF/CRS → origin.
  Each stage reports configuration posture, decisions, fault-first reasons,
  and an action split. The Bot stage opens **Logs → Bot Analytics**; other
  stages open **Logs → Enforcement** already filtered. KPI totals use the
  proven contract `terminated = blocked/rejected/banned + challenged`.
- **Bot Analytics:** **Logs → Bot Analytics** records fixed-cardinality
  admission outcomes from the Observation V2 counter plane: path and
  trusted-IP exemptions, Clearance hits, challenge issue/pass/fail,
  unsupported clients, and internal failures. Successful admission is not an
  Enforcement decision. The page does not claim identified bots or a visitor
  pass rate.
- **Readable Request Evidence:** the in-console preview starts with method,
  exact request target, and client HTTP version, then Host and captured
  headers. Client IPs can show an advisory network-region tag when GeoIP data
  is installed.
- **SecLang quoting:** path-scoped CRS exclusions, rule-target updates, and
  visual-rule regex now reach Coraza unchanged, so authored `\.` / `\d`
  escapes are no longer double-escaped.

## Upgrade

v3.7.1 and v3.7.0 installations can use the routine signed update flow:

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
the [GitHub release](https://github.com/zzmzm/tiyi/releases/tag/v3.7.2) and the
[Gitee mirror](https://gitee.com/tiyisec/tiyi/releases/tag/v3.7.2).
