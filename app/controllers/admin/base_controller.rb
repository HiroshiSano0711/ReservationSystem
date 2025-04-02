class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :find_team

  layout 'admin'

  private

  def check_admin
    unless current_user.admin_staff?
      redirect_to customer_root_path, alert: '管理者権限がありません。'
    end
  end

  def find_team
    @team = current_user.team
  end
end
