module Services
  class UpdateTeamBusinessSetting
    def initialize(team_business_setting:, attributes:)
      @team_business_setting = team_business_setting
      @attributes = attributes
    end

    def call
      ::ActiveRecord::Base.transaction do
        save_team_business_setting!
        save_weekly_business_hours!
      end

      Result.new(success: true, resource: nil, message: I18n.t("services.update_team_business_setting_service.success"))
    rescue ::ActiveRecord::RecordInvalid,
           ::ActiveRecord::NotNullViolation,
           ::ActiveRecord::RecordNotUnique => e
      ::Rails.logger.error("#{self.class} save failed: #{e.message}")

      failure_result
    end

    private

    def save_team_business_setting!
      @team_business_setting.update!(
        max_reservation_month: @attributes[:max_reservation_month],
        reservation_start_delay_days: @attributes[:reservation_start_delay_days],
        cancellation_deadline_hours_before: @attributes[:cancellation_deadline_hours_before]
      )
    end

    def save_weekly_business_hours!
      return if @attributes[:weekly_business_hours_params].blank?

      weekly_business_hours = @team_business_setting.weekly_business_hours.index_by(&:wday)

      @attributes[:weekly_business_hours_params].each do |_, hour_param|
        weekly_business_hour = weekly_business_hours[hour_param["wday"]]
        weekly_business_hour.update!(
          working_day: hour_param["working_day"].to_s == "1",
          open: hour_param["open"],
          close: hour_param["close"]
        )
      end
    end

    def failure_result
      Result.new(success: false, resource: nil, message: ::I18n.t("services.update_team_business_setting_service.failure"))
    end
  end
end
