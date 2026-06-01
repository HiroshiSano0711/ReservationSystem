module Services
  module Reservations
    class Create
      def initialize(reservation:, service_menus:, staff:)
        @reservation = reservation
        @service_menus = service_menus
        @staff = staff
      end

      def call
        ::Reservations::Rules::TeamAssociation.new(
          team: @reservation.team,
          objects: [ @service_menus, @staff ]
        ).validate!

        result = ::Reservations::Rules::TeamBusinessSetting.new(@reservation).validate
        return Result.new(success: false, message: result.messages) if result.invalid?

        result = ::Reservations::Rules::Overlapping.new(@reservation).validate
        return Result.new(success: false, message: result.messages) if result.invalid?

        Reservation.transaction do
          @reservation.build_snapshot(
            service_menus: @service_menus,
            staff: @staff
          )
          @reservation.public_id = issue_unique_id
          @reservation.save!
          create_reservation_details!

          Result.new(success: true, resource: @reservation)
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation => e
        ::Rails.logger.error("システムエラー: #{e.message}")
        Result.new(success: false, message: "システムエラーが発生しました。お手数ですが管理者へお問い合わせください。")
      end

      private

      def issue_unique_id
        Nanoid.generate
      end

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
