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

      if staff_params[:email].match? URI::MailTo::EMAIL_REGEXP
        @staff.invite!
        redirect_to admin_staffs_path, notice: "メールアドレスへ招待しました。"
      else
        flash[:alert] = "無効なメールアドレスです。"
        render :new, status: :unprocessable_entity
      end
    end

    private

    def staff_params
      params.require(:staff).permit(:email)
    end
  end
end
