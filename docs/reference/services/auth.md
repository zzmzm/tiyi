<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# auth.proto — Authentication and session lifecycle

Schema: `tiyi.v1` · `auth.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### AuthService

| RPC | Kind | Required permission |
|---|---|---|
| [`GetLoginOptions`](#authservicegetloginoptions) | unary | **public** (no token) |
| [`Login`](#authservicelogin) | unary | **public** (no token) |
| [`CompleteAuthenticationChallenge`](#authservicecompleteauthenticationchallenge) | unary | **public** (no token) |
| [`Logout`](#authservicelogout) | unary | **public** (no token) |
| [`Refresh`](#authservicerefresh) | unary | **public** (no token) |
| [`GetUserInfo`](#authservicegetuserinfo) | unary | authenticated |
| [`GetAccessCodes`](#authservicegetaccesscodes) | unary | authenticated |
| [`ChangePassword`](#authservicechangepassword) | unary | authenticated |
| [`GetMFAStatus`](#authservicegetmfastatus) | unary | authenticated |
| [`BeginTOTPEnrollment`](#authservicebegintotpenrollment) | unary | authenticated |
| [`ConfirmTOTPEnrollment`](#authserviceconfirmtotpenrollment) | unary | authenticated |
| [`DisableTOTP`](#authservicedisabletotp) | unary | authenticated |
| [`RegenerateRecoveryCodes`](#authserviceregeneraterecoverycodes) | unary | authenticated |

## RPCs

### AuthService.GetLoginOptions

- **Procedure** `POST /tiyi.v1.AuthService/GetLoginOptions`
- **Kind** unary
- **Auth** **public** (no token)

**Request** — `tiyi.v1.GetLoginOptionsRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetLoginOptionsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `password_enabled` | `passwordEnabled` | `bool` | singular | — |
| `providers` | `providers` | [`LoginProvider`](#loginprovider) | repeated | — |

### AuthService.Login

- **Procedure** `POST /tiyi.v1.AuthService/Login`
- **Kind** unary
- **Auth** **public** (no token)

**Request** — `tiyi.v1.LoginRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `username` | `username` | `string` | singular | — |
| `password` | `password` | `string` | singular | — |
| `remember` | `remember` | `bool` | singular | — |

**Response** — `tiyi.v1.LoginResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `access_token` | `accessToken` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `user` | `user` | [`CurrentUser`](#currentuser) | singular | — |
| `challenge_required` | `challengeRequired` | `bool` | singular | — |
| `challenge_kind` | `challengeKind` | `string` | singular | — |
| `challenge_prompt` | `challengePrompt` | `string` | singular | — |
| `recovery_code_allowed` | `recoveryCodeAllowed` | `bool` | singular | — |

### AuthService.CompleteAuthenticationChallenge

- **Procedure** `POST /tiyi.v1.AuthService/CompleteAuthenticationChallenge`
- **Kind** unary
- **Auth** **public** (no token)

**Request** — `tiyi.v1.CompleteAuthenticationChallengeRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `code` | `code` | `string` | singular | — |

**Response** — `tiyi.v1.CompleteAuthenticationChallengeResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `access_token` | `accessToken` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `user` | `user` | [`CurrentUser`](#currentuser) | singular | — |
| `challenge_required` | `challengeRequired` | `bool` | singular | — |
| `challenge_kind` | `challengeKind` | `string` | singular | — |
| `challenge_prompt` | `challengePrompt` | `string` | singular | — |
| `recovery_code_allowed` | `recoveryCodeAllowed` | `bool` | singular | — |

### AuthService.Logout

- **Procedure** `POST /tiyi.v1.AuthService/Logout`
- **Kind** unary
- **Auth** **public** (no token)

**Request** — `tiyi.v1.LogoutRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.LogoutResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `logged_out` | `loggedOut` | `bool` | singular | — |

### AuthService.Refresh

- **Procedure** `POST /tiyi.v1.AuthService/Refresh`
- **Kind** unary
- **Auth** **public** (no token)

**Request** — `tiyi.v1.RefreshRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `refresh_token` | `refreshToken` | `string` | singular | — |

**Response** — `tiyi.v1.RefreshResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `access_token` | `accessToken` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AuthService.GetUserInfo

- **Procedure** `POST /tiyi.v1.AuthService/GetUserInfo`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.GetUserInfoRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetUserInfoResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `user` | `user` | [`CurrentUser`](#currentuser) | singular | — |

### AuthService.GetAccessCodes

- **Procedure** `POST /tiyi.v1.AuthService/GetAccessCodes`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.GetAccessCodesRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetAccessCodesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `codes` | `codes` | `string` | repeated | — |

### AuthService.ChangePassword

- **Procedure** `POST /tiyi.v1.AuthService/ChangePassword`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.ChangePasswordRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `current_password` | `currentPassword` | `string` | singular | — |
| `new_password` | `newPassword` | `string` | singular | — |

**Response** — `tiyi.v1.ChangePasswordResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `changed` | `changed` | `bool` | singular | — |

### AuthService.GetMFAStatus

- **Procedure** `POST /tiyi.v1.AuthService/GetMFAStatus`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.GetMFAStatusRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.GetMFAStatusResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `totp_enabled` | `totpEnabled` | `bool` | singular | — |
| `enabled_at` | `enabledAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `recovery_codes_left` | `recoveryCodesLeft` | `int32` | singular | — |

### AuthService.BeginTOTPEnrollment

- **Procedure** `POST /tiyi.v1.AuthService/BeginTOTPEnrollment`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.BeginTOTPEnrollmentRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.BeginTOTPEnrollmentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enrollment_token` | `enrollmentToken` | `string` | singular | — |
| `secret` | `secret` | `string` | singular | — |
| `provisioning_uri` | `provisioningUri` | `string` | singular | — |
| `expires_at` | `expiresAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### AuthService.ConfirmTOTPEnrollment

- **Procedure** `POST /tiyi.v1.AuthService/ConfirmTOTPEnrollment`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.ConfirmTOTPEnrollmentRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enrollment_token` | `enrollmentToken` | `string` | singular | — |
| `code` | `code` | `string` | singular | — |

**Response** — `tiyi.v1.ConfirmTOTPEnrollmentResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `enabled` | `enabled` | `bool` | singular | — |
| `recovery_codes` | `recoveryCodes` | `string` | repeated | — |

### AuthService.DisableTOTP

- **Procedure** `POST /tiyi.v1.AuthService/DisableTOTP`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.DisableTOTPRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `code` | `code` | `string` | singular | — |

**Response** — `tiyi.v1.DisableTOTPResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `disabled` | `disabled` | `bool` | singular | — |

### AuthService.RegenerateRecoveryCodes

- **Procedure** `POST /tiyi.v1.AuthService/RegenerateRecoveryCodes`
- **Kind** unary
- **Auth** authenticated

**Request** — `tiyi.v1.RegenerateRecoveryCodesRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `code` | `code` | `string` | singular | — |

**Response** — `tiyi.v1.RegenerateRecoveryCodesResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `recovery_codes` | `recoveryCodes` | `string` | repeated | — |

## Messages

### CurrentUser

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `username` | `username` | `string` | singular | — |
| `email` | `email` | `string` | singular | — |
| `display_name` | `displayName` | `string` | singular | — |
| `roles` | `roles` | `string` | repeated | — |
| `access_codes` | `accessCodes` | `string` | repeated | — |

### LoginProvider

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `label` | `label` | `string` | singular | — |
| `login_url` | `loginUrl` | `string` | singular | — |
