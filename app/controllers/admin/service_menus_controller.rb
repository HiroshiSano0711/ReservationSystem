class Admin::ServiceMenusController < Admin::BaseController
  def index
    @service_menus = @team.service_menus
  end

  def new
    @service_menu = @team.service_menus.build
  end

  def create
    @service_menu = @team.service_menus.build(service_menu_params)
    if @service_menu.save
      redirect_to admin_service_menus_path, notice: "サービスメニューを作成しました。"
    else
      flash.now[:alert] = "登録に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @service_menu = ServiceMenu.find(params[:id])
  end

  def update
    @service_menu = ServiceMenu.find(params[:id])
    if @service_menu.update(service_menu_params)
      redirect_to admin_service_menus_path, notice: "サービスメニューを更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def service_menu_params
    params.require(:service_menu).permit(
      :menu_name,
      :duration,
      :price,
      :required_staff_count,
      :available_from,
      :available_until
    )
  end
end
