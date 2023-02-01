module Reservations
  module Exceptions
      
    class InvalidRequestError < StandardError
      def message
        "Invalid Request"
      end
    end

  end
end