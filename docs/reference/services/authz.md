<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# authz.proto — authz

Schema: `tiyi.v1` · `authz.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Messages

### AuthorizationRule

AuthorizationRule is the single source of truth for one RPC's transport authorization. An option must be present on every method: public=true no bearer token is required empty rule authenticated user, scoped to their own session any_permission at least one listed code is required all_permission every listed code is required When both any_permission and all_permission are populated, both conditions must pass. The reserved tiyi:superadmin code satisfies every condition.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `public` | `public` | `bool` | singular | — |
| `any_permission` | `anyPermission` | `string` | repeated | — |
| `all_permission` | `allPermission` | `string` | repeated | — |
