module Admin
  class TeamBusinessSettingsController < Admin::BaseController
    def show
      @team_business_setting = @team.team_business_setting
      @weekly_business_hours = @team_business_setting.weekly_business_hours.order(:wday)
    end

    def edit
      @form = TeamBusinessSettingForm.new(team_business_setting: @team.team_business_setting)
    end

    def update
      @team_business_setting = @team.team_business_setting
      @form = TeamBusinessSettingForm.new(team_business_setting: @team_business_setting)
      @form.assign_attributes(form_params)
      if @form.invalid?
        flash.now[:alert] = "更新に失敗しました。"
        return render :edit, status: :unprocessable_content
      end

      result = UpdateTeamBusinessSettingService.new(
        team_business_setting: @team_business_setting,
        attributes: @form.to_service_params
      ).call

      if result.success?
        redirect_to admin_team_business_setting_path(@team), notice: "保存しました"
      else
        @form.errors.add(:base, result.message)
        flash.now[:alert] = result.message
        render :edit, status: :unprocessable_content
      end
    end

    private

    def form_params
      params.require(TeamBusinessSettingForm.model_name.param_key.to_sym)
            .permit(TeamBusinessSettingForm::PERMITTED_PARAMS)
    end
  end
end
