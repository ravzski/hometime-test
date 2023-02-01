class Api::ReservationsController < ApplicationController


  def create
    @service = Reservation::Processor.new
    res = @service.process(params)
    if @service.errors.blank?
      render json: res
    else
      raise ServiceError
    end
  end

end