class Admin::StaffProfilesController < Admin::BaseController
  def index
  end

  def new
    @staff = Staff.new
    @service_menus = @team.service_menus
  end

  def create
    @staff = @team.staffs.build(staff_params)
    @service_menus = @team.service_menus.find(service_menus_params[:ids].compact_blank)
    @staff.service_menus << @service_menus

    if @staff.save
      redirect_to admin_staffs_path, notice: 'スタッフを作成しました。'
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
    @service_menus = @team.service_menus.where(id: service_menus_params[:ids])
    @staff.service_menus = @service_menus

    if @staff.update(staff_params)
      redirect_to admin_staffs_path, notice: 'スタッフ情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def staff_params
    params.require(:staff).permit(
      :nick_name,
      :accepts_direct_booking,
      :bio
    )
  end

  def service_menus_params
    params.require(:service_menus).permit(ids: [])
  end
end
