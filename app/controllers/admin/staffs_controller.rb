class Admin::StaffsController < Admin::BaseController
  def index
    @staffs = @team.staffs.includes(:service_menus, :staff_profile)
  end

  def new
    @staff = Staff.new
    @service_menus = @team.service_menus
  end

  def create
    @staff = @team.staffs.build(staff_params)
    if @staff.invite!
      @staff.create_staff_profile!
      redirect_to admin_staffs_path, notice: 'スタッフを招待しました。'
    else
      flash.now[:alert] = '招待に失敗しました。システム管理者へご連絡ください。'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def staff_params
    params.require(:staff).permit(:email)
  end
end
