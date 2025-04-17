class Admin::TeamBusinessSettingsController < Admin::BaseController
  def show
    @team_business_setting = @team.team_business_setting
    @weekly_business_hours = @team_business_setting.weekly_business_hours.order(:wday)
  end

  def edit
    @form = TeamBusinessSettingForm.new(
      team_business_setting: @team.team_business_setting,
      params: {
        max_reservation_month: @team.team_business_setting.max_reservation_month,
        reservation_start_delay_days: @team.team_business_setting.reservation_start_delay_days,
        cancellation_deadline_hours_before: @team.team_business_setting.cancellation_deadline_hours_before
      }
    )
  end

  def update
    @form = TeamBusinessSettingForm.new(
      team_business_setting: @team.team_business_setting,
      params: team_business_setting_form_params
    )
    if @form.save
      redirect_to admin_team_business_setting_path(@team), notice: "保存しました"
    else
      flash.now[:alert] = "更新に失敗しました。入力内容をご確認ください"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def team_business_setting_form_params
    params.require(:team_business_setting_form).permit(
      :max_reservation_month,
      :reservation_start_delay_days,
      :cancellation_deadline_hours_before,
      weekly_business_hours: [
        :id, :wday, :working_day, :open, :close
      ]
    )
  end
end
