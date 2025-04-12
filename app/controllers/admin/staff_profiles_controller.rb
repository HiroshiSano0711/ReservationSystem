class Admin::StaffProfilesController < Admin::BaseController
  def edit
    @staff = Staff.find(params[:staff_id])
    @service_menus = @team.service_menus
  
    @form = StaffProfileForm.new(
      staff: @staff,
      staff_profile: @staff.staff_profile,
      team_service_menus: @service_menus,
      params: {
        working_status: @staff.staff_profile.working_status,
        nick_name: @staff.staff_profile.nick_name,
        accepts_direct_booking: @staff.staff_profile.accepts_direct_booking,
        bio: @staff.staff_profile.bio,
        selected_service_menu_ids: @staff.service_menu_ids
      }
    )
  end

  def update
    @staff = Staff.find(params[:staff_id])
    @service_menus = @team.service_menus
  
    @form = StaffProfileForm.new(
      staff: @staff,
      staff_profile: @staff.staff_profile,
      team_service_menus: @service_menus,
      params: staff_profile_form_params
    )

    if @form.save
      redirect_to admin_staffs_path, notice: 'スタッフのプロフィール情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def staff_profile_form_params
    params.require(:staff_profile_form).permit(
      :working_status,
      :nick_name,
      :accepts_direct_booking,
      :bio,
      selected_service_menu_ids: []
    )
  end
end
