class ReservationsController < ApplicationController
  before_action :set_team

  def new
    @form = Reservations::SelectMenuAndStaffForm.new(team: @team)
  end

  def menu_select
    form = Reservations::SelectMenuAndStaffForm.new(reservations_select_menu_and_staff_form_params.merge(team: @team))
    if form.valid?
      reservation_session.selected_service_menu_ids = form.service_menu_ids || [ form.multi_staff_menu_id ]
      reservation_session.selected_staff_id = form.selected_staff

      redirect_to reservations_select_slots_path
    else
      redirect_to reservations_path, alert: form.errors.full_messages.join(",")
    end
  end

  def select_slots
    @service_menus = @team.service_menus.available.find(reservation_session.selected_service_menu_ids)
    @selected_staff = Staff.find_by(id: reservation_session.selected_staff_id) if reservation_session.selected_staff_id.present?

    calculator = Reservations::WeekRangeCalculator.new(
      start_date_str: params[:start_date],
      max_reservation_month: @team.team_business_setting.max_reservation_month
    )
    @start_date, @end_date = calculator.call
    @can_go_to_previous_week = calculator.previous_week_available?
    @can_go_to_next_week = calculator.next_week_available?

    @result = ::SlotsGenerator.new(
      team: @team,
      service_menus: @service_menus,
      start_date: @start_date,
      end_date: @end_date,
      selected_staff: @selected_staff
    ).call
  end

  def save_slot_selection
    return redirect_to reservations_select_slots_path, alert: "空き時間を1つ選択してください。" if params[:selected_slot].blank?

    reservation_session.selected_slot = params[:selected_slot]
    redirect_to reservations_prior_confirmation_path
  end

  def prior_confirmation
    @context = Reservations::FinalizationContext.new(team: @team, session: reservation_session)
    @form = Reservations::FinalizationForm.new
  end

  def finalize
    @context = Reservations::FinalizationContext.new(team: @team, session: reservation_session)
    @form = Reservations::FinalizationForm.new(reservations_finalization_form_params)

    if @form.valid?
      result = Reservations::CreateService.new(
        team: @context.team,
        service_menus: @context.service_menus,
        staff: @context.selected_staff,
        start_time: @context.start_time,
        form: @form,
        customer: current_customer
      ).call

      if result.success?
        reservation_session.clear_selection
        reservation_session.public_id = result.data.public_id
        NotificationSender.new(
          team: @team,
          reservation: result.data,
          notification_type: :reservation_created
        ).call

        redirect_to reservations_complete_path(@team.permalink, result.data.public_id)
      else
        flash.now[:alert] = result.message
        render :prior_confirmation, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "入力内容に誤りがあります。"
      render :prior_confirmation, status: :unprocessable_entity
    end
  end

  def complete
    @reservation = Reservation.find_by!(public_id: params[:public_id])
  end

  private

  def set_team
    @team = Team.find_by!(permalink: params[:permalink])
  end

  def reservations_select_menu_and_staff_form_params
    params.require(:reservations_select_menu_and_staff_form).permit(:selected_staff, :multi_staff_menu_id, service_menu_ids: [])
  end

  def reservations_finalization_form_params
    params.require(:reservations_finalization_form).permit(:customer_name, :customer_phone_number)
  end

  def reservation_session
    @reservation_session ||= Reservations::SessionData.new(session)
  end
end
