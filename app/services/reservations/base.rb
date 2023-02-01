module Reservations

  class Base
    include Exceptions

    def initialize(params)
      @params = params
    end

  end

end