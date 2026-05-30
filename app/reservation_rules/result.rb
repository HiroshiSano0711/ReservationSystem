module ReservationRules
  class Result
    attr_reader :errors

    def initialize
      @errors = []
    end

    def valid?
      @errors.blank?
    end

    def add_error(error)
      @errors << error
    end

    def messages
      @errors.join(", ")
    end
  end
end
