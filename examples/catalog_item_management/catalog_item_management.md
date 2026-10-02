# Catalog item management

This example publishes an item to the seller's catalog, reads it back, looks for it across every page of the catalog listing and, when requested, deletes it again. It shows the catalog operations of the Square connector, including cursor-based pagination.

## Prerequisites

### 1. Set up a Square application

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-square/blob/main/ballerina/README.md#setup-guide) to obtain an access token. Use a Sandbox application while you try the example.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
accessToken = "<access-token>"
itemName = "<catalog-item-name>"
itemDescription = "<catalog-item-description>"
deleteAfterRun = false
serviceUrl = "https://connect.squareupsandbox.com"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
