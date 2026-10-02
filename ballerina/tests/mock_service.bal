
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

listener http:Listener ep0 = new (9090);

final Money sampleMoney = {amount: 2500, currency: "USD"};

final Customer sampleCustomer = {
    id: "JDKYHBWT1D4F8MFH63DBMEN8Y4",
    givenName: "Amelia",
    familyName: "Earhart",
    emailAddress: "amelia.earhart@example.com",
    phoneNumber: "+12125550123",
    companyName: "Electra Aviation",
    referenceId: "YOUR_REFERENCE_ID",
    creationSource: "THIRD_PARTY",
    createdAt: "2026-09-16T10:12:44.123Z",
    updatedAt: "2026-09-16T10:12:44.123Z",
    version: 1,
    address: {addressLine1: "500 Electric Ave", locality: "New York", administrativeDistrictLevel1: "NY", postalCode: "10003", country: "US"}
};

final Location sampleLocation = {
    id: "L88917AVBK2S5",
    name: "Default Test Account",
    businessName: "Jet Fuel Co",
    status: "ACTIVE",
    'type: "PHYSICAL",
    timezone: "America/Los_Angeles",
    country: "US",
    currency: "USD",
    languageCode: "en-US",
    merchantId: "3MYCJG5GVYQ8Q",
    createdAt: "2026-09-16T10:12:44.123Z",
    businessEmail: "info@jetfuel.example.com",
    phoneNumber: "+12125550123",
    address: {addressLine1: "1600 Pennsylvania Ave NW", locality: "Washington", administrativeDistrictLevel1: "DC", postalCode: "20500", country: "US"}
};

final Payment samplePayment = {
    id: "GQTFp1ZlXdpoW4o6eGiZhbjosiDFf",
    status: "COMPLETED",
    sourceType: "CARD",
    locationId: "L88917AVBK2S5",
    orderId: "CAISENgvlJ6jLWAzERDzjyHVybY",
    referenceId: "123456",
    note: "Brief description",
    receiptNumber: "GQTF",
    receiptUrl: "https://squareup.com/receipt/preview/GQTFp1ZlXdpoW4o6eGiZhbjosiDFf",
    createdAt: "2026-09-16T10:12:44.123Z",
    updatedAt: "2026-09-16T10:12:45.001Z",
    amountMoney: sampleMoney,
    totalMoney: sampleMoney,
    cardDetails: {status: "CAPTURED", entryMethod: "KEYED", cvvStatus: "CVV_ACCEPTED", avsStatus: "AVS_ACCEPTED"}
};

final Order sampleOrder = {
    id: "CAISENgvlJ6jLWAzERDzjyHVybY",
    locationId: "L88917AVBK2S5",
    referenceId: "my-order-001",
    customerId: "JDKYHBWT1D4F8MFH63DBMEN8Y4",
    state: "OPEN",
    version: 1,
    createdAt: "2026-09-16T10:12:44.123Z",
    updatedAt: "2026-09-16T10:12:44.123Z",
    totalMoney: sampleMoney,
    lineItems: [{uid: "line-1", name: "Cookie", quantity: "2", basePriceMoney: {amount: 1250, currency: "USD"}, totalMoney: sampleMoney}]
};

final Invoice sampleInvoice = {
    id: "inv:0-ChCHu2mZEabLeeHahQnXDjZQECY",
    version: 1,
    locationId: "L88917AVBK2S5",
    orderId: "CAISENgvlJ6jLWAzERDzjyHVybY",
    invoiceNumber: "inv-100",
    title: "Event Planning Services",
    description: "We appreciate your business!",
    status: "DRAFT",
    deliveryMethod: "EMAIL",
    timezone: "America/Los_Angeles",
    createdAt: "2026-09-16T10:12:44.123Z",
    updatedAt: "2026-09-16T10:12:44.123Z",
    primaryRecipient: {customerId: "JDKYHBWT1D4F8MFH63DBMEN8Y4", givenName: "Amelia", familyName: "Earhart", emailAddress: "amelia.earhart@example.com"}
};

