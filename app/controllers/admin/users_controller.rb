class Admin::UsersController < Admin::BaseController
  def index
  end

  def new
    @user = User.new
    @service_menus = @team.service_menus
  end

  def create
    @user = @team.users.build(user_params)
    @service_menus = @team.service_menus.find(service_menus_params[:ids].compact_blank)
    @user.service_menus << @service_menus

    if @user.save
      redirect_to admin_users_path, notice: 'スタッフを作成しました。'
    else
      flash.now[:alert] = '登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
    @service_menus = @team.service_menus
  end

  def update
    @user = User.find(params[:id])
    @service_menus = @team.service_menus.where(id: service_menus_params[:ids])
    @user.service_menus = @service_menus

    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'スタッフ情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :nick_name,
      :email,
      :password,
      :status,
      :accepts_direct_booking,
      :bio
    )
  end

  def service_menus_params
    params.require(:service_menus).permit(ids: [])
  end
end
