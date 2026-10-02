
// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://connect.squareupsandbox.com" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("SQUARE_ACCESS_TOKEN") : "test_token";
final string locationId = isLiveServer ? os:getEnv("SQUARE_LOCATION_ID") : "L88917AVBK2S5";

final Client square = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCancelPayment() returns error? {
    CancelPaymentResponse response = check square->cancelPayment("GQTFp1ZlXdpoW4o6eGiZhbjosiDFf");
    test:assertTrue(response?.payment !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCard() returns error? {
    CreateCardResponse response = check square->createCard({
        idempotencyKey: "card-key-1",
        sourceId: "cnon:card-nonce-ok",
        card: {cardholderName: "Amelia Earhart", customerId: "JDKYHBWT1D4F8MFH63DBMEN8Y4"}
    });
    test:assertTrue(response?.card !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCustomer() returns error? {
    CreateCustomerResponse response = check square->createCustomer({
        givenName: "Amelia",
        familyName: "Earhart",
        emailAddress: "amelia.earhart@example.com"
    });
    test:assertTrue(response?.customer !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateInvoice() returns error? {
    CreateInvoiceResponse response = check square->createInvoice({
        idempotencyKey: "invoice-key-1",
        invoice: {locationId, orderId: "CAISENgvlJ6jLWAzERDzjyHVybY"}
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
        idempotencyKey: "order-key-1",
        'order: {locationId, referenceId: "my-order-001"}
    });
    test:assertTrue(response?.'order !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreatePayment() returns error? {
    CreatePaymentResponse response = check square->createPayment({
        idempotencyKey: "payment-key-1",
        sourceId: "cnon:card-nonce-ok",
        amountMoney: {amount: 2500, currency: "USD"}
    });
    test:assertTrue(response?.payment !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRemoveCatalogObject() returns error? {
    UpsertCatalogObjectResponse created = check square->upsertCatalogObject({
        idempotencyKey: "catalog-delete-key",
        'object: {id: "#temp-delete-item", 'type: "ITEM", itemData: {name: "Temporary item"}}
    });
    string objectId = created?.catalogObject?.id ?: "H42BRLUJ5KTZTTMPVSLFAACQ";
    DeleteCatalogObjectResponse response = check square->deleteCatalogObject(objectId);
    test:assertTrue(response?.deletedObjectIds !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteCustomer() returns error? {
    CreateCustomerResponse created = check square->createCustomer({givenName: "Temporary", familyName: "Customer"});
    string customerId = created?.customer?.id ?: "JDKYHBWT1D4F8MFH63DBMEN8Y4";
    DeleteCustomerResponse response = check square->deleteCustomer(customerId);
    test:assertTrue(response?.errors is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetInvoice() returns error? {
    GetInvoiceResponse response = check square->getInvoice("inv:0-ChCHu2mZEabLeeHahQnXDjZQECY");
    test:assertTrue(response?.invoice !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPayment() returns error? {
    GetPaymentResponse response = check square->getPayment("GQTFp1ZlXdpoW4o6eGiZhbjosiDFf");
    test:assertTrue(response?.payment !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCards() returns error? {
    ListCardsResponse response = check square->listCards();
    test:assertTrue(response?.cards !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCatalog() returns error? {
    ListCatalogResponse response = check square->listCatalog();
    test:assertTrue(response?.objects !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCustomers() returns error? {
    ListCustomersResponse response = check square->listCustomers();
    test:assertTrue(response?.customers !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListInvoices() returns error? {
    ListInvoicesResponse response = check square->listInvoices(locationId = locationId);
    test:assertTrue(response?.invoices !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListLocations() returns error? {
    ListLocationsResponse response = check square->listLocations();
    test:assertTrue(response?.locations !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListPayments() returns error? {
    ListPaymentsResponse response = check square->listPayments();
    test:assertTrue(response?.payments !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveCatalogObject() returns error? {
    RetrieveCatalogObjectResponse response = check square->retrieveCatalogObject("H42BRLUJ5KTZTTMPVSLFAACQ");
    test:assertTrue(response?.'object !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveCustomer() returns error? {
    RetrieveCustomerResponse response = check square->retrieveCustomer("JDKYHBWT1D4F8MFH63DBMEN8Y4");
    test:assertTrue(response?.customer !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveLocation() returns error? {
    RetrieveLocationResponse response = check square->retrieveLocation(locationId);
    test:assertTrue(response?.location !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testRetrieveOrder() returns error? {
    RetrieveOrderResponse response = check square->retrieveOrder("CAISENgvlJ6jLWAzERDzjyHVybY");
    test:assertTrue(response?.'order !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testSearchCustomers() returns error? {
    SearchCustomersResponse response = check square->searchCustomers({'limit: 10});
    test:assertTrue(response?.customers !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testSearchOrders() returns error? {
    SearchOrdersResponse response = check square->searchOrders({locationIds: [locationId]});
    test:assertTrue(response?.orders !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateCustomer() returns error? {
    UpdateCustomerResponse response = check square->updateCustomer("JDKYHBWT1D4F8MFH63DBMEN8Y4", {givenName: "Amelia", familyName: "Earhart-Putnam"});
    test:assertTrue(response?.customer !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpsertCatalogObject() returns error? {
    UpsertCatalogObjectResponse response = check square->upsertCatalogObject({
        idempotencyKey: "catalog-key-1",
        'object: {id: "#temp-item", 'type: "ITEM", itemData: {name: "Cocoa"}}
    });
    test:assertTrue(response?.catalogObject !is ());
}
