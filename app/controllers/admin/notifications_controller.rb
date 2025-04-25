module Admin
  class NotificationsController < Admin::BaseController
    def index
      @notifications = @team.notifications.includes(:reservation).order(created_at: :desc)
    end

    def mark_as_read
      notification = Notification.find(params[:id])
      notification.update!(is_read: true)

      redirect_to URI.parse(notification.action_url).path
    end
  end
end