final Card sampleCard = {
    id: "ccof:uIbfJXhXETSP197M3GB",
    cardBrand: "VISA",
    last4: "1111",
    expMonth: 11,
    expYear: 2028,
    cardholderName: "Amelia Earhart",
    cardType: "CREDIT",
    enabled: true,
    customerId: "JDKYHBWT1D4F8MFH63DBMEN8Y4",
    referenceId: "alternate-id-1",
    merchantId: "3MYCJG5GVYQ8Q",
    version: 1,
    billingAddress: {addressLine1: "500 Electric Ave", locality: "New York", postalCode: "10003", country: "US"}
};

final CatalogObject sampleCatalogObject = {
    id: "H42BRLUJ5KTZTTMPVSLFAACQ",
    'type: "ITEM",
    updatedAt: "2026-09-16T10:12:44.123Z",
    version: 1694793184123,
    isDeleted: false,
    presentAtAllLocations: true,
    itemData: {name: "Cocoa", description: "Hot chocolate", productType: "REGULAR"}
};

@http:ServiceConfig {treatNilableAsOptional: true}
service / on ep0 {

    # Delete a catalog object
    #
    # + objectId - The ID of the catalog object to delete
    # + return - The deletion result
    resource function delete v2/catalog/'object/[string objectId]() returns DeleteCatalogObjectResponse {
        return {deletedObjectIds: [objectId], deletedAt: "2026-09-16T10:12:44.123Z"};
    }

    # Delete a customer
    #
    # + customerId - The ID of the customer to delete
    # + version - The current version of the customer profile
    # + return - An empty response on success
    resource function delete v2/customers/[string customerId](int? version) returns DeleteCustomerResponse {
        return {};
    }

    # List cards
    #
    # + cursor - A pagination cursor
    # + customerId - Limit results to cards of this customer
    # + referenceId - Limit results to cards with this reference ID
    # + sortOrder - Sort order by creation time
    # + includeDisabled - Whether to include disabled cards
    # + return - The retrieved cards
    resource function get v2/cards(string? cursor, @http:Query {name: "customer_id"} string? customerId, @http:Query {name: "reference_id"} string? referenceId, @http:Query {name: "sort_order"} SortOrder? sortOrder, @http:Query {name: "include_disabled"} boolean includeDisabled = false) returns ListCardsResponse {
        return {cards: [sampleCard]};
    }

    # Retrieve a catalog object
    #
    # + objectId - The ID of the catalog object
    # + catalogVersion - The specific version of the object to return
    # + includeRelatedObjects - Whether to include related objects
    # + includeCategoryPathToRoot - Whether to include the category path
    # + return - The retrieved catalog object
    resource function get v2/catalog/'object/[string objectId](@http:Query {name: "catalog_version"} int? catalogVersion, @http:Query {name: "include_related_objects"} boolean includeRelatedObjects = false, @http:Query {name: "include_category_path_to_root"} boolean includeCategoryPathToRoot = false) returns RetrieveCatalogObjectResponse {
        CatalogObject catalogObject = sampleCatalogObject.clone();
        catalogObject.id = objectId;
        return {'object: catalogObject};
    }

    # List catalog objects
    #
    # + cursor - The pagination cursor
    # + types - Comma-separated list of object types to return
    # + catalogVersion - The specific version of the catalog to return
    # + return - The list of catalog objects
    resource function get v2/catalog/list(string? cursor, string? types, @http:Query {name: "catalog_version"} int? catalogVersion) returns ListCatalogResponse {
        return {objects: [sampleCatalogObject]};
    }

    # List customers
    #
    # + cursor - A pagination cursor
    # + 'limit - The maximum number of results to return
    # + sortField - Sort field
    # + sortOrder - Sort order
    # + count - Whether to return the total count
    # + return - The list of customers
    resource function get v2/customers(string? cursor, int? 'limit, @http:Query {name: "sort_field"} CustomerSortField? sortField, @http:Query {name: "sort_order"} SortOrder? sortOrder, boolean count = false) returns ListCustomersResponse {
        return {customers: [sampleCustomer], count: 1};
    }

    # Retrieve a customer
    #
    # + customerId - The ID of the customer
    # + return - The retrieved customer
    resource function get v2/customers/[string customerId]() returns RetrieveCustomerResponse {
        Customer customer = sampleCustomer.clone();
        customer.id = customerId;
        return {customer};
    }

    # List invoices
    #
    # + locationId - The ID of the location
    # + cursor - A pagination cursor
    # + 'limit - The maximum number of invoices to return
    # + return - The list of invoices
    resource function get v2/invoices(@http:Query {name: "location_id"} string locationId, string? cursor, int? 'limit) returns ListInvoicesResponse {
        return {invoices: [sampleInvoice]};
    }

    # Get an invoice
    #
    # + invoiceId - The ID of the invoice
    # + return - The retrieved invoice
    resource function get v2/invoices/[string invoiceId]() returns GetInvoiceResponse {
        Invoice invoice = sampleInvoice.clone();
        invoice.id = invoiceId;
        return {invoice};
    }

    # List locations
    #
    # + return - The list of locations
    resource function get v2/locations() returns ListLocationsResponse {
        return {locations: [sampleLocation]};
    }

    # Retrieve a location
    #
    # + locationId - The ID of the location
    # + return - The retrieved location
    resource function get v2/locations/[string locationId]() returns RetrieveLocationResponse {
        Location location = sampleLocation.clone();
        location.id = locationId;
        return {location};
    }

    # Retrieve an order
    #
    # + orderId - The ID of the order
    # + return - The retrieved order
    resource function get v2/orders/[string orderId]() returns RetrieveOrderResponse {
        Order 'order = sampleOrder.clone();
        'order.id = orderId;
        return {'order};
    }

    # List payments
    #
    # + beginTime - Start of the time range
    # + endTime - End of the time range
    # + sortOrder - Sort order
    # + cursor - A pagination cursor
    # + locationId - Limit results to this location
    # + total - Limit results to this total amount
    # + last4 - Limit results to cards ending in these digits
    # + cardBrand - Limit results to this card brand
    # + 'limit - The maximum number of results to return
    # + offlineBeginTime - Start of the offline payment time range
    # + offlineEndTime - End of the offline payment time range
    # + updatedAtBeginTime - Start of the update time range
    # + updatedAtEndTime - End of the update time range
    # + sortField - Sort field
    # + isOfflinePayment - Whether to return only offline payments
    # + return - The list of payments
    resource function get v2/payments(@http:Query {name: "begin_time"} string? beginTime, @http:Query {name: "end_time"} string? endTime, @http:Query {name: "sort_order"} string? sortOrder, string? cursor, @http:Query {name: "location_id"} string? locationId, int? total, @http:Query {name: "last_4"} string? last4, @http:Query {name: "card_brand"} string? cardBrand, int? 'limit, @http:Query {name: "offline_begin_time"} string? offlineBeginTime, @http:Query {name: "offline_end_time"} string? offlineEndTime, @http:Query {name: "updated_at_begin_time"} string? updatedAtBeginTime, @http:Query {name: "updated_at_end_time"} string? updatedAtEndTime, @http:Query {name: "sort_field"} ListPaymentsRequestSortField? sortField, @http:Query {name: "is_offline_payment"} boolean isOfflinePayment = false) returns ListPaymentsResponse {
        return {payments: [samplePayment]};
    }

    # Get a payment
    #
    # + paymentId - The ID of the payment
    # + return - The retrieved payment
    resource function get v2/payments/[string paymentId]() returns GetPaymentResponse {
        Payment payment = samplePayment.clone();
        payment.id = paymentId;
        return {payment};
    }

    # Create a card
    #
    # + payload - The card creation request
    # + return - The created card
    resource function post v2/cards(@http:Payload CreateCardRequest payload) returns CreateCardResponseOk {
        Card card = sampleCard.clone();
        card.cardholderName = payload.card?.cardholderName;
        card.customerId = payload.card?.customerId;
        return {body: {card}};
    }

    # Upsert a catalog object
    #
    # + payload - The upsert request
    # + return - The upserted catalog object
    resource function post v2/catalog/'object(@http:Payload UpsertCatalogObjectRequest payload) returns UpsertCatalogObjectResponseOk {
        CatalogObject catalogObject = sampleCatalogObject.clone();
        catalogObject.'type = payload.'object.'type;
        return {body: {catalogObject, idMappings: [{clientObjectId: payload.'object.id, objectId: catalogObject.id}]}};
    }

    # Create a customer
    #
    # + payload - The customer creation request
    # + return - The created customer
    resource function post v2/customers(@http:Payload CreateCustomerRequest payload) returns CreateCustomerResponseOk {
        Customer customer = sampleCustomer.clone();
        customer.givenName = payload?.givenName;
        customer.familyName = payload?.familyName;
        customer.emailAddress = payload?.emailAddress;
        return {body: {customer}};
    }

    # Search customers
    #
    # + payload - The search request
    # + return - The matching customers
    resource function post v2/customers/search(@http:Payload SearchCustomersRequest payload) returns SearchCustomersResponseOk {
        return {body: {customers: [sampleCustomer], count: 1}};
    }

    # Create an invoice
    #
    # + payload - The invoice creation request
    # + return - The created invoice
    resource function post v2/invoices(@http:Payload CreateInvoiceRequest payload) returns CreateInvoiceResponseOk {
        Invoice invoice = sampleInvoice.clone();
        invoice.locationId = payload.invoice?.locationId;
        invoice.orderId = payload.invoice?.orderId;
        return {body: {invoice}};
    }

    # Create a location
    #
    # + payload - The location creation request
    # + return - The created location
    resource function post v2/locations(@http:Payload CreateLocationRequest payload) returns CreateLocationResponseOk {
        Location location = sampleLocation.clone();
        location.name = payload.location?.name;
        return {body: {location}};
    }

    # Create an order
    #
    # + payload - The order creation request
    # + return - The created order
    resource function post v2/orders(@http:Payload CreateOrderRequest payload) returns CreateOrderResponseOk {
        Order 'order = sampleOrder.clone();
        'order.referenceId = payload.'order?.referenceId;
        return {body: {'order}};
    }

    # Search orders
    #
    # + payload - The search request
    # + return - The matching orders
    resource function post v2/orders/search(@http:Payload SearchOrdersRequest payload) returns SearchOrdersResponseOk {
        return {body: {orders: [sampleOrder]}};
    }

    # Create a payment
    #
    # + payload - The payment creation request
    # + return - The created payment
    resource function post v2/payments(@http:Payload CreatePaymentRequest payload) returns CreatePaymentResponseOk {
        Payment payment = samplePayment.clone();
        string? note = payload.note;
        if note is string {
            payment.note = note;
        }
        string? referenceId = payload.referenceId;
        if referenceId is string {
            payment.referenceId = referenceId;
        }
        return {body: {payment}};
    }

    # Cancel a payment
    #
    # + paymentId - The ID of the payment to cancel
    # + return - The canceled payment
    resource function post v2/payments/[string paymentId]/cancel() returns CancelPaymentResponseOk {
        Payment payment = samplePayment.clone();
        payment.id = paymentId;
        payment.status = "CANCELED";
        return {body: {payment}};
    }

    # Update a customer
    #
    # + customerId - The ID of the customer to update
    # + payload - The customer update request
    # + return - The updated customer
    resource function put v2/customers/[string customerId](@http:Payload UpdateCustomerRequest payload) returns UpdateCustomerResponse {
        Customer customer = sampleCustomer.clone();
        customer.id = customerId;
        customer.givenName = payload?.givenName;
        customer.familyName = payload?.familyName;
        return {customer};
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type CancelPaymentResponseOk record {|
    *http:Ok;
    CancelPaymentResponse body;
|};

public type CreateCardResponseOk record {|
    *http:Ok;
    CreateCardResponse body;
|};

public type CreateCustomerResponseOk record {|
    *http:Ok;
    CreateCustomerResponse body;
|};

public type CreateInvoiceResponseOk record {|
    *http:Ok;
    CreateInvoiceResponse body;
|};

public type CreateLocationResponseOk record {|
    *http:Ok;
    CreateLocationResponse body;
|};

public type CreateOrderResponseOk record {|
    *http:Ok;
    CreateOrderResponse body;
|};

public type CreatePaymentResponseOk record {|
    *http:Ok;
    CreatePaymentResponse body;
|};

public type SearchCustomersResponseOk record {|
    *http:Ok;
    SearchCustomersResponse body;
|};

public type SearchOrdersResponseOk record {|
    *http:Ok;
    SearchOrdersResponse body;
|};

public type UpsertCatalogObjectResponseOk record {|
    *http:Ok;
    UpsertCatalogObjectResponse body;
|};
