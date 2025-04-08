class Admin::ReservationsController < Admin::BaseController
  def index
    @reservations = @team.reservations
  end
end
