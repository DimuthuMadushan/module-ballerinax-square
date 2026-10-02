## Overview

[Square](https://squareup.com/) is a commerce platform that provides payment processing, point-of-sale, online selling, invoicing and business management tools for sellers of all sizes.

The Square connector lets Ballerina applications work with the [Square Connect API](https://developer.squareup.com/reference/square) to take payments, manage customers, orders, catalogs, invoices, locations, bookings, loyalty programs, subscriptions, team members and inventory. It supports the `2026-09-16` version of the Square API.

### Key features

- Accept and manage payments, refunds, payouts, disputes and cards on file
- Create and track orders, invoices, subscriptions and payment links
- Maintain customer profiles, groups, segments and custom attributes
- Manage the item catalog, inventory counts, locations and merchant settings
- Run bookings, loyalty programs, gift cards, team member schedules and timecards

## Setup guide

To use the Square connector, you need a Square account and an application registered in the Square Developer Console. If you do not have an account, you can sign up [here](https://squareup.com/signup).

### Step 1: Create an application

1. Sign in to the [Square Developer Console](https://developer.squareup.com/apps).

2. Click the **+** button to create a new application and give it a name.

### Step 2: Get your credentials

1. Open the application and choose **Sandbox** or **Production** at the top of the page.

2. Open the **Credentials** page and copy the **Access token** for that environment. Use the Sandbox token while you develop.

3. Open the **Locations** page and note the ID of the location you will work with.

### Step 3: Use OAuth 2.0 (optional)

To act on behalf of other Square sellers, enable OAuth for your application. Copy the **Application ID** and **Application secret** from the **OAuth** page, direct the seller to `https://connect.squareup.com/oauth2/authorize` to grant the scopes your integration needs, and exchange the returned authorization code at `https://connect.squareup.com/oauth2/token` for an access token and a refresh token. The connector can then be configured with the refresh-token grant.

## Quickstart

To use the Square connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `square` module.

```ballerina
import ballerinax/square;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the access token obtained in the steps above:

```toml
accessToken = "<Access token>"
```

2. Create a `square:ConnectionConfig` with the access token and initialize the connector with it. The default service URL is the Square production API; pass `https://connect.squareupsandbox.com` as the second argument to use the sandbox.

```ballerina
configurable string accessToken = ?;

final square:Client squareClient = check new ({
    auth: {
        token: accessToken
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### List the seller's locations

```ballerina
public function main() returns error? {
    square:ListLocationsResponse _ = check squareClient->listLocations();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The Square connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-square/tree/main/examples/), covering the following use cases:

1. [Customer order payment](https://github.com/ballerina-platform/module-ballerinax-square/tree/main/examples/customer_order_payment) - Create a customer, place an order for them, pay for it and read the payment back to confirm its status.

2. [Catalog item management](https://github.com/ballerina-platform/module-ballerinax-square/tree/main/examples/catalog_item_management) - Publish a catalog item, read it back, find it across all catalog pages and optionally delete it.
