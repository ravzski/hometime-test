module Reservations
  class Processor < Base

    def process_reservation
      mapped_payload = @mapper.match_payload()
      raise InvalidRequestError if mapped_payload.blank? || mapped_payload['reservation']['code'].blank?
      
      Reservation.transaction do
        @reservation = Reservation.find_or_create_by(code: mapped_payload['reservation']['code'])
        @reservation.update(mapped_payload['reservation'].except(:status))

        @guest = @reservation.guest ||= @reservation.build_guest(email: mapped_payload['guest']['email'])
        @guest.update(mapped_payload['guest'])
        
        # create a new status event
        # update the reservation with the new status event
        # - remarks any reason why the status changed (not needed)
        @active_status = @reservation.reservation_status_events.create(status: mapped_payload['reservation']['status'], remarks: "status changed by...")
        @reservation.update(active_status_event_id: @active_status.id)
      end
      @reservation.attributes.merge({
        guest: @guest,
        active_status: @active_status
      }).to_h
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
    rescue InvalidRequestError => e
      @errors << e.message
    rescue ActiveRecord::RecordNotSaved => e
      @errors << e.message
    end

  end
end