class TeamBusinessSettingForm
  include ActiveModel::Model
  include ActiveModel::Naming

  attr_accessor :weekly_business_hours,
                :max_reservation_month, :reservation_start_delay_days,
                :cancellation_deadline_hours_before

  validate :validate_weekly_business_hours

  def initialize(team_business_setting:, params:)
    @team_business_setting = team_business_setting
    @weekly_business_hours_params = params[:weekly_business_hours]
    assign_attributes(params)
    @weekly_business_hours = setup_weekly_hours
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @team_business_setting.update!(
        max_reservation_month: max_reservation_month,
        reservation_start_delay_days: reservation_start_delay_days,
        cancellation_deadline_hours_before: cancellation_deadline_hours_before
      )
      @weekly_business_hours_params.each do |hour|
        update_attr = hour[1]
        weekly_business_hour = @weekly_business_hours.find { |h| h.wday == update_attr["wday"] }
        weekly_business_hour.update!(
          working_day: update_attr["working_day"].to_s === "1",
          open: update_attr["open"],
          close: update_attr["close"]
        )
      end
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def setup_weekly_hours
    WeeklyBusinessHour::WDAYS.map do |wday|
      @team_business_setting.weekly_business_hours.find_or_initialize_by(wday: wday)
    end
  end

  def validate_weekly_business_hours
    weekly_business_hours.each_with_index do |hour, idx|
      next if hour.valid?

      hour.errors.each do |attr, msg|
        errors.add("weekly_business_hours[#{idx}].#{attr}", msg)
      end
    end
  end
end
