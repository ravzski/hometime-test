# Solution Explanation

- The solution I think of focuses on scalability of the possible permutations of other payloads (not just the two given)

- It might look complex but it's straight forward

### Steps

1. Flatten the payload

```
{
  "reservation": {
    "code": "XXX12345678",
    "start_date": "2021-03-12",
    "end_date": "2021-03-16",
    "expected_payout_amount": "3800.00",
    "guest_details": {
      "localized_description": "4 guests",
      "number_of_adults": 2,
      "number_of_children": 2,
      "number_of_infants": 0
    },
    "guest_email": "wayne_woodbridge@bnb.com",
    "guest_first_name": "Wayne",
    "guest_last_name": "Woodbridge",
    "guest_phone_numbers": [
      "639123456789",
      "639123456789"
    ],
    "listing_security_price_accurate": "500.00",
    "host_currency": "AUD",
    "nights": 4,
    "number_of_guests": 4,
    "status_type": "accepted",
    "total_paid_amount_accurate": "4300.00"
  }
}
```

will be converted to

```
{
  "reservation.code": "XXX12345678",
  "reservation.start_date": "2021-03-12",
  "reservation.end_date": "2021-03-16",
  "reservation.expected_payout_amount": "3800.00",
  "reservation.guest_details.localized_description": "4 guests",
  "reservation.guest_details.number_of_adults": 2,
  "reservation.guest_details.number_of_children": 2,
  "reservation.guest_details.number_of_infants": 0,
  "reservation.guest_email": "wayne_woodbridge@bnb.com",
  "reservation.guest_first_name": "Wayne",
  "reservation.guest_last_name": "Woodbridge",
  "reservation.guest_phone_numbers": [
    "639123456789",
    "639123456789"
  ],
  "reservation.listing_security_price_accurate": "500.00",
  "reservation.host_currency": "AUD",
  "reservation.nights": 4,
  "reservation.number_of_guests": 4,
  "reservation.status_type": "accepted",
  "reservation.total_paid_amount_accurate": "4300.00"
}
```

2. Transform the flattened hash to a simplified tree

```
[
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "code",
    "value": "XXX12345678"
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "start_date",
    "value": "2021-03-12"
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "end_date",
    "value": "2021-03-16"
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "payout_price",
    "value": "3800.00"
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "localized_description",
    "value": "4 guests"
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "adults",
    "value": 2
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "children",
    "value": 2
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "infants",
    "value": 0
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "email",
    "value": "wayne_woodbridge@bnb.com"
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "first_name",
    "value": "Wayne"
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "last_name",
    "value": "Woodbridge"
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "phone_numbers",
    "value": [
      "639123456789",
      "639123456789"
    ]
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "security_price",
    "value": "500.00"
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "currency",
    "value": "AUD"
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "nights",
    "value": 4
  },
  {
    "parent_node": [
      "reservation",
      "guest"
    ],
    "leaf_node": "number_ofs",
    "value": 4
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "status",
    "value": "accepted"
  },
  {
    "parent_node": [
      "reservation"
    ],
    "leaf_node": "total_price",
    "value": "4300.00"
  }
]

```

**What happened here is:**

- For each of the leaf nodes (or last key->value) of the original hash, there exists a parent_node proprety
- In this case, parent_nodes could have either "reservation" or "guest" or both
- To determine IF the field belongs to reservation or guest, we look at the last value of the parent_node
- Meaning on a nested object, this is the last parent object of the leaf node
- I also added a Levenshtein distance check between strings to accomodate minor spelling changes (eg. first_name to firstname) so that the mapping is consistent

Special Case

- There are fields that are mapped manually
- example: **total_paid_amount_accurate** is mapped to **total_price**
- I do not want to add a heuristic function map to assiociate the meaning of two strings because it might result to different condition being inaccurate (this might be an ML problem, checking if the meaning of two strings are close within a specific threshold)

Crossovers

- I called this crossovers because these are supposed to be in the reservation but can be mapped inside guest because of how payload two handles "guest_details"
- These are the fields number_of_GUEST_TYPE (eg. number_of_adults)
- No matter what their parent_nodes hold, they will always belong to reservation

Notes

- I initially wanted to create a state machines (eg. IF status is CANCELLED, it cannot be changed to PAID etc.)
- But I guess that's not important given the specs
- I tried going for a more simple semi-mapped and hard-coded solution and this might be more efficient if we take into consider ONLY payload_one and payload_two in the example
- I added comments in the code to make it more understandable

Cheers, I had fun doing this.
