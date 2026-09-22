<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# menu.proto — Navigation menus for the admin UI

Schema: `tiyi.v1` · `menu.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### MenuService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListMenus`](#menuservicelistmenus) | unary | authenticated |

## RPCs

### MenuService.ListMenus

- **Procedure** `POST /tiyi.v1.MenuService/ListMenus`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.ListMenusRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ListMenusResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `menus` | `menus` | [`MenuRecord`](#menurecord) | repeated | — |

## Messages

### MenuMeta

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `title` | `title` | `string` | singular | — |
| `icon` | `icon` | `string` | singular | — |
| `order` | `order` | `int32` | singular | — |
| `hide_in_menu` | `hideInMenu` | `bool` | singular | — |
| `keep_alive` | `keepAlive` | `bool` | singular | — |
| `authority` | `authority` | `string` | repeated | — |

### MenuRecord

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `path` | `path` | `string` | singular | — |
| `component` | `component` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `redirect` | `redirect` | `string` | singular | — |
| `meta` | `meta` | [`MenuMeta`](#menumeta) | singular | — |
| `children` | `children` | [`MenuRecord`](#menurecord) | repeated | — |
