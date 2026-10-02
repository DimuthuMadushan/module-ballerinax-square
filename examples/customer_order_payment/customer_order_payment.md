# Customer order payment

This example creates a customer, places an order for that customer at a location, pays for the order and reads the payment back to confirm its status. It shows how the customers, orders and payments operations of the Square connector fit together.

## Prerequisites

### 1. Set up a Square application

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-square/blob/main/ballerina/README.md#setup-guide) to obtain an access token and a location ID. Use a Sandbox application while you try the example.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
accessToken = "<access-token>"
locationId = "<location-id>"
paymentSourceId = "<payment-source-id, e.g. cnon:card-nonce-ok in the Sandbox>"
customerEmail = "<customer-email-address>"
itemName = "<order-item-name>"
itemPriceInCents = <price-in-the-smallest-currency-unit>
currencyCode = "<currency-code, e.g. USD>"
serviceUrl = "https://connect.squareupsandbox.com"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
