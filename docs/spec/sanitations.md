_Author_:  @DimuthuMadushan \
_Created_: 2026/10/02 \
_Updated_: 2026/10/02 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Square. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/square/square/2026-09-16/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


1. **Inlined the external `common.json` schemas** — The source spec referenced four schemas in
   `https://developer-production-s.squarecdn.com/schemas/v1/common.json` (60 `$ref`s), which made it
   non-self-contained. Their definitions were copied from `common.json` into `components.schemas`
   (with the JSON Schema `$id` dropped, as OpenAPI 3.0 schema objects do not support it) and the
   references were repointed:

   | External definition | Added as | References |
   |---|---|---|
   | `squareup.common.String` | `CommonString` | 37 |
   | `squareup.common.Number` | `CommonNumber` | 14 |
   | `squareup.common.Boolean` | `CommonBoolean` | 8 |
   | `squareup.common.PhoneNumber` | `CommonPhoneNumber` | 1 |

2. **Removed properties that reference undefined schemas** — The source spec references
   `#/components/schemas/AppFeeAllocation` and `#/components/schemas/CurrencyExchange` but defines
   neither (the same gap exists in Square's published `connect-api-specification`, and neither type
   exists in Square's SDKs), so client generation cannot resolve them. The following properties were
   removed:
   - `CreatePaymentRequest.app_fee_allocations`
   - `RefundPaymentRequest.app_fee_allocations`
   - `Payment.app_fee_allocations`
   - `PaymentRefund.app_fee_allocations`
   - `Payment.buyer_currency_exchange`

   None of them were listed under `required`. They can be restored once Square publishes the schemas.

3. **Added missing path parameter** — `PUT /v2/vendors/{vendor_id}` (`UpdateVendor`) declared no
   `vendor_id` path parameter, so client generation would drop the operation. Added a required
   string `vendor_id` path parameter, matching `GET /v2/vendors/{vendor_id}`.

4. **Renamed operationIds** — Square's PascalCase operationIds (for example `ListCustomers`) were converted to
   camelCase (`listCustomers`) so they become idiomatic Ballerina remote method names. Operations whose
   name exceeded 37 characters were shortened: every `*CustomAttributeDefinition*` operation became
   `*AttributeDefinition*` (for example `createBookingAttributeDefinition`), and
   `DeprecatedBatchRetrieveInventoryChanges`, `DeprecatedBatchRetrieveInventoryCounts` and
   `DeprecatedRetrieveInventoryPhysicalCount` became `deprecatedBatchInventoryChanges`,
   `deprecatedBatchInventoryCounts` and `deprecatedRetrievePhysicalCount`. The decisions are stored in
   `ai-mappings.json`.

5. **Rewrote generic `Success` response descriptions** — All 332 typed `2XX` responses described only as `Success`
   were given a description derived from the operation they belong to: 141 by the `get`/`list`/`create`/`update`
   rules of `tooling/sanitize_spec.py` and the remaining 191 (`retrieve*`, `search*`, `delete*`, `cancel*`, `bulk*`
   and so on) through an explicit operationId-to-description map passed with `--return-overrides`.

6. **Removed the `oauth2ClientSecret` apiKey security scheme** — The source spec defined an apiKey scheme that
   carries the application secret in the `Authorization` header. It was removed by choice, to keep one auth
   model: the token endpoints use the client's bearer or OAuth 2.0 auth. This also removes the generated
   `ApiKeysConfig` option, so `ConnectionConfig.auth` is
   `http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig`.

7. **Set `RevokeToken` security to `oauth2`** — `POST /oauth2/revoke` had `security: [{oauth2: null}]` in the
   source; it is now `[{"oauth2": []}]` (an empty scope list instead of null), so `revokeToken` runs with the
   client's bearer or OAuth 2.0 auth and takes no `Authorization` header parameter. Square documents this
   endpoint as requiring `Authorization: Client <APPLICATION_SECRET>`, so the connector deviates from that
   documented behaviour.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license docs/license.txt --client-methods remote -o ballerina
```
