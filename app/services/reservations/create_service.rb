module Reservations
  class CreateService
    def initialize(team:, service_menus:, staff: nil, start_time:, form:)
      @team = team
      @service_menus = service_menus
      @staff = staff
      @start_time = start_time
      @form = form
    end

    def call
      Reservation.transaction do
        reservation = Reservation.create!(
          team: @team,
          date: @start_time.to_date,
          # start_time: @start_time.strftime("%H:%M"),
          # end_time: (@start_time + total_duration).strftime("%H:%M"),
          status: :finalize,
          public_id: generate_unique_public_id,
          total_price: @service_menus.sum(&:price),
          total_duration: @service_menus.sum(&:duration),
          required_staff_count: @service_menus.map(&:required_staff_count).max,
          menu_summary: @service_menus.map(&:menu_name).join(","),
          assigned_staff_name: assigned_staff_name,
          customer_name: @form.customer_name,
          customer_phone_number: @form.customer_phone_number
        )

        create_reservation_details(reservation)

        reservation
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.warn("予約バリデーションエラー: #{e.message}")
      "予約内容に誤りがあります。"
    rescue ActiveRecord::NotNullViolation => e
      Rails.logger.error("システムエラー: NotNullViolation - #{e.message}")
      "予約の処理中にエラーが発生しました。お手数ですが、もう一度お試しください。"
    rescue => e
      Rails.logger.fatal("予期せぬエラー: #{e.class} - #{e.message}")
      "システムエラーが発生しました。原因を調査いたします。ご迷惑をおかけして申し訳ありません。"
    end

    private

    def total_duration
      @service_menus.sum(&:duration).minutes
    end

    private

    def generate_unique_public_id
      max_retries = 5
      max_retries.times do
        public_id = Nanoid.generate
        return public_id unless Reservation.exists?(public_id: public_id)
      end
      raise "Failed to generate unique public_id after #{max_retries} attempts"
    end

    def create_reservation_details(reservation)
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

    def assigned_staff_name
      return "おまかせ" unless @staff.present?

      @staff.staff_profile.nick_name
    end
  end
end
