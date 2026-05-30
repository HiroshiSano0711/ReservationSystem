module Admin
  class StaffProfilesController < Admin::BaseController
    before_action :set_staff_and_service_menus

    def edit
      @form = Forms::StaffProfile.new(staff_profile: @staff.profile)
    end

    def update
      form = Forms::StaffProfile.new(staff_profile: @staff.profile)
      form.assign_attributes(form_params)
      result = Services::UpdateStaffProfile.new(staff: @staff, form: form, service_menus: @service_menus).call
      if result.success?
        redirect_to admin_staffs_path, notice: result.message
      else
        @form = result.resource
        flash.now[:alert] = result.message
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_staff_and_service_menus
      @staff = Staff.find(params[:staff_id])
      @service_menus = @team.service_menus
    end

    def form_params
      params.require(Forms::StaffProfile.model_name.param_key.to_sym)
            .permit(Forms::StaffProfile::PERMITTED_PARAMS)
    end
  end
end
