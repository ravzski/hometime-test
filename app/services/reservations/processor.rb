module Reservations
  class Processor < Base

    def process_booking
      # check if booking exists
      # Reservation.find_by(code: @params[:reservation_code])
      mapped_payload = @mapper.match_payload
      raise InvalidRequestError unless mapped_payload
      raise InvalidRequestError unless mapped_payload[:code]

      Reservation.find_or_create_by(mapped_payload[:code])
    rescue ActiveRecord::RecordInvalid => e
      puts e.message
    rescue InvalidRequestError => e
      puts e.message
    end

  end
end