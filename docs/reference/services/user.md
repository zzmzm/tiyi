<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# user.proto — Users, roles, and permissions

Schema: `tiyi.v1` · `user.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### UserService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListUsers`](#userservicelistusers) | unary | (`user:read`) |
| [`GetUser`](#userservicegetuser) | unary | (`user:read`) |
| [`CreateUser`](#userservicecreateuser) | unary | (`user:write`) |
| [`UpdateUser`](#userserviceupdateuser) | unary | (`user:write`) |
| [`DeleteUser`](#userservicedeleteuser) | unary | (`user:delete`) |
| [`AssignRoles`](#userserviceassignroles) | unary | (`user:write`) |
| [`ResetPassword`](#userserviceresetpassword) | unary | (`user:write`) |
| [`LockUser`](#userservicelockuser) | unary | (`user:write`) |
| [`UnlockUser`](#userserviceunlockuser) | unary | (`user:write`) |
| [`ResetUserMFA`](#userserviceresetusermfa) | unary | (`user:write`) |

### RoleService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListRoles`](#roleservicelistroles) | unary | (`role:read`) |
| [`GetRole`](#roleservicegetrole) | unary | (`role:read`) |
| [`CreateRole`](#roleservicecreaterole) | unary | (`role:write`) |
| [`UpdateRole`](#roleserviceupdaterole) | unary | (`role:write`) |
| [`DeleteRole`](#roleservicedeleterole) | unary | (`role:delete`) |
| [`ListPermissions`](#roleservicelistpermissions) | unary | (`role:read`) |

## RPCs

### UserService.ListUsers

- **Procedure** `POST /tiyi.v1.UserService/ListUsers`
- **Kind** unary
- **Auth** (`user:read`)

**Request** — `tiyi.v1.ListUsersRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |
| `role_id` | `roleId` | `string` | singular | — |
| `locked` | `locked` | `bool` | optional (explicit) | — |

**Response** — `tiyi.v1.ListUsersResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`User`](#user) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### UserService.GetUser

- **Procedure** `POST /tiyi.v1.UserService/GetUser`
- **Kind** unary
- **Auth** (`user:read`)

**Request** — `tiyi.v1.GetUserRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetUserResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |

### UserService.CreateUser

- **Procedure** `POST /tiyi.v1.UserService/CreateUser`
- **Kind** unary
- **Auth** (`user:write`)

**Request** — `tiyi.v1.CreateUserRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |
| `password` | `password` | `string` | singular | — |

**Response** — `tiyi.v1.CreateUserResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |

### UserService.UpdateUser

- **Procedure** `POST /tiyi.v1.UserService/UpdateUser`
- **Kind** unary
- **Auth** (`user:write`)

**Request** — `tiyi.v1.UpdateUserRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdateUserResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |

### UserService.DeleteUser

- **Procedure** `POST /tiyi.v1.UserService/DeleteUser`
- **Kind** unary
- **Auth** (`user:delete`)

**Request** — `tiyi.v1.DeleteUserRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteUserResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### UserService.AssignRoles

- **Procedure** `POST /tiyi.v1.UserService/AssignRoles`
- **Kind** unary
- **Auth** (`user:write`)

**Request** — `tiyi.v1.AssignRolesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user_id` | `userId` | `string` | singular | — |
| `role_ids` | `roleIds` | `string` | repeated | — |

**Response** — `tiyi.v1.AssignRolesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |

### UserService.ResetPassword

- **Procedure** `POST /tiyi.v1.UserService/ResetPassword`
- **Kind** unary
- **Auth** (`user:write`)

**Request** — `tiyi.v1.ResetPasswordRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user_id` | `userId` | `string` | singular | — |
| `password` | `password` | `string` | singular | — |

**Response** — `tiyi.v1.ResetPasswordResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `changed` | `changed` | `bool` | singular | — |

### UserService.LockUser

- **Procedure** `POST /tiyi.v1.UserService/LockUser`
- **Kind** unary
- **Auth** (`user:write`)

**Request** — `tiyi.v1.LockUserRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user_id` | `userId` | `string` | singular | — |

**Response** — `tiyi.v1.LockUserResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |

### UserService.UnlockUser

- **Procedure** `POST /tiyi.v1.UserService/UnlockUser`
- **Kind** unary
- **Auth** (`user:write`)

**Request** — `tiyi.v1.UnlockUserRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user_id` | `userId` | `string` | singular | — |

**Response** — `tiyi.v1.UnlockUserResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`User`](#user) | singular | — |

### UserService.ResetUserMFA

- **Procedure** `POST /tiyi.v1.UserService/ResetUserMFA`
- **Kind** unary
- **Auth** (`user:write`)

**Request** — `tiyi.v1.ResetUserMFARequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user_id` | `userId` | `string` | singular | — |

**Response** — `tiyi.v1.ResetUserMFAResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `mfa_reset` | `mfaReset` | `bool` | singular | — |

### RoleService.ListRoles

- **Procedure** `POST /tiyi.v1.RoleService/ListRoles`
- **Kind** unary
- **Auth** (`role:read`)

**Request** — `tiyi.v1.ListRolesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |

**Response** — `tiyi.v1.ListRolesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Role`](#role) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### RoleService.GetRole

- **Procedure** `POST /tiyi.v1.RoleService/GetRole`
- **Kind** unary
- **Auth** (`role:read`)

**Request** — `tiyi.v1.GetRoleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetRoleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `role` | `role` | [`Role`](#role) | singular | — |

### RoleService.CreateRole

- **Procedure** `POST /tiyi.v1.RoleService/CreateRole`
- **Kind** unary
- **Auth** (`role:write`)

**Request** — `tiyi.v1.CreateRoleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `role` | `role` | [`Role`](#role) | singular | — |

**Response** — `tiyi.v1.CreateRoleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `role` | `role` | [`Role`](#role) | singular | — |

### RoleService.UpdateRole

- **Procedure** `POST /tiyi.v1.RoleService/UpdateRole`
- **Kind** unary
- **Auth** (`role:write`)

**Request** — `tiyi.v1.UpdateRoleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `role` | `role` | [`Role`](#role) | singular | — |
| `update_mask` | `updateMask` | `google.protobuf.FieldMask` | singular | _comma-joined field paths, e.g. `"name,status"`._ |

**Response** — `tiyi.v1.UpdateRoleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `role` | `role` | [`Role`](#role) | singular | — |

### RoleService.DeleteRole

- **Procedure** `POST /tiyi.v1.RoleService/DeleteRole`
- **Kind** unary
- **Auth** (`role:delete`)

**Request** — `tiyi.v1.DeleteRoleRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteRoleResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### RoleService.ListPermissions

- **Procedure** `POST /tiyi.v1.RoleService/ListPermissions`
- **Kind** unary
- **Auth** (`role:read`)

**Request** — `tiyi.v1.ListPermissionsRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ListPermissionsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `permissions` | `permissions` | [`Permission`](#permission) | repeated | — |

## Messages

### Permission

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `code` | `code` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |

### Role

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `description` | `description` | `string` | singular | — |
| `builtin` | `builtin` | `bool` | singular | — |
| `permissions` | `permissions` | `string` | repeated | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `member_count` | `memberCount` | `int64` | singular | _JSON string (64-bit ints are quoted)._ |

### User

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `username` | `username` | `string` | singular | — |
| `email` | `email` | `string` | singular | — |
| `display_name` | `displayName` | `string` | singular | — |
| `roles` | `roles` | [`Role`](#role) | repeated | — |
| `locked` | `locked` | `bool` | singular | — |
| `last_login_at` | `lastLoginAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `deleted_at` | `deletedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `totp_enabled` | `totpEnabled` | `bool` | singular | — |
| `external_providers` | `externalProviders` | `string` | repeated | — |
