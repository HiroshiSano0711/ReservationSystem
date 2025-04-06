class Admin::StaffProfilesController < Admin::BaseController
  def edit
    @staff = Staff.find(params[:staff_id])
    @staff_profile = @staff.staff_profile
    @service_menus = @team.service_menus
  end

  def update
    @staff = Staff.find(params[:staff_id])
    @staff.staff_profile.assign_attributes(staff_profile_params)
    @staff.service_menus = @team.service_menus.where(id: service_menus_params[:ids])

    ActiveRecord::Base.transaction do
      @staff.staff_profile.save!
      @staff.save!
    end
    redirect_to admin_staffs_path, notice: 'スタッフのプロフィール情報を更新しました。'
  rescue
    @service_menus = @team.service_menus
    flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
    render :edit, status: :unprocessable_entity
  end

  private

  def staff_params
    params.require(:staff).permit(:email)
  end

  def staff_profile_params
    params.require(:staff_profile).permit(
      :working_status,
      :nick_name,
      :accepts_direct_booking,
      :bio
    )
  end

  def service_menus_params
    params.require(:service_menus).permit(ids: [])
  end
end
