# Teamを作成
team = Team.create!(
  name: 'サンプルのサロン',
  permalink: 'sample',
  description: '開発環境用',
)
puts "Created Team: #{team.name}"

team_business_setting = team.create_team_business_setting(
  business_hours_for_day_of_week: {
    'sun': { 'open': '09:00', 'close': '19:00' },
    'mon': { 'open': '09:00', 'close': '19:00' },
    'tue': { 'open': '09:00', 'close': '19:00' },
    'wed': { 'open': '09:00', 'close': '19:00' },
    'thu': { 'open': '09:00', 'close': '19:00' },
    'fri': { 'open': '09:00', 'close': '19:00' },
    'sat': { 'open': '09:00', 'close': '19:00' }
  },
  max_reservation_month: '3'
)

puts "Created TeamBusinessSetting: #{team_business_setting.business_hours_for_day_of_week}"

admin = User.create!(
  team: team,
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now,
  role: 'admin_staff',
  nick_name: '管理者のスタッフ',
  status: 'active',
  accepts_direct_booking: true
)

puts "Created Admin Staff: #{admin.nick_name}"
