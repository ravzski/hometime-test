module Reservations
  module Exceptions
      
    class InvalidRequestError < StandardError
      def message
        "Invalid Promo Code"
      end
    end

  end
end