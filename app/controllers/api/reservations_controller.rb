class Api::ReservationsController < ApplicationController

  # POST /api/reservations
  def create
    # allow all params because these will be filtered by the service
    @service = Reservations::Processor.new(params.permit!)
    if (res = @service.process_reservation) && @service.errors.blank?
      render json: res
    else
      raise ServiceError
    end
  end

end