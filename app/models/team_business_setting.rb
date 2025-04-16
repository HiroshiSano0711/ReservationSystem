class TeamBusinessSetting < ApplicationRecord
  belongs_to :team
  store_accessor :business_hours_for_day_of_week, :sun, :mon, :tue, :wed, :thu, :fri, :sat

  validates :sun, :mon, :tue, :wed, :thu, :fri, :sat, presence: true
  validate :validate_business_hours_format

  DAYS_OF_WEEK = %i[sun mon tue wed thu fri sat].freeze
  DAYS_OF_WEEK_KEYS = %w[working_day open close].freeze

  def working_day?(date)
    wday_setting = send(date.strftime("%a").downcase.to_sym)
    wday_setting["working_day"] === "1"
  end

  def opening_hours(date)
    wday_setting = send(date.strftime("%a").downcase.to_sym)
    {
      open: Time.zone.parse("#{date} #{wday_setting['open']}"),
      close: Time.zone.parse("#{date} #{wday_setting['close']}")
    }
  end

  def validate_business_hours_format
    return errors.add(:business_hours_for_day_of_week, "を入力してください") if business_hours_for_day_of_week.blank?

    unknown_keys = business_hours_for_day_of_week.keys.map(&:to_sym) - DAYS_OF_WEEK
    if unknown_keys.any?
      errors.add(:business_hours_for_day_of_week, "に不正なキーが含まれています: #{unknown_keys.join(', ')}")
      return
    end

    DAYS_OF_WEEK.each do |day|
      wday_setting = send(day)

      unless wday_setting.is_a?(Hash)
        errors.add(:business_hours_for_day_of_week, "の#{day}はハッシュを入力してください")
        next
      end

      unless valid_keys?(wday_setting)
        errors.add(day, "はworking_day、open、closeのキーが必要です")
        next
      end

      extra_keys = wday_setting.keys - DAYS_OF_WEEK_KEYS
      if extra_keys.any?
        errors.add(:business_hours_for_day_of_week, "の#{day}に不正なキーが含まれています: #{extra_keys.join(', ')}")
        next
      end

      errors.add(day, "のworking_dayは1か0を入力してください") unless valid_working_day?(wday_setting["working_day"])
      errors.add(day, "のopenはHH:MM形式で入力してください") unless valid_time_format?(wday_setting["open"])
      errors.add(day, "のcloseはHH:MM形式で入力してください") unless valid_time_format?(wday_setting["close"])
      errors.add(day, "のopenはcloseより前の時間を入力してください") unless open_before_close?(wday_setting["open"], wday_setting["close"])
    end
  end

  private

  def valid_keys?(setting)
    setting.is_a?(Hash) &&
      setting.key?("working_day") &&
      setting.key?("open") &&
      setting.key?("close")
  end

  def valid_working_day?(value)
    ["0", "1"].include?(value)
  end

  def valid_time_format?(time)
    time.to_s.match?(/\A([01]?[0-9]|2[0-3]):[0-5][0-9]\z/)
  end

  def open_before_close?(open_time, close_time)
    return false unless valid_time_format?(open_time) && valid_time_format?(close_time)

    Time.zone.parse(open_time) < Time.zone.parse(close_time)
  rescue ArgumentError
    false
  end
end
