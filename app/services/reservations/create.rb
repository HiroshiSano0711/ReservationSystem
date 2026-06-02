module Services
  module Reservations
    class Create
      def initialize(reservation:, service_menus:, staff:)
        @reservation = reservation
        @service_menus = service_menus
        @staff = staff
      end

      def call
        errors = validate_rules
        return Result.new(success: false, message: errors.join(", ")) if errors.any?

        Reservation.transaction do
          insert_reservation_with_public_id
          insert_reservation_details_and_assign_staff!

          Result.new(success: true, resource: @reservation)
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation => e
        ::Rails.logger.error("システムエラー: #{e.message}")
        Result.new(success: false, message: "システムエラーが発生しました。お手数ですが管理者へお問い合わせください。")
      end

      private

      def validate_rules
        ::Reservations::CreateRule.new(reservation: @reservation).call
      end

      def insert_reservation_with_public_id
        @reservation.public_id = Nanoid.generate
        @reservation.save!
      end

      def insert_reservation_details_and_assign_staff!
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
