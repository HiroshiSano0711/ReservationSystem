# Teamを作成
team = Team.create!(
  name: "サンプルのサロン",
  permalink: 'sample',
  description: "開発環境用",
)

puts "Created Team: #{team.name}"

admin = User.create!(
  team: team,
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.now,
  role: 'admin_staff',
  nick_name: "管理者のスタッフ",
  status: 'active'
)

puts "Created Admin Staff: #{admin.nick_name}"
