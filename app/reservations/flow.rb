module Reservations
  class Flow
    attr_reader :form, :context, :message, :reservation

    def initialize(team:, form_params:, reservation_session:, customer:)
      @team = team
      @form_params = form_params
      @reservation_session = reservation_session
      @customer = customer
      @context = Presenters::Reservations::FinalizationContext.new(
        team: team,
        session: reservation_session
      )
      @form = Forms::Reservations::Finalization.new(form_params)
    end

    def finalize
      if @form.invalid?
        return Services::Result.new(success: false, message: '入力内容に誤りがあります')
      end

      reservation = ::Reservation.new(
        team: @team,
        customer: @customer,
        start_time: @context.start_time,
        status: :finalized,
        customer_name: @form.customer_name,
        customer_phone_number: @form.customer_phone_number
      )

      result = Services::Reservations::Create.new(
        reservation: reservation,
        service_menus: @context.service_menus,
        staff: @context.selected_staff,
      ).call

      if result.success?
        @reservation_session.save_public_id(result.resource.public_id)
      end

      result
    end
  end
end
