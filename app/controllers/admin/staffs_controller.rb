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
      redirect_to admin_staffs_path, notice: 'スタッフを招待しました。'
    else
      flash.now[:alert] = '登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @staff = Staff.find(params[:id])
    @service_menus = @team.service_menus
  end

  def update
    @staff = Staff.find(params[:id])
    @staff.assign_attributes(staff_params)
    @staff.staff_profile.assign_attributes(staff_profile_params)
    @service_menus = @team.service_menus.where(id: service_menus_params[:ids])
    @staff.service_menus = @service_menus

    if @staff.staff_profile.save && @staff.save
      redirect_to admin_staffs_path, notice: 'スタッフ情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def staff_params
    params.require(:staff).permit(
      :email,
      :password,
      :working_status
    )
  end

  def staff_profile_params
    params.require(:staff_profile).permit(
      :nick_name,
      :accepts_direct_booking,
      :bio
    )
  end

  def service_menus_params
    params.require(:service_menus).permit(ids: [])
  end
end
