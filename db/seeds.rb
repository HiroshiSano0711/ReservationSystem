team = Team.create!(
  name: 'サンプルのサロン',
  permalink: 'sample-salon',
  description: '開発環境用'
)
puts "Created Team: #{team.name}"

team_business_setting = team.create_team_business_setting(
  max_reservation_month: 3,
  reservation_start_delay_days: 0,
  cancellation_deadline_hours_before: 24
)
puts "Created TeamBusinessSetting: #{team_business_setting}"

WeeklyBusinessHour::WDAYS.each do |wday|
  team_business_setting.weekly_business_hours.create(
    wday: wday,
    working_day: true,
    open: '09:00',
    close: '19:00'
  )
end

menus = [
  { name: 'カラー', duration: 50, price: 5000, required_staff_count: 1 },
  { name: 'カット', duration: 30, price: 4000, required_staff_count: 1 },
  { name: 'エクステ', duration: 60, price: 6000, required_staff_count: 1 }
]
menus.each do |menu|
  ServiceMenu.create!(
    team: team,
    name: menu[:name],
    duration: menu[:duration],
    price: menu[:price],
    required_staff_count: 1,
    available_from: Time.zone.now
  )
  puts "Created ServiceMenu: #{menu[:name]}"
end

admin_staff = Staff.create!(
  team: team,
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  invitation_accepted_at: Time.zone.now,
  role: 'admin_staff'
)

admin_staff.create_staff_profile!(
  working_status: 'active',
  nick_name: '管理者スタッフ',
  accepts_direct_booking: true
)

staff = Staff.create!(
  team: team,
  email: 'staff-1@example.com',
  password: 'password',
  password_confirmation: 'password',
  invitation_accepted_at: Time.zone.now,
  role: 'general'
)

staff.create_staff_profile!(
  working_status: 'active',
  nick_name: 'スタッフ1',
  accepts_direct_booking: true
)

staff_2 = Staff.create!(
  team: team,
  email: 'staff-2@example.com',
  password: 'password',
  password_confirmation: 'password',
  invitation_accepted_at: Time.zone.now,
  role: 'general'
)

staff_2.create_staff_profile!(
  working_status: 'active',
  nick_name: 'スタッフ2',
  accepts_direct_booking: true
)

ServiceMenu.all.each do |menu|
  admin_staff.service_menu_staffs.create!(service_menu: menu)
  staff.service_menu_staffs.create!(service_menu: menu)
  staff_2.service_menu_staffs.create!(service_menu: menu)
end
