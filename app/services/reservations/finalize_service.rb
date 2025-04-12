module Reservations
  class FinalizeService
    def initialize(reservation:, form:)
      @reservation = reservation
      @form = form
    end

    def call
      return false unless @form.valid?

      ActiveRecord::Base.transaction do
        @reservation.update!(
          status: :finalize,
          customer_name: @form.customer_name,
          customer_phone_number: @form.customer_phone_number
        )
      end

      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.warn("予約確定処理に失敗: #{e.message}")
      false
    end
  end
end
