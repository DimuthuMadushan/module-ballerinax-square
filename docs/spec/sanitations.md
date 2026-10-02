_Author_:  <!-- TODO: Add author name --> \
_Created_: <!-- TODO: Add date --> \
_Updated_: <!-- TODO: Add date --> \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Square. 
The OpenAPI specification is obtained from (TODO: Add source link).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

[//]: # (TODO: Add sanitation details)
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

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
# TODO: Add OpenAPI CLI command used to generate the client
```
Note: The license year is hardcoded to 2024, change if necessary.
