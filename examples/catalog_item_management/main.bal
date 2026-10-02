// Publishes a catalog item, reads it back, finds it in the catalog listing and optionally removes it.

import ballerina/io;
import ballerina/uuid;
import ballerinax/square;

configurable string accessToken = ?;
configurable string itemName = ?;
configurable string itemDescription = ?;
configurable boolean deleteAfterRun = false;
configurable string serviceUrl = "https://connect.squareupsandbox.com";

public function main() returns error? {
    square:Client squareClient = check new ({auth: {token: accessToken}}, serviceUrl);

    // Step 1: Create the item.
    square:UpsertCatalogObjectResponse created = check squareClient->upsertCatalogObject({
        idempotencyKey: uuid:createRandomUuid(),
        'object: {
            id: "#new-item",
            'type: "ITEM",
            itemData: {name: itemName, description: itemDescription}
        }
    });
    string objectId = created?.catalogObject?.id ?: "";
    if objectId == "" {
        return error("Square did not return a catalog object ID");
    }
    io:println("Created catalog item: ", objectId);

    // Step 2: Read the item back.
    square:RetrieveCatalogObjectResponse retrieved = check squareClient->retrieveCatalogObject(objectId);
    io:println("Retrieved item: ", retrieved?.'object?.itemData?.name);

    // Step 3: Look for the item across every page of the catalog.
    boolean found = false;
    string? cursor = ();
    while true {
        square:ListCatalogResponse page;
        if cursor is string {
            page = check squareClient->listCatalog(types = "ITEM", cursor = cursor);
        } else {
            page = check squareClient->listCatalog(types = "ITEM");
        }
        square:CatalogObject[] objects = page?.objects ?: [];
        foreach square:CatalogObject catalogObject in objects {
            if catalogObject.id == objectId {
                found = true;
            }
        }
        cursor = page?.cursor;
        if cursor is () || found {
            break;
        }
    }
    io:println("Item listed in catalog: ", found);

    // Step 4: Remove the item when requested.
    if deleteAfterRun {
        square:DeleteCatalogObjectResponse deleted = check squareClient->deleteCatalogObject(objectId);
        io:println("Deleted objects: ", deleted?.deletedObjectIds);
    }
}
