FactoryBot.define do
  factory :team_business_setting do
    team
    max_reservation_month { 3 }
    reservation_start_delay_days { 0 }
    cancellation_deadline_hours_before { 24 }
  end
end
