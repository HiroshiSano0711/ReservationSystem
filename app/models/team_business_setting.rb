class TeamBusinessSetting < ApplicationRecord
  belongs_to :team
  store_accessor :business_hours_for_day_of_week, :sun, :mon, :tue, :wed, :thu, :fri, :sat

  def working_day?(date)
    wday_setting = send(date.strftime('%a').downcase.to_sym)
    wday_setting['working_day'] == '1'
  end

  def opening_hours(date)
    wday_setting = send(date.strftime('%a').downcase.to_sym)
    {
      open: Time.zone.parse("#{date} #{wday_setting['open']}"),
      close: Time.zone.parse("#{date} #{wday_setting['close']}")
    }
  end
end
