class Admin::DashboardController < Admin::BaseController
  def index
    current_user
  end
end
