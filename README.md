# Ballerina Square connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-square/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-square/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-square.svg)](https://github.com/ballerina-platform/module-ballerinax-square/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/square.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fsquare)

## Overview

[Square](https://squareup.com/) is a commerce platform that provides payment processing, point-of-sale, online selling, invoicing and business management tools for sellers of all sizes.

The Square connector lets Ballerina applications work with the [Square Connect API](https://developer.squareup.com/reference/square) to take payments, manage customers, orders, catalogs, invoices, locations, bookings, loyalty programs, subscriptions, team members and inventory. It supports the `2026-09-16` version of the Square API.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`square` package](https://central.ballerina.io/ballerinax/square/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
