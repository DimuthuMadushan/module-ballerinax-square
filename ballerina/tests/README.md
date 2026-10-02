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

1. Set the environment variables below. They are read only when `IS_LIVE_SERVER` is `true`.

    ```bash
    export IS_LIVE_SERVER=true
    export SQUARE_ACCESS_TOKEN=<access-token>
    export SQUARE_LOCATION_ID=<location-id>
    ```

2. Run the tests:

    ```bash
    # Against the mock server
    bal test --groups mock_tests

    # Against the Square Sandbox
    bal test --groups live_tests
    ```

The mock server covers 25 operations across customers, locations, payments, orders, invoices, the catalog and cards. The suite has one test per mocked operation.
