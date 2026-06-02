module UseCases
  module Customer
    module Reservations
      class Create
        def initialize(
                        draft:,
                        customer:,
                        customer_name:,
                        customer_phone_number:
                       )
          @draft = draft
          @customer = customer
          @customer_name = customer_name
          @customer_phone_number = customer_phone_number
        end

        def call
          reservation = build_reservation
          result = create_reservation(reservation)
          return result unless result.success?

          notify(result.resource)
          result
        end

        private

        def build_reservation
          ::Reservation.new(
            team: @draft.team,
            start_time: @draft.start_time,
            end_time: @draft.end_time,
            status: :finalized,
            customer: @customer,
            customer_name: @customer_name,
            customer_phone_number: @customer_phone_number,
            total_price: @draft.total_price,
            total_duration: @draft.total_duration,
            required_staff_count: @draft.required_staff_count,
            menu_summary: @draft.menu_summary,
            assigned_staff_name: @draft.assigned_staff_name
          )
        end

        def create_reservation(reservation)
          ::Services::Reservations::Create.new(
            reservation: reservation,
            service_menus: @draft.service_menus,
            staff: @draft.staff
          ).call
        end

        def notify(reservation)
          ::NotificationSender.new(
            team: reservation.team,
            reservation: reservation,
            notification_type: :reservation_created
          ).call
        end
      end
    end
  end
end
