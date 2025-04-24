module Admin
  class StaffsController < Admin::BaseController
    def index
      @staffs = @team.staffs.includes(:staff_profile)
    end

    def new
      @staff = Staff.new
      @service_menus = @team.service_menus
    end

    def create
      @staff = @team.staffs.build(staff_params)
      ActiveRecord::Base.transaction do
        @staff.invite!
        @staff.create_staff_profile!
      end
      redirect_to admin_staffs_path, notice: "メールアドレスへ招待しました。"
    rescue
      flash.now[:alert] = "招待に失敗しました。システム管理者へご連絡ください。"
      render :new, status: :unprocessable_entity
    end

    private

    def staff_params
      params.require(:staff).permit(:email)
    end
  end
end
