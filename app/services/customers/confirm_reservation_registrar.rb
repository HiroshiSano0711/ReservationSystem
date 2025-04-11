module Customers
  class ConfirmReservationRegistrar
    attr_reader :errors

    def initialize(reservation:, phone_number:, customer_params:)
      @reservation = reservation
      @phone_number = phone_number
      @customer_params = customer_params
      @errors = []
    end

    def call
      return fail_with('登録可能な期間を過ぎています') if expired?
      return fail_with('電話番号が一致しません') unless phone_number_match?

      ActiveRecord::Base.transaction do
        @reservation.customer.update!(@customer_params)
        @reservation.customer.send_confirmation_instructions
      end

      true
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.record.errors.full_messages
      false
    end

    private

    def expired?
      @reservation.created_at < 1.day.ago
    end

    def phone_number_match?
      @reservation.customer_phone_number == @phone_number
    end

    def fail_with(message)
      @errors << message
      false
    end
  end
end
