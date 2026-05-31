module ReservationRules
  class Result
    attr_reader :errors

    def initialize
      @errors = []
    end

    def valid?
      @errors.blank?
    end

    def invalid?
      !valid?
    end

    def add_error(error)
      @errors << error if error.present?
    end

    def messages
      @errors.join(", ")
    end
  end
end
