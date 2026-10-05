
import ballerina/http;
import ballerina/os;
import ballerina/test;
import ballerina/uuid;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://connect.squareupsandbox.com" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("SQUARE_ACCESS_TOKEN") : "test_token";
final string locationId = isLiveServer ? os:getEnv("SQUARE_LOCATION_ID") : "L88917AVBK2S5";

final Client square = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

isolated function createTestCustomer() returns string|error {
    CreateCustomerResponse response = check square->createCustomer({
        idempotencyKey: uuid:createRandomUuid(),
        givenName: "Amelia",
        familyName: "Earhart",
        emailAddress: "amelia.earhart@example.com"
    });
    return response?.customer?.id ?: error("customer was not created");
}

isolated function createTestOrder(string? customerId = ()) returns string|error {
    CreateOrderResponse response = check square->createOrder({
        idempotencyKey: uuid:createRandomUuid(),
        'order: {
            locationId,
            customerId,
            lineItems: [{name: "Cookie", quantity: "2", basePriceMoney: {amount: 1250, currency: "USD"}}]
        }
    });
    return response?.'order?.id ?: error("order was not created");
}

isolated function createTestPayment(boolean autocomplete) returns string|error {
    CreatePaymentResponse response = check square->createPayment({
        idempotencyKey: uuid:createRandomUuid(),
        sourceId: "cnon:card-nonce-ok",
        autocomplete,
        locationId,
        amountMoney: {amount: 2500, currency: "USD"}
    });
    return response?.payment?.id ?: error("payment was not created");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCancelPayment() returns error? {
    string paymentId = check createTestPayment(false);
    CancelPaymentResponse response = check square->cancelPayment(paymentId);
    test:assertTrue(response?.payment !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCard() returns error? {
    string customerId = check createTestCustomer();
    CreateCardResponse response = check square->createCard({
        idempotencyKey: uuid:createRandomUuid(),
        sourceId: "cnon:card-nonce-ok",
        card: {cardholderName: "Amelia Earhart", customerId}
    });
    test:assertTrue(response?.card !is ());
    _ = check square->deleteCustomer(customerId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCustomer() returns error? {
    CreateCustomerResponse response = check square->createCustomer({
        idempotencyKey: uuid:createRandomUuid(),
        givenName: "Amelia",
        familyName: "Earhart",
        emailAddress: "amelia.earhart@example.com"
    });
    test:assertTrue(response?.customer !is ());
    string? customerId = response?.customer?.id;
    if customerId is string {
        _ = check square->deleteCustomer(customerId);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateInvoice() returns error? {
    string customerId = check createTestCustomer();
    string orderId = check createTestOrder(customerId);
    CreateInvoiceResponse response = check square->createInvoice({
        idempotencyKey: uuid:createRandomUuid(),
        invoice: {
            locationId,
            orderId,
            primaryRecipient: {customerId},
            deliveryMethod: "EMAIL",
            paymentRequests: [{requestType: "BALANCE", dueDate: "2030-01-01"}],
            acceptedPaymentMethods: {card: true}
        }
    });
    test:assertTrue(response?.invoice !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateLocation() returns error? {
    CreateLocationResponse response = check square->createLocation({location: {name: "Midtown"}});
    test:assertTrue(response?.location !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateOrder() returns error? {
    CreateOrderResponse response = check square->createOrder({
        idempotencyKey: uuid:createRandomUuid(),
        'order: {locationId, referenceId: "my-order-001"}
    });
    test:assertTrue(response?.'order !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreatePayment() returns error? {
    CreatePaymentResponse response = check square->createPayment({
        idempotencyKey: uuid:createRandomUuid(),
        sourceId: "cnon:card-nonce-ok",
        amountMoney: {amount: 2500, currency: "USD"}
    });
    test:assertTrue(response?.payment !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteCustomer() returns error? {
    CreateCustomerResponse created = check square->createCustomer({
        idempotencyKey: uuid:createRandomUuid(),
        givenName: "Temporary",
        familyName: "Customer"
    });
    string customerId = created?.customer?.id ?: "JDKYHBWT1D4F8MFH63DBMEN8Y4";
    DeleteCustomerResponse response = check square->deleteCustomer(customerId);
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetInvoice() returns error? {
    string customerId = check createTestCustomer();
    string orderId = check createTestOrder(customerId);
    CreateInvoiceResponse created = check square->createInvoice({
        idempotencyKey: uuid:createRandomUuid(),
        invoice: {
            locationId,
            orderId,
            primaryRecipient: {customerId},
            deliveryMethod: "EMAIL",
            paymentRequests: [{requestType: "BALANCE", dueDate: "2030-01-01"}],
            acceptedPaymentMethods: {card: true}
        }
    });
    string invoiceId = created?.invoice?.id ?: "";
    test:assertTrue(invoiceId != "");
    GetInvoiceResponse response = check square->getInvoice(invoiceId);
    test:assertTrue(response?.invoice !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPayment() returns error? {
    string paymentId = check createTestPayment(true);
    GetPaymentResponse response = check square->getPayment(paymentId);
    test:assertTrue(response?.payment !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCards() returns error? {
    ListCardsResponse response = check square->listCards();
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCatalog() returns error? {
    ListCatalogResponse response = check square->listCatalog();
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCustomers() returns error? {
    ListCustomersResponse response = check square->listCustomers();
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListInvoices() returns error? {
    ListInvoicesResponse response = check square->listInvoices(locationId = locationId);
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListLocations() returns error? {
    ListLocationsResponse response = check square->listLocations();
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListPayments() returns error? {
    ListPaymentsResponse response = check square->listPayments();
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRemoveCatalogObject() returns error? {
    UpsertCatalogObjectResponse created = check square->upsertCatalogObject({
        idempotencyKey: uuid:createRandomUuid(),
        'object: {id: "#temp-delete-item", 'type: "ITEM", itemData: {name: "Temporary item"}}
    });
    string objectId = created?.catalogObject?.id ?: "H42BRLUJ5KTZTTMPVSLFAACQ";
    DeleteCatalogObjectResponse response = check square->deleteCatalogObject(objectId);
    test:assertTrue(response?.deletedObjectIds !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveCatalogObject() returns error? {
    UpsertCatalogObjectResponse created = check square->upsertCatalogObject({
        idempotencyKey: uuid:createRandomUuid(),
        'object: {id: "#temp-retrieve-item", 'type: "ITEM", itemData: {name: "Retrievable item"}}
    });
    string objectId = created?.catalogObject?.id ?: "H42BRLUJ5KTZTTMPVSLFAACQ";
    RetrieveCatalogObjectResponse response = check square->retrieveCatalogObject(objectId);
    test:assertTrue(response?.'object !is ());
    _ = check square->deleteCatalogObject(objectId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveCustomer() returns error? {
    string customerId = check createTestCustomer();
    RetrieveCustomerResponse response = check square->retrieveCustomer(customerId);
    test:assertTrue(response?.customer !is ());
    _ = check square->deleteCustomer(customerId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveLocation() returns error? {
    RetrieveLocationResponse response = check square->retrieveLocation(locationId);
    test:assertTrue(response?.location !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveOrder() returns error? {
    string orderId = check createTestOrder();
    RetrieveOrderResponse response = check square->retrieveOrder(orderId);
    test:assertTrue(response?.'order !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testSearchCustomers() returns error? {
    SearchCustomersResponse response = check square->searchCustomers({'limit: 10});
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testSearchOrders() returns error? {
    SearchOrdersResponse response = check square->searchOrders({locationIds: [locationId]});
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateCustomer() returns error? {
    string customerId = check createTestCustomer();
    UpdateCustomerResponse response = check square->updateCustomer(customerId, {familyName: "Earhart-Putnam"});
    test:assertTrue(response?.customer !is ());
    _ = check square->deleteCustomer(customerId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpsertCatalogObject() returns error? {
    UpsertCatalogObjectResponse response = check square->upsertCatalogObject({
        idempotencyKey: uuid:createRandomUuid(),
        'object: {id: "#temp-item", 'type: "ITEM", itemData: {name: "Cocoa"}}
    });
    test:assertTrue(response?.catalogObject !is ());
}
