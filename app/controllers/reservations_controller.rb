class ReservationsController < ApplicationController
  def new
    @team = Team.find_by(permalink: params[:permalink])
    @menus = @team.service_menus
    @staff_profiles = StaffProfile.includes(:staff).where(
      staff_id: @team.staffs.ids,
      accepts_direct_booking: true
    )
  end

  def time_slot
    @team = Team.find_by!(permalink: params[:permalink])
    @service_menus = @team.service_menus.find(params[:menu_ids])
    @start_date, @end_date = get_week_range(@direction)
    if params[:selected_staff] === 'omakase'
      @selected_staff = @team.staffs
    else
      @selected_staff = @team.staffs.where(id: params[:selected_staff])
    end
    @slots = ::SlotsGenerator.new(
      team: @team,
      menus: @service_menus,
      start_date: @start_date,
      end_date: @end_date,
      selected_staff: @selected_staff
    ).call
  end

  private

  def get_week_range(direction)
    today = Date.today
    case direction
    when 'prev'
      start_date = today.beginning_of_week - 1.week
      end_date = today.end_of_week - 1.week
    when 'next'
      start_date = today.beginning_of_week + 1.week
      end_date = today.end_of_week + 1.week
    else
      start_date = today.beginning_of_week
      end_date = today.end_of_week
    end
    [start_date, end_date]
  end
end
