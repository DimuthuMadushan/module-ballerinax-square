// Creates a customer, places an order for them and takes a payment against that order.

import ballerina/io;
import ballerina/uuid;
import ballerinax/square;

configurable string accessToken = ?;
configurable string locationId = ?;
configurable string paymentSourceId = ?;
configurable string customerEmail = ?;
configurable string itemName = ?;
configurable int itemPriceInCents = ?;
configurable string currencyCode = ?;
configurable string serviceUrl = "https://connect.squareupsandbox.com";

public function main() returns error? {
    square:Client squareClient = check new ({auth: {token: accessToken}}, serviceUrl);

    // Step 1: Create the customer.
    square:CreateCustomerResponse customerResponse = check squareClient->createCustomer({
        idempotencyKey: uuid:createRandomUuid(),
        givenName: "Amelia",
        familyName: "Earhart",
        emailAddress: customerEmail
    });
    string customerId = customerResponse?.customer?.id ?: "";
    if customerId == "" {
        return error("Square did not return a customer ID");
    }
    io:println("Created customer: ", customerId);

    // Step 2: Create an order for the customer.
    square:Currency currency = check currencyCode.ensureType();
    square:Money price = {amount: itemPriceInCents, currency};
    square:CreateOrderResponse orderResponse = check squareClient->createOrder({
        idempotencyKey: uuid:createRandomUuid(),
        'order: {
            locationId,
            customerId,
            lineItems: [{name: itemName, quantity: "1", basePriceMoney: price}]
        }
    });
    string orderId = orderResponse?.'order?.id ?: "";
    if orderId == "" {
        return error("Square did not return an order ID");
    }
    io:println("Created order: ", orderId);

    // Step 3: Pay for the order.
    square:CreatePaymentResponse paymentResponse = check squareClient->createPayment({
        idempotencyKey: uuid:createRandomUuid(),
        sourceId: paymentSourceId,
        amountMoney: price,
        orderId,
        customerId,
        locationId
    });
    string paymentId = paymentResponse?.payment?.id ?: "";
    if paymentId == "" {
        return error("Square did not return a payment ID");
    }

    // Step 4: Read the payment back to confirm its status.
    square:GetPaymentResponse confirmation = check squareClient->getPayment(paymentId);
    io:println("Payment ", paymentId, " status: ", confirmation?.payment?.status);
}
