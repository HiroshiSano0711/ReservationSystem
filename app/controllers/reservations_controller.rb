class ReservationsController < ApplicationController
  def new
    @team = Team.find_by!(permalink: params[:permalink])
    @menus = @team.service_menus.available
    @staff_profiles = StaffProfile.includes(:staff).where(
      staff_id: @team.staffs.ids,
      accepts_direct_booking: true
    )
  end

  def menu_select
    if params[:service_menus].blank?
      flash[:alert] = "メニューを1つ以上選択してください"
      return redirect_to reservations_root_path
    end

    session[:selected_service_menus] = params[:service_menus]
    session[:selected_staff] = params[:selected_staff]

    redirect_to reservations_select_slots_path
  end

  def select_slots
    @team = Team.find_by!(permalink: params[:permalink])
    @service_menus = @team.service_menus.available.find(session[:selected_service_menus])
    @selected_staff = Staff.find_by(id: session[:selected_staff]) if session[:selected_staff].present?
    @start_date, @end_date = get_week_range
    @slots = ::SlotsGenerator.new(
      team: @team,
      service_menus: @service_menus,
      start_date: @start_date,
      end_date: @end_date,
      selected_staff: @selected_staff
    ).call
  end

  def temporary
    if params[:selected_slot].blank?
      flash[:alert] = "空き時間を1つ選択してください。"
      return redirect_to reservations_select_slots_path
    end

    selected_start = Time.zone.parse(params[:selected_slot])
    service_menus = ServiceMenu.find(session[:selected_service_menus])
    team = Team.find_by!(permalink: params[:permalink])
    assigned_staff_id = session[:assigned_staff_id] || []

    reservation = Reservations::TemporaryReservationCreator.new(
      team: team,
      service_menus: service_menus,
      staff_id: assigned_staff_id,
      start_time: selected_start
    ).call

    redirect_to reservations_prior_confirmation_path(public_id: reservation.public_id)
  end

  def prior_confirmation
    @team = Team.find_by!(permalink: params[:permalink])
    @reservation = Reservation.find_by!(public_id: params[:public_id])
    @service_menus = @reservation.reservation_details.includes(:service_menu, :staff).map(&:service_menu)
  end

  def finalize
    @team = Team.find_by!(permalink: params[:permalink])
    @reservation = Reservation.find_by!(public_id: params[:public_id])
    customer = Customer.create(email: 'dummy-email@example.com')
    customer.create_customer_profile(
      name: reservation_params[:customer_name],
      phone_number: reservation_params[:customer_phone_number],
    )
    if @reservation.update(reservation_params.merge(status: :finalize, customer: customer))
      redirect_to reservations_complete_path(@team.permalink, @reservation.public_id)
    else
      flash.now[:alert] = "入力内容に誤りがあります。"
      render :prior_confirmation
    end
  end

  def complete
    @team = Team.find_by!(permalink: params[:permalink])
    @reservation = Reservation.find_by!(public_id: params[:public_id])
  end
  
  private
  
  def reservation_params
    params.require(:reservation).permit(:customer_name, :customer_phone_number)
  end

  def get_week_range
    today = Date.today
    start_date = today
    end_date = today + 1.week
    [start_date, end_date]
  end
end
