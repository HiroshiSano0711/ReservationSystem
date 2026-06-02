module Reservations
  class CreateRule
    RULES = [
      ::Reservations::Rules::TeamBusinessSetting,
      ::Reservations::Rules::Overlapping
    ].freeze

    def initialize(reservation:)
      @reservation = reservation
    end

    def call
      RULES.map { |rule| rule.new(@reservation).validate }
           .select(&:invalid?)
           .map(&:errors)
           .flatten
    end
  end
end
