<!-- v3.8.0 public API reference, derived from the verified protobuf contract. -->

# cert.proto — Certificates and ACME/DNS providers

Schema: `tiyi.v1` · `cert.proto` · [English guide](../../en/api.md) · [中文指南](../../zh/api.md) · [Full RPC index](../rpc-index.md)

## Services

### CertService

| RPC | Kind | Required permission |
|---|---|---|
| [`ListCerts`](#certservicelistcerts) | unary | (`cert:read`) |
| [`GetCert`](#certservicegetcert) | unary | (`cert:read`) |
| [`UploadCert`](#certserviceuploadcert) | unary | (`cert:write`) |
| [`IssueACMECert`](#certserviceissueacmecert) | unary | (`cert:issue`) |
| [`RenewCert`](#certservicerenewcert) | unary | (`cert:issue`) |
| [`DeleteCert`](#certservicedeletecert) | unary | (`cert:delete`) |
| [`DownloadCert`](#certservicedownloadcert) | unary | (`cert:export`) |
| [`ListDNSProviders`](#certservicelistdnsproviders) | unary | (`cert:read`) |
| [`GetDNSProvider`](#certservicegetdnsprovider) | unary | (`cert:read`) |
| [`CreateDNSProvider`](#certservicecreatednsprovider) | unary | (`cert:write`) |
| [`UpdateDNSProvider`](#certserviceupdatednsprovider) | unary | (`cert:write`) |
| [`DeleteDNSProvider`](#certservicedeletednsprovider) | unary | (`cert:delete`) |
| [`ListDNSProviderDrivers`](#certservicelistdnsproviderdrivers) | unary | (`cert:read`) |

## RPCs

### CertService.ListCerts

- **Procedure** `POST /tiyi.v1.CertService/ListCerts`
- **Kind** unary
- **Auth** (`cert:read`)

**Request** — `tiyi.v1.ListCertsRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `page` | `page` | [`PageRequest`](common.md#pagerequest) | singular | — |
| `query` | `query` | `string` | singular | — |

**Response** — `tiyi.v1.ListCertsResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`Certificate`](#certificate) | repeated | — |
| `page` | `page` | [`PageResponse`](common.md#pageresponse) | singular | — |

### CertService.GetCert

- **Procedure** `POST /tiyi.v1.CertService/GetCert`
- **Kind** unary
- **Auth** (`cert:read`)

**Request** — `tiyi.v1.GetCertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetCertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cert` | `cert` | [`Certificate`](#certificate) | singular | — |

### CertService.UploadCert

- **Procedure** `POST /tiyi.v1.CertService/UploadCert`
- **Kind** unary
- **Auth** (`cert:write`)

**Request** — `tiyi.v1.UploadCertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `cert_pem` | `certPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `key_pem` | `keyPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `chain_pem` | `chainPem` | `string` | repeated | — |

**Response** — `tiyi.v1.UploadCertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cert` | `cert` | [`Certificate`](#certificate) | singular | — |

### CertService.IssueACMECert

- **Procedure** `POST /tiyi.v1.CertService/IssueACMECert`
- **Kind** unary
- **Auth** (`cert:issue`)

**Request** — `tiyi.v1.IssueACMECertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `dns_names` | `dnsNames` | `string` | repeated | — |
| `email` | `email` | `string` | singular | — |
| `staging` | `staging` | `bool` | singular | — |
| `acme_issuer` | `acmeIssuer` | `string` | singular | acme_issuer selects a CA: "letsencrypt" (default), "letsencrypt-staging", or "custom" (requires directory_url). When empty, defaults to production Let's Encrypt unless staging=true. |
| `directory_url` | `directoryUrl` | `string` | singular | directory_url overrides acme_issuer when set — used for Pebble / ZeroSSL / enterprise ACME CAs. |
| `challenge_type` | `challengeType` | `string` | singular | challenge_type is "http-01" (default) or "dns-01". |

**Response** — `tiyi.v1.IssueACMECertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cert` | `cert` | [`Certificate`](#certificate) | singular | — |
| `order_id` | `orderId` | `string` | singular | order_id is the acme_order row backing this issuance. Clients can poll GetACMEOrder (future RPC) or the audit log for details. |

### CertService.RenewCert

- **Procedure** `POST /tiyi.v1.CertService/RenewCert`
- **Kind** unary
- **Auth** (`cert:issue`)

**Request** — `tiyi.v1.RenewCertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `force` | `force` | `bool` | singular | — |

**Response** — `tiyi.v1.RenewCertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cert` | `cert` | [`Certificate`](#certificate) | singular | — |

### CertService.DeleteCert

- **Procedure** `POST /tiyi.v1.CertService/DeleteCert`
- **Kind** unary
- **Auth** (`cert:delete`)

**Request** — `tiyi.v1.DeleteCertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteCertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### CertService.DownloadCert

- **Procedure** `POST /tiyi.v1.CertService/DownloadCert`
- **Kind** unary
- **Auth** (`cert:export`)

**Request** — `tiyi.v1.DownloadCertRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `include_private_key` | `includePrivateKey` | `bool` | singular | — |

**Response** — `tiyi.v1.DownloadCertResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `cert_pem` | `certPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `key_pem` | `keyPem` | `bytes` | singular | _base64-encoded JSON string._ |
| `chain_pem` | `chainPem` | `string` | repeated | — |

### CertService.ListDNSProviders

DNS-01 provider management (Phase C). Providers publish TXT records at _acme-challenge.<domain> so ACME DNS-01 issuance (including wildcards) can succeed without the agent datapath.

- **Procedure** `POST /tiyi.v1.CertService/ListDNSProviders`
- **Kind** unary
- **Auth** (`cert:read`)

**Request** — `tiyi.v1.ListDNSProvidersRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `status` | `status` | `string` | singular | optional filter |
| `provider` | `provider` | `string` | singular | optional filter |

**Response** — `tiyi.v1.ListDNSProvidersResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `items` | `items` | [`ACMEDNSProvider`](#acmednsprovider) | repeated | — |

### CertService.GetDNSProvider

- **Procedure** `POST /tiyi.v1.CertService/GetDNSProvider`
- **Kind** unary
- **Auth** (`cert:read`)

**Request** — `tiyi.v1.GetDNSProviderRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.GetDNSProviderResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `provider` | `provider` | [`ACMEDNSProvider`](#acmednsprovider) | singular | — |

### CertService.CreateDNSProvider

- **Procedure** `POST /tiyi.v1.CertService/CreateDNSProvider`
- **Kind** unary
- **Auth** (`cert:write`)

**Request** — `tiyi.v1.CreateDNSProviderRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `name` | `name` | `string` | singular | — |
| `provider` | `provider` | `string` | singular | — |
| `zones` | `zones` | `string` | repeated | — |
| `settings` | `settings` | map&lt;`string`, `string`&gt; | map | — |
| `propagation_seconds` | `propagationSeconds` | `int32` | singular | — |
| `credentials_json` | `credentialsJson` | `bytes` | singular | credentials_json is the JSON-encoded driver credentials blob. It is sent base64-encoded in connect-web JSON. _base64-encoded JSON string._ |

**Response** — `tiyi.v1.CreateDNSProviderResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `provider` | `provider` | [`ACMEDNSProvider`](#acmednsprovider) | singular | — |

### CertService.UpdateDNSProvider

- **Procedure** `POST /tiyi.v1.CertService/UpdateDNSProvider`
- **Kind** unary
- **Auth** (`cert:write`)

**Request** — `tiyi.v1.UpdateDNSProviderRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `provider` | `provider` | `string` | singular | — |
| `zones` | `zones` | `string` | repeated | — |
| `settings` | `settings` | map&lt;`string`, `string`&gt; | map | — |
| `propagation_seconds` | `propagationSeconds` | `int32` | singular | — |
| `status` | `status` | `string` | singular | — |
| `credentials_json` | `credentialsJson` | `bytes` | singular | credentials_json is optional — empty preserves the stored blob. _base64-encoded JSON string._ |

**Response** — `tiyi.v1.UpdateDNSProviderResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `provider` | `provider` | [`ACMEDNSProvider`](#acmednsprovider) | singular | — |

### CertService.DeleteDNSProvider

- **Procedure** `POST /tiyi.v1.CertService/DeleteDNSProvider`
- **Kind** unary
- **Auth** (`cert:delete`)

**Request** — `tiyi.v1.DeleteDNSProviderRequest`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |

**Response** — `tiyi.v1.DeleteDNSProviderResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `result` | `result` | [`MutationResult`](common.md#mutationresult) | singular | — |

### CertService.ListDNSProviderDrivers

- **Procedure** `POST /tiyi.v1.CertService/ListDNSProviderDrivers`
- **Kind** unary
- **Auth** (`cert:read`)

**Request** — `tiyi.v1.ListDNSProviderDriversRequest`

_No fields — send `{}`._

**Response** — `tiyi.v1.ListDNSProviderDriversResponse`

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `drivers` | `drivers` | `string` | repeated | — |

## Messages

### ACMEDNSProvider

ACMEDNSProvider describes a tenant-scoped DNS-01 provider registration. Secret credentials are never returned; callers must re-submit them through Create or Update requests.

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `provider` | `provider` | `string` | singular | provider is the driver identifier: "cloudflare", "route53", "aliyun". See ListDNSProviderDrivers for the full set. |
| `zones` | `zones` | `string` | repeated | zones is the set of apex zones this provider can publish into. Empty means the provider handles every zone (catch-all). |
| `settings` | `settings` | map&lt;`string`, `string`&gt; | map | settings maps driver-specific knobs (api_base_url, region, …). |
| `propagation_seconds` | `propagationSeconds` | `int32` | singular | — |
| `status` | `status` | `string` | singular | Operator intent: "active" \| "disabled". Failures never disable a provider. |
| `last_error` | `lastError` | `string` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `deleted_at` | `deletedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `health` | `health` | `string` | singular | Last DNS publication/propagation result: "unknown" \| "healthy" \| "error". |
| `health_checked_at` | `healthCheckedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |

### Certificate

| Field | JSON key | Type | Cardinality | Description |
|---|---|---|---|---|
| `id` | `id` | `string` | singular | — |
| `tenant_id` | `tenantId` | `string` | singular | — |
| `name` | `name` | `string` | singular | — |
| `dns_names` | `dnsNames` | `string` | repeated | — |
| `issuer` | `issuer` | `string` | singular | — |
| `not_before` | `notBefore` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `not_after` | `notAfter` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `fingerprint_sha256` | `fingerprintSha256` | `string` | singular | — |
| `managed` | `managed` | `bool` | singular | — |
| `created_at` | `createdAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `updated_at` | `updatedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `deleted_at` | `deletedAt` | `google.protobuf.Timestamp` | singular | _RFC 3339 string, e.g. `2026-07-26T09:00:00Z`._ |
| `acme_issuer` | `acmeIssuer` | `string` | singular | ACMEIssuer identifies the CA used to obtain a managed certificate: "letsencrypt", "letsencrypt-staging", "custom", or empty for uploads. |
| `auto_renew` | `autoRenew` | `bool` | singular | auto_renew indicates whether the renewal worker will attempt to re-issue this certificate when it nears expiry. |
