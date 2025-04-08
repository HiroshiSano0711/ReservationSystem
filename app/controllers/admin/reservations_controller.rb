class Admin::ReservationsController < Admin::BaseController
  def index
    @reservations = @team.reservations.order(:date, :start_time)
  end
end
