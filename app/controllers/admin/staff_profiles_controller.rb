module Admin
  class StaffProfilesController < Admin::BaseController
    def edit
      @staff = Staff.find(params[:staff_id])
      @service_menus = @team.service_menus
      @form = form_class.new(staff_profile: @staff.staff_profile, service_menus: @service_menus)
    end

    def update
      @staff = Staff.find(params[:staff_id])
      @service_menus = @team.service_menus
      @form = form_class.new(staff_profile: @staff.staff_profile, service_menus: @service_menus)
      @form.assign_attributes(form_params)

      if @form.save
        redirect_to admin_staffs_path, notice: "スタッフのプロフィール情報を更新しました。"
      else
        flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def form_params
      params.require(form_class.model_name.param_key.to_sym).permit(
        :image,
        :working_status,
        :nick_name,
        :accepts_direct_booking,
        :bio,
        selected_service_menu_ids: []
      )
    end

    def form_class
      StaffProfileForm
    end
  end
end
