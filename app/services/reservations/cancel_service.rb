module Reservations
  class CancelService
    def initialize(reservation:, customer:)
      @reservation = reservation
      @customer = customer
    end

    def call(admin: false)
      return failure("不正な操作です") unless admin || owned_by_customer?
      return failure("キャンセル期限を過ぎています") unless admin || cancelable?

      @reservation.update!(status: :canceled)
      success(@reservation)
    rescue => e
      failure("システムエラーが発生しました: #{e.message}")
    end

    private

    def owned_by_customer?
      @reservation.customer == @customer
    end

    def cancelable?
      @reservation.cancelable?
    end

    def success(data = nil)
      ::ServiceResult.new(success: true, data: data)
    end

    def failure(message)
      ::ServiceResult.new(success: false, message: message)
    end
  end
end
