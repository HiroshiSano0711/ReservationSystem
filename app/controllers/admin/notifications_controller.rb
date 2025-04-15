class Admin::NotificationsController < Admin::BaseController
  def index
    @notifications = @team.notifications.order(created_at: :desc)
  end

  def mark_as_read
    notification = Notification.find(params[:id])
    notification.update!(status: :read)
    redirect_to notification.action_url
  end
end
