class TeamBusinessSettingForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :max_reservation_month, :integer
  attribute :reservation_start_delay_days, :integer
  attribute :cancellation_deadline_hours_before, :integer

  attr_accessor :weekly_business_hours

  validate :validate_weekly_business_hours

  MODEL_ATTR_MAP = {
    team_business_setting: %i[max_reservation_month reservation_start_delay_days cancellation_deadline_hours_before],
    weekly_business_hour: %i[open close working_day]
  }.freeze

  def initialize(team_business_setting)
    @team_business_setting = team_business_setting
    @weekly_business_hours = team_business_setting.weekly_business_hours

    super(
      max_reservation_month: team_business_setting.max_reservation_month,
      reservation_start_delay_days: team_business_setting.reservation_start_delay_days,
      cancellation_deadline_hours_before: team_business_setting.cancellation_deadline_hours_before
    )
  end

  def model_class_for(attr)
    case
    when MODEL_ATTR_MAP[:team_business_setting].include?(attr)
      TeamBusinessSetting
    when MODEL_ATTR_MAP[:weekly_business_hour].include?(attr)
      WeeklyBusinessHour
    end
  end

  def nested_param_key
    "#{model_name.param_key}[weekly_business_hours]"
  end

  def save(params)
    assign_attributes(params.except(:weekly_business_hours))

    return false unless valid?

    ActiveRecord::Base.transaction do
      save_team_business_setting!
      save_weekly_business_hours!(params[:weekly_business_hours])
    end

    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation, ActiveRecord::RecordNotUnique => e
    Rails.logger.error("#{self.model_name} save failed: #{e.message}")
    false
  end

  private

  def validate_weekly_business_hours
    weekly_business_hours.each_with_index do |hour, idx|
      next if hour.valid?

      hour.errors.each do |attr, msg|
        errors.add("weekly_business_hours[#{idx}].#{attr}", msg)
      end
    end
  end

  def save_team_business_setting!
    @team_business_setting.update!(
      max_reservation_month: max_reservation_month,
      reservation_start_delay_days: reservation_start_delay_days,
      cancellation_deadline_hours_before: cancellation_deadline_hours_before
    )
  end

  def save_weekly_business_hours!(params)
    params.each do |_, hour_param|
      weekly_business_hour = @weekly_business_hours.find { |wbh| wdh.wday == hour_param["wday"] }
      weekly_business_hour.update!(
        working_day: hour_param["working_day"].to_s === "1",
        open: hour_param["open"],
        close: hour_param["close"]
      )
    end
  end
end
