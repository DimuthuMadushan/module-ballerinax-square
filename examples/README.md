# Examples

The `ballerinax/square` connector provides practical examples illustrating usage in various scenarios.

1. **[Customer order payment](https://github.com/ballerina-platform/module-ballerinax-square/tree/main/examples/customer_order_payment)** - Create a customer, place an order for them, pay for it and read the payment back to confirm its status.

2. **[Catalog item management](https://github.com/ballerina-platform/module-ballerinax-square/tree/main/examples/catalog_item_management)** - Publish a catalog item, read it back, find it across all catalog pages and optionally delete it.

## Prerequisites

1. Create a Square application and copy its access token as described in the [Setup guide](https://central.ballerina.io/ballerinax/square/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
accessToken = "<Access token>"
serviceUrl = "https://connect.squareupsandbox.com"
```

Each example lists the additional values it needs in its own README.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
