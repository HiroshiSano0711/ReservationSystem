team = Team.create!(
  name: "サンプルのサロン",
  permalink: "sample-salon",
  description: '都会の喧騒を忘れられる、落ち着いた雰囲気のプライベートサロン。 丁寧なカウンセリングを大切にし、一人ひとりの髪質やライフスタイルに合わせたスタイルをご提案します。 ナチュラルからトレンドスタイルまで幅広く対応しています。'
)
team.image.attach(
  io: File.open(Rails.root.join('app/assets/images/sample_salon.jpg')),
  filename: 'salon.jpg',
  content_type: 'image/jpeg'
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

admin_staff.create_profile!(
  working_status: 'active',
  nick_name: '店長'
)

ServiceMenu.all.each do |menu|
  admin_staff.service_menu_staffs.create!(service_menu: menu)
end

team = Team.create!(
  name: "サンプルのサロン2",
  permalink: "sample-salon-2",
  description: '都会の喧騒を忘れられる、落ち着いた雰囲気のプライベートサロン。 丁寧なカウンセリングを大切にし、一人ひとりの髪質やライフスタイルに合わせたスタイルをご提案します。 ナチュラルからトレンドスタイルまで幅広く対応しています。'
)
team.image.attach(
  io: File.open(Rails.root.join('app/assets/images/sample_salon.jpg')),
  filename: 'salon.jpg',
  content_type: 'image/jpeg'
)
puts "Created Team: #{team.name}"

team = Team.create!(
  name: "サンプルのサロン3",
  permalink: "sample-salon-3",
  description: '都会の喧騒を忘れられる、落ち着いた雰囲気のプライベートサロン。 丁寧なカウンセリングを大切にし、一人ひとりの髪質やライフスタイルに合わせたスタイルをご提案します。 ナチュラルからトレンドスタイルまで幅広く対応しています。'
)
team.image.attach(
  io: File.open(Rails.root.join('app/assets/images/sample_salon.jpg')),
  filename: 'salon.jpg',
  content_type: 'image/jpeg'
)
puts "Created Team: #{team.name}"
