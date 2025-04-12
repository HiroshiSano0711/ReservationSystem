class Admin::DashboardController < Admin::BaseController
  def index
    @reservations = @team.reservations
                         .where('date = ?', Date.today)
                         .order(:date, :start_time)
    @today_reservation_count = @team.reservations
                                    .where('date = ?', Date.today)
                                    .count
    @current_month_sales = @team.reservations
                                .where('date >= ? AND date <= ?', Time.now.beginning_of_month, Date.today)
                                .where(status: :finalize)
                                .sum(:total_price)
  end
end
