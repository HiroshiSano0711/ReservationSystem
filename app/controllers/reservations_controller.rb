class ReservationsController < ApplicationController
  def new
    @team = Team.find_by(permalink: params[:permalink])
    @menus = @team.service_menus
  end
end
