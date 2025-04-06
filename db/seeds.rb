team = Team.create!(
  name: 'サンプルのサロン',
  permalink: 'sample-salon',
  description: '開発環境用'
)
puts "Created Team: #{team.name}"

team_business_setting = team.create_team_business_setting(
  business_hours_for_day_of_week: {
    'sun': { 'working_day': '1', 'open': '09:00', 'close': '19:00' },
    'mon': { 'working_day': '1', 'open': '09:00', 'close': '19:00' },
    'tue': { 'working_day': '1', 'open': '09:00', 'close': '19:00' },
    'wed': { 'working_day': '1', 'open': '09:00', 'close': '19:00' },
    'thu': { 'working_day': '1', 'open': '09:00', 'close': '19:00' },
    'fri': { 'working_day': '1', 'open': '09:00', 'close': '19:00' },
    'sat': { 'working_day': '1', 'open': '09:00', 'close': '19:00' }
  },
  max_reservation_month: '3'
)
puts "Created TeamBusinessSetting: #{team_business_setting.business_hours_for_day_of_week}"

ServiceMenu.create!(
  team: team,
  menu_name: 'カラー',
  duration: 40,
  price: 5000,
  required_staff_count: 1
)
ServiceMenu.create!(
  team: team,
  menu_name: 'カット',
  duration: 30,
  price: 4000,
  required_staff_count: 1
)
ServiceMenu.create!(
  team: team,
  menu_name: 'エクステ',
  duration: 60,
  price: 6000,
  required_staff_count: 1
)


admin_staff = Staff.create!(
  team: team,
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now,
  invitation_accepted_at: Time.now,
  role: 'admin_staff'
)

staff_profile = admin_staff.create_staff_profile!(
  working_status: 'active',
  nick_name: '管理者のスタッフ',
  accepts_direct_booking: true
)
puts "Created Admin Staff: #{staff_profile.nick_name}"
