module Services
  module Reservations
    class Create
      def initialize(reservation:, service_menus:, staff:)
        @reservation = reservation
        @service_menus = service_menus
        @staff = staff
      end

      def call
        result = ::ReservationRules::TeamBusinessSetting.new(@reservation).validate
        return Result.new(success: false, message: result.join(", ")) if result.any?

        result = ::ReservationRules::Overlapping.new(@reservation).validate
        return Result.new(success: false, message: result.join(", ")) if result.any?

        Reservation.transaction do
          @reservation.save!
          create_reservation_details!

          Result.new(success: true, resource: @reservation)
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation => e
        ::Rails.logger.error("システムエラー: NotNullViolation - #{e.message}")
        Result.new(success: false, message: "予約の処理中にエラーが発生しました。お手数ですが、もう一度お試しください。")
      end

      private

      def create_reservation_details!
        @service_menus.each do |menu|
          reservation_detail = ::ReservationDetail.create!(
            reservation: @reservation,
            service_menu: menu,
            price: menu.price,
            duration: menu.duration,
            required_staff_count: menu.required_staff_count
          )

          reservation_detail.staff_assignments.create!(staff: @staff) if @staff.present?
        end
      end
    end
  end
end
