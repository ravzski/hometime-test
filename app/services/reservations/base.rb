module Reservations

  class Base
    include Exceptions

    def initialize(params)
      @mapper = Reservations::Mapper::Matcher.new(params)
    end

  end

end