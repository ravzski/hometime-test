module Reservations
  module Mapper
    module Exceptions
        
      class InvalidPayload < StandardError
        def message
          "Invalid Payload"
        end
      end

    end
  end
end