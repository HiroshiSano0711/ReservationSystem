module Admin
  class TeamBusinessSettingsController < Admin::BaseController
    def show
      @team_business_setting = @team.team_business_setting
      @weekly_business_hours = @team_business_setting.weekly_business_hours.order(:wday)
    end

    def edit
      @form = form_class.new(@team.team_business_setting)
    end

    def update
      @form = form_class.new(@team.team_business_setting)
      @form.assign_attributes(form_params)

      if @form.save
        redirect_to admin_team_business_setting_path(@team), notice: "保存しました"
      else
        flash.now[:alert] = "更新に失敗しました。入力内容をご確認ください"
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def form_params
      params.require(form_class.model_name.param_key.to_sym).permit(
        :max_reservation_month,
        :reservation_start_delay_days,
        :cancellation_deadline_hours_before,
        weekly_business_hours_params: [
          :id, :wday, :working_day, :open, :close
        ]
      )
    end

    def form_class
      TeamBusinessSettingForm
    end
  end
end
