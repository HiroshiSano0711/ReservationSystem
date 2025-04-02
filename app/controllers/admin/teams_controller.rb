class Admin::TeamsController < Admin::BaseController
  def show
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to admin_team_path(@team), notice: 'チーム情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :permalink, :phone_number)
  end
end
