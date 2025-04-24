module Reservations
  class CreateService
    def initialize(team:, service_menus:, staff: nil, start_time:, form:, customer:)
      @team = team
      @service_menus = service_menus
      @staff = staff
      @start_time = start_time
      @form = form
      @customer = customer
    end

    def call
      Reservation.transaction do
        TeamAssociationValidator.new(team: @team, objects: [ @service_menus, @staff ]).validate!

        reservation = ::ReservationFactory.new(
          team: @team,
          service_menus: @service_menus,
          staff: @staff,
          start_time: @start_time,
          form: @form,
          customer: @customer
        ).build
        reservation.save!
        create_reservation_details!(reservation)

        ::ServiceResult.new(success: true, data: reservation)
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.warn("予約バリデーションエラー: #{e.message}")
      ::ServiceResult.new(success: false, message: "予約内容に誤りがあります。")
    rescue ActiveRecord::NotNullViolation => e
      Rails.logger.error("システムエラー: NotNullViolation - #{e.message}")
      ::ServiceResult.new(success: false, message: "予約の処理中にエラーが発生しました。お手数ですが、もう一度お試しください。")
    rescue => e
      Rails.logger.fatal("予期せぬエラー: #{e.class} - #{e.message}")
      ::ServiceResult.new(success: false, message: "システムエラーが発生しました。原因を調査いたします。ご迷惑をおかけし申し訳ありません。")
    end

    private

    def create_reservation_details!(reservation)
      @service_menus.each do |menu|
        ReservationDetail.create!(
          reservation: reservation,
          service_menu: menu,
          staff: @staff,
          price: menu.price,
          duration: menu.duration,
          required_staff_count: menu.required_staff_count
        )
      end
    end
  end
end
