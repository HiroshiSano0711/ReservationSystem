module ReservationRules
  class Result
    attr_reader :errors

    def initialize
      @errors = []
    end

    def invalid?
      @errors.present?
    end

    def add_error(error)
      @errors << error if error.present?
    end

    def messages
      @errors.join(", ")
    end
  end
end
