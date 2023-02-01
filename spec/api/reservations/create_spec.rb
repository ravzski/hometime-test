require 'rails_helper'

describe 'GET /api/reservations' do

  describe "#create'" do
    it "should return correct response with payload #1" do
      post "/api/reservations", params: payload_one
      expect(response).to have_http_status(:ok)
      last_reservation = Reservation.last
      expect(json_response['id']).to eq last_reservation.id
      expect(json_response['code']).to eq last_reservation.code
      expect(json_response['guest']).to_not be nil
      expect(json_response['active_status']).to_not be nil
      # TODO: add more assertions on all fields of the payload
    end

    it "should return correct response with payload #1" do
      post "/api/reservations", params: payload_one
      expect(response).to have_http_status(:ok)
      last_reservation = Reservation.last
      expect(json_response['id']).to eq last_reservation.id
      expect(json_response['code']).to eq last_reservation.code
      expect(json_response['guest']).to_not be nil
      expect(json_response['active_status']).to_not be nil
      # TODO: add more assertions on all fields of the payload
    end

    it "should return an error on invalid payload" do
      post "/api/reservations", params: {hello: "world"}
      expect(response).to have_http_status(422)
      expect(json_response['errors']).to_not be nil
      expect(json_response['errors'][0]).to eq "Invalid Request"
    end

  end

end
