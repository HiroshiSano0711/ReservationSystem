class Admin::DashboardController < Admin::BaseController
  def index
    @reservations = @team.reservations
                         .where("date = ?", Time.zone.today)
                         .order(:date, :start_time)
    @today_reservation_count = @team.reservations
                                    .where("date = ?", Time.zone.today)
                                    .count
    @current_month_sales = @team.reservations
                                .where("date >= ? AND date <= ?", Time.zone.now.beginning_of_month, Time.zone.yesterday)
                                .where(status: :finalize)
                                .sum(:total_price)
  end
end
