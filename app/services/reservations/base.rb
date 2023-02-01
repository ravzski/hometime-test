module Reservations

  class Base
    include Exceptions

    attr_reader :errors

    def initialize(params)
      @mapper = Reservations::Mapper::Matcher.new(params.to_h.except(:controller, :action))
      @errors = []
    end

  end

end