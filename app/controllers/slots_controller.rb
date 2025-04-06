class SlotsController < ApplicationController
  def show
    @team = Team.find_by!(permalink: params[:permalink])
    @service_menus = @team.service_menus.find(params[:menu_ids])
    @start_date, @end_date = get_week_range(@direction)
    @slots = ::SlotsGenerator.new(
      team: @team,
      menus: @service_menus,
      start_date: @start_date,
      end_date: @end_date
    ).call

    render partial: "slots/show", formats: [:html]
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
