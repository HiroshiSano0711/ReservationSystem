class ReservationsController < ApplicationController
  before_action :set_team

  def new
    @form = Forms::Reservations::SelectMenuAndStaff.new(team: @team)
  end

  def menu_select
    form = Forms::Reservations::SelectMenuAndStaff.new(menu_select_params.merge(team: @team))
    return redirect_to reservations_path, alert: form.errors.full_messages.join(",") if form.invalid?


    reservation_session.save_menu_select(form)
    redirect_to reservations_select_slots_path
  end

  def select_slots
    @service_menus = @team.service_menus.available.find(reservation_session.selected_service_menu_ids)
    @selected_staff = reservation_session.selected_staff

    # TODO: できればこの処理も予約スロット生成の一部なのでまとめたい。
    @week_range = Presenters::WeekRangeCalculator.new(
      start_date_str: params[:start_date],
      max_reservation_month: @team.team_business_setting.max_reservation_month
    ).calc

    # TODO: アルゴリズムごと書き換えるよ。O(n logn)ぐらいが理想。
    @result = Services::SlotsGenerator.new(
      team: @team,
      service_menus: @service_menus,
      start_date: @week_range.start_date,
      end_date: @week_range.end_date,
      selected_staff: @selected_staff
    ).call
  end

  def save_slot_selection
    return redirect_to reservations_select_slots_path, alert: "空き時間を1つ選択してください。" if params[:selected_slot].blank?

    reservation_session.save_slot(params[:selected_slot])
    redirect_to reservations_prior_confirmation_path
  end

  def prior_confirmation
    service_menus = @team.service_menus.find(reservation_session.selected_service_menu_ids)
    selected_staff = Staff.find_by(id: reservation_session.selected_staff_id)
    start_time = Time.zone.parse(reservation_session.selected_slot)
    @draft = Reservations::Draft.new(
      service_menus: service_menus,
      selected_staff: selected_staff,
      start_time: start_time
    )
    @form = Forms::Reservations::Finalization.new
  end

  def finalize
    service_menus = @team.service_menus.find(reservation_session.selected_service_menu_ids)
    selected_staff = Staff.find_by(id: reservation_session.selected_staff_id)
    start_time = Time.zone.parse(reservation_session.selected_slot)
    @draft = Reservations::Draft.new(
      service_menus: service_menus,
      selected_staff: selected_staff,
      start_time: start_time
    )
    @form = Forms::Reservations::Finalization.new(finalization_form_params)

    if @form.invalid?
      flash.now[:alert] = "入力内容に誤りがあります"
      return render :prior_confirmation, status: :unprocessable_content
    end

    @draft.add_profile(
      customer_name: @form.customer_name,
      customer_phone_number: @form.customer_phone_number
    )
    reservation = ::Reservation.new(
      team: @team,
      start_time: @draft.start_time,
      status: :finalized,
      customer: current_customer,
      customer_name: @draft.customer_name,
      customer_phone_number: @draft.customer_phone_number
    )

    result = Services::Reservations::Create.new(
      reservation: reservation,
      service_menus: @draft.service_menus,
      staff: @draft.selected_staff
    ).call

    if result.success?
      reservation_session.save_public_id(result.resource.public_id)

      NotificationSender.new(
        team: @team,
        reservation: result.resource,
        notification_type: :reservation_created
      ).call

      redirect_to reservations_complete_path(@team.permalink, result.resource.public_id)
    else
      flash.now[:alert] = result.message
      render :prior_confirmation, status: :unprocessable_content
    end
  end

  def complete
    @reservation = Reservation.find_by!(public_id: params[:public_id])
  end

  private

  def set_team
    @team = Team.find_by!(permalink: params[:permalink])
  end

  def reservation_session
    @reservation_session ||= Services::Reservations::SessionWrapper.new(session)
  end

  def menu_select_params
    params.require(:forms_reservations_select_menu_and_staff)
          .permit(:selected_staff, :multi_staff_menu_id, single_menu_ids: [])
  end

  def finalization_form_params
    params.require(:forms_reservations_finalization)
          .permit(:customer_name, :customer_phone_number)
  end
end
