module ApiExceptions
  extend ActiveSupport::Concern

  included do

    #
    # raise if a process is halted
    #
    class ServiceError < StandardError; end
    rescue_from ServiceError do
      render json: {errors: @service.errors}, status: 422
    end

  end

end