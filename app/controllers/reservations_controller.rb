class ReservationsController < ApplicationController
  before_action :set_team
  before_action :load_draft_params, only: %i[prior_confirmation finalize]

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

    reservation_session.save_slot(
      Reservations::TimeResolver.parse_str_utc_format!(time_str: params[:selected_slot])
    )
    redirect_to reservations_prior_confirmation_path
  end

  def prior_confirmation
    @draft = Reservations::Draft.build_from(team: @team, params: @draft_params)
    @form = Forms::Reservations::Finalization.new
  end

  def finalize
    @draft = Reservations::Draft.build_from(team: @team, params: @draft_params)
    @form = Forms::Reservations::Finalization.new(finalization_form_params)

    if @form.invalid?
      flash.now[:alert] = "入力内容に誤りがあります"
      return render :prior_confirmation, status: :unprocessable_content
    end

    result = UseCases::Customer::Reservations::Create.new(
      draft: @draft,
      customer: current_customer,
      customer_name: @form.customer_name,
      customer_phone_number: @form.customer_phone_number
    ).call

    if result.success?
      reservation_session.save_public_id(result.resource.public_id)
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

  def load_draft_params
    @draft_params = {
      service_menu_ids: reservation_session.selected_service_menu_ids,
      staff_id: reservation_session.selected_staff_id,
      start_time_str: reservation_session.selected_slot
    }
  end

  def menu_select_params
    params.require(Forms::Reservations::SelectMenuAndStaff.model_name.param_key.to_sym)
          .permit(Forms::Reservations::SelectMenuAndStaff::PERMITTED_PARAMS)
  end

  def finalization_form_params
    params.require(Forms::Reservations::Finalization.model_name.param_key.to_sym)
          .permit(Forms::Reservations::Finalization::PERMITTED_PARAMS)
  end
end
