class Admin::BaseController < ApplicationController
  before_action :authenticate_staff!
  before_action :check_admin
  before_action :find_team
  before_action :unread_notifications_count

  layout "admin"

  private

  def check_admin
    unless current_staff.admin_staff?
      redirect_to root_path, alert: "管理者権限がありません。"
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
