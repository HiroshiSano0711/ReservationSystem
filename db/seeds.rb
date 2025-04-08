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

menus = [
  { name: 'カラー', duration: 50, price: 5000, required_staff_count: 1 },
  { name: 'カット', duration: 30, price: 4000, required_staff_count: 1 },
  { name: 'エクステ', duration: 60, price: 6000, required_staff_count: 1 }
]
menus.each do |menu|
  ServiceMenu.create!(
    team: team,
    menu_name: menu[:name],
    duration: menu[:duration],
    price: menu[:price],
    required_staff_count: 1,
    available_from: Time.zone.now
  )
end

admin_staff = Staff.create!(
  team: team,
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now,
  invitation_accepted_at: Time.now,
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
  confirmed_at: Time.now,
  invitation_accepted_at: Time.now,
  role: 'staff'
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
  confirmed_at: Time.now,
  invitation_accepted_at: Time.now,
  role: 'staff'
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

customer = Customer.create
customer.create_customer_profile(name:'顧客1', phone_number: '09011112222')
reservation = Reservation.create!(
  team: team,
  customer: customer,
  date: Date.current.tomorrow,
  start_time: '10:00',
  end_time: '11:20',
  public_id: 'yoyaku-id',
  total_price: 9000,
  total_duration: 70
)

menu = ServiceMenu.find_by(menu_name: 'カット')
ReservationDetail.create!(
  reservation: reservation,
  staff: staff,
  service_menu: menu,
  menu_name: menu.menu_name,
  price: menu.price,
  duration: menu.duration,
  required_staff_count: menu.required_staff_count
)
menu = ServiceMenu.find_by(menu_name: 'カラー')
ReservationDetail.create!(
  reservation: reservation,
  staff: staff,
  service_menu: menu,
  menu_name: menu.menu_name,
  price: menu.price,
  duration: menu.duration,
  required_staff_count: menu.required_staff_count
)
