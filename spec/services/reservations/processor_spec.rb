require 'rails_helper'

RSpec.describe Reservations::Processor do

  describe "#process_booking" do

    context "when payload is valid" do

      it "returns a correct response for payload #1" do
        processor = Reservations::Processor.new(payload_one)
        response = processor.process_reservation()
        response.should be_a(Hash)
        response.should have_key(:guest)
        response.should have_key(:active_status)
        expect(response.values.all? { |v| !v.nil? }).to be false
      end

      it "returns a correct response for payload #2" do
        processor = Reservations::Processor.new(payload_two)
        response = processor.process_reservation()
        response.should be_a(Hash)
        response.should have_key(:guest)
        response.should have_key(:active_status)
        expect(response.values.all? { |v| !v.nil? }).to be false
      end

    end

    context "when payload is invalid" do
      it "returns a correct response for payload #2" do
        processor = Reservations::Processor.new({hello: "world"})
        response = processor.process_reservation()
        expect(response.size).to eq 1
        expect(response[0]).to eq "Invalid Request"
      end
    end

  end

end