require 'rails_helper'

RSpec.describe Reservations::Mapper::Matcher do

  let!(:payload_two) {
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
    }.with_indifferent_access
  }

  let!(:payload_one) { 
    {
      "reservation_code": "YYY12345678",
      "start_date": "2021-04-14",
      "end_date": "2021-04-18",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "639123456789",
        "email": "wayne_woodbridge@bnb.com"
      },
      "currency": "AUD",
      "payout_price": "4200.00",
      "security_price": "500",
      "total_price": "4700.00"
    }.with_indifferent_access
  }

  let!(:mapped_result_one) {
    {
      "reservation":
        {
          "code":"YYY12345678",
          "start_date":"2021-04-14",
          "end_date":"2021-04-18",
          "nights":4,
          "adults":2,
          "children":2,
          "infants":0,
          "status":"accepted",
          "currency":"AUD",
          "payout_price":"4200.00",
          "security_price":"500",
          "total_price":"4700.00"
        },
     "guest": {
        "guests": 4,
        "first_name":"Wayne", 
        "phone_numbers": "639123456789",
        "last_name":"Woodbridge", 
        "email":"wayne_woodbridge@bnb.com"
      }
    }.with_indifferent_access
  }

  let!(:mapped_result_two) {
    {"reservation": 
      {"code": "XXX12345678",
       "start_date": "2021-03-12",
       "end_date": "2021-03-16",
       "payout_price": "3800.00",
       "security_price": "500.00",
       "currency": "AUD",
       "nights": 4,
       "status": "accepted",
       "total_price": "4300.00"},
     "guest": 
      {"localized_description": "4 guests",
       "adults": 2,
       "children": 2,
       "infants": 0,
       "email": "wayne_woodbridge@bnb.com",
       "first_name": "Wayne",
       "last_name": "Woodbridge",
       "phone_numbers": ["639123456789", "639123456789"]
      }
    }.with_indifferent_access
  }


  describe "#match_payload" do

    context "when payload is valid" do
      it "returns a simple hash" do
        params = { reservation_code: "1234567890" }
        matcher = Reservations::Mapper::Matcher.new(params)
        expect(matcher.match_payload).to be_a(Hash)
      end

      it "returns a correct params for payload #1" do
        matcher = Reservations::Mapper::Matcher.new(payload_one)
        matcher.match_payload()
        expect(matcher.result[:reservation]).to eq(mapped_result_one[:reservation])
        expect(matcher.result[:guest]).to eq(mapped_result_one[:guest])
      end

      it "returns a correct params for payload #2" do
        matcher = Reservations::Mapper::Matcher.new(payload_two)
        matcher.match_payload()
        expect(matcher.result[:reservation]).to eq(mapped_result_two[:reservation])
        expect(matcher.result[:guest]).to eq(mapped_result_two[:guest])
      end

    end

    context "when payload is invalid" do
      it "raises an exception" do
        params = {  }
        matcher = Reservations::Mapper::Matcher.new(params)
        expect(matcher.match_payload).to eq "Invalid Payload"
      end
    end

  end

end