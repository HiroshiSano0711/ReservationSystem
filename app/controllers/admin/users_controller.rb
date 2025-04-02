class Admin::UsersController < Admin::BaseController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = @team.users.build(user_params)
    @user.role = 'staff'
    if @user.save
      redirect_to admin_users_path, notice: 'スタッフを作成しました。'
    else
      flash.now[:alert] = '登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
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
      :status,
      :accepts_direct_booking,
      :bio
    )
  end
end
