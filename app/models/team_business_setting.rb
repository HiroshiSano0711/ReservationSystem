class TeamBusinessSetting < ApplicationRecord
  belongs_to :team
  store_accessor :business_hours_for_day_of_week, :sun, :mon, :tue, :wed, :thu, :fri, :sat
end
