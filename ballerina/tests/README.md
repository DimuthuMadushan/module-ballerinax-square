# Running Tests

## Prerequisites

You need a Square access token and a location ID to run the tests against the Square Sandbox. They are only read when the live toggle is on.

To run the tests against the mock server, no credentials are needed.

## Test environments

There are two test environments for running the Square connector tests. The default environment is the mock server. A live Square Sandbox environment is optional.

| Test Group | Environment                                                                         |
|------------|-------------------------------------------------------------------------------------|
| mock_tests | Mock server for Square API (default environment)                                    |
| live_tests | Square Sandbox API (`https://connect.squareupsandbox.com`)                          |

## Running the tests

### Against the mock server

No credentials are needed. Make sure `IS_LIVE_SERVER` is unset or not `true`:

```bash
bal test --groups mock_tests
```

### Against the Square Sandbox

Set `IS_LIVE_SERVER=true` together with the access token and location ID. Only this run talks to the Sandbox:

```bash
IS_LIVE_SERVER=true SQUARE_ACCESS_TOKEN=<access-token> SQUARE_LOCATION_ID=<location-id> bal test --groups live_tests
```

Each test creates the customers, orders, payments and invoices it needs and uses unique idempotency keys, so it can be rerun. The Sandbox payments use the test card nonce `cnon:card-nonce-ok`.

The mock server covers 25 operations across customers, locations, payments, orders, invoices, the catalog and cards. The suite has one test per mocked operation.
