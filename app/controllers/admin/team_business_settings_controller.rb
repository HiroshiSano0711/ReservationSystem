class Admin::TeamBusinessSettingsController < Admin::BaseController
  def show
    @team_business_setting = @team.team_business_setting
  end

  def edit
    @team_business_setting = @team.team_business_setting || @team.build_team_business_setting
  end

  def update
    @team_business_setting = @team.team_business_setting

    if @team_business_setting.update(team_business_setting_params)
      redirect_to admin_team_business_setting_path(@team), notice: '営業時間情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def team_business_setting_params
    params.require(:team_business_setting).permit(
      :max_reservation_month,
      business_hours_for_day_of_week: {}
    )
  end
end
