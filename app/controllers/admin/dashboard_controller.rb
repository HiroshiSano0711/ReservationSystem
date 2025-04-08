class Admin::DashboardController < Admin::BaseController
  def index
    @reservations = @team.reservations
                         .where('date >= ?', Time.now)
                         .order(:date, :start_time)
  end
end
