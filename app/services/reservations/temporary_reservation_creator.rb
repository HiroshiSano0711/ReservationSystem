# app/services/reservations/temporary_reservation_creator.rb
module Reservations
  class TemporaryReservationCreator
    def initialize(team:, service_menus:, staff_id: nil, start_time:)
      @team = team
      @service_menus = service_menus
      @staff_id = staff_id
      @start_time = start_time
    end

    def call
      Reservation.transaction do
        public_id = generate_unique_public_id
        reservation = Reservation.create!(
          team: @team,
          date: @start_time.to_date,
          start_time: @start_time.strftime("%H:%M"),
          end_time: (@start_time + total_duration).strftime("%H:%M"),
          status: :temporary,
          public_id: public_id,
          total_price: @service_menus.sum(&:price),
          total_duration: @service_menus.sum(&:duration),
          menu_summary: @service_menus.map(&:menu_name).join(','),
          assigned_staff_names: Staff.find(@staff_id).staff_profile.nick_name,
        )

        @service_menus.each do |menu|
          ReservationDetail.create!(
            reservation: reservation,
            service_menu: menu,
            staff_id: @staff_id,
            price: menu.price,
            duration: menu.duration,
            required_staff_count: menu.required_staff_count
          )
        end

        reservation
      end
    end

    private

    def total_duration
      @service_menus.sum(&:duration).minutes
    end

    private

    def generate_unique_public_id
      max_retries = 5
      retries = 0

      loop do
        public_id = Nanoid.generate
        break public_id unless Reservation.exists?(public_id: public_id)

        retries += 1
        break if retries >= max_retries
      end
    end
  end
end
