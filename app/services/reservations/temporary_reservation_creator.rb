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
        reservation = Reservation.create!(
          team: @team,
          date: @start_time.to_date,
          start_time: @start_time.strftime("%H:%M"),
          end_time: (@start_time + total_duration).strftime("%H:%M"),
          status: :temporary,
          public_id: generate_unique_public_id,
          total_price: @service_menus.sum(&:price),
          total_duration: @service_menus.sum(&:duration),
          menu_summary: @service_menus.map(&:menu_name).join(','),
          assigned_staff_name: assigned_staff_name,
        )

        create_reservation_details(reservation)

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
          staff_id: @staff_id,
          price: menu.price,
          duration: menu.duration,
          required_staff_count: menu.required_staff_count
        )
      end
    end

    def assigned_staff_name
      return 'おまかせ' unless @staff_id.present?
    
      Staff.find(@staff_id).staff_profile.nick_name
    end
  end
end
