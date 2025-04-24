module Admin
  class BaseController < ApplicationController
    before_action :authenticate_staff!
    before_action :check_admin
    before_action :check_invitation_accepted
    before_action :find_team
    before_action :unread_notifications_count

    layout "admin"

    private

    def check_admin
      unless current_staff.admin_staff?
        return redirect_to root_path, alert: "管理者権限がありません。"
      end
    end

    def check_invitation_accepted
      if current_staff.invitation_accepted_at.blank?
        sign_out current_staff
        redirect_to new_staff_session_path, alert: "招待を承認してからログインしてください。"
      end
    end

    def find_team
      @team = current_staff.team
    end

    def unread_notifications_count
      @unread_notifications_count = Notification.where(team: @team, receiver: current_staff, is_read: false)
                                                .count
    end
  end
end
