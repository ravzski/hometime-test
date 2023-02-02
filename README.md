# Solution Explanation Part 2

### Handling Webhook

Architectural, this is how I would handle webhook

![WebhookPlan](https://i.gyazo.com/c6784b1d76dd255064a7cc9f087b7388.png)

- A route and controller will handle the ingres of data from the provider (eg. stripe)
- Save the whole params of the webhook to a model. For sample purposes, we'll call this model **WebhookPayload**
- WebhookPayload - will contain a jsonb column, processed time, and timestamps
- A Background job will then be initialize containing the ID of the webhook for processing.
- The Adanvtage of this is:
  - **Replayability** - If a webhook processing failed, the process can be reinitiated and reinvestigated
  - **Tracability** - Devs will have full transparency of the exact payload, and provide more debugging capability
  - **Scalability** - If the webhook will be bombarded with requests, It will be easier to increase the number of background workers and the scale is horizontal

### Handling New Parameters

If for example a new payment field will be introduce, this can accomodate by modifying the following

- Inside `Reservations::Mapper::Util` there is a constant named `PARENT_FIELDS `, we can easily add another string to this array to be mapped.
- What will happen here is the simplified tree will produce this:
  example we have this as input:

```
{
  "reservation": {
    "code": "XXX12345678",
    "start_date": "2021-03-12",
    "end_date": "2021-03-16",
    "payment_details": {
      "amount": "1000"
    },
    "guest_details": {
      "localized_description": "4 guests",
      "number_of_adults": "2",
      "number_of_children": "2",
      "number_of_infants": "0"
    }
  }
}
```

The simplified tree will have this:

```
{
  "parent_node": ["reservation", "payments"],
  "leaf_node": "amount",
  "value: "1000"
}

```

Given this new simplified tree, we can easily identity payment fields and associate them to Payment Model. This will also handle fields with "payment_details"

After this, the Payment fields could easily be mapped by adding a new `PAYMENT_FIELDS` inside `Reservations::Mapper::Matcher` to restrict the allowable payment fields.

### Handling Discounts

Like how we handled the addition of payments, we can easily add **Discounts** in the **PARENT_NODE** array and we have to modify the **SPECIAL_MAPPED_FIELDS** so map discount fields to the Discount Model (eg. "special_offer": "discounts" should be added to **SPECIAL_MAPPED_FIELDS**

### Searching in a unified way

Given that we have already mapped multiple payloads types into a unified Reservation model, searching by dates or any other reservation fields and/or associated tables and models can easily be done.
