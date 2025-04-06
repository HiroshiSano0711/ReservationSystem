class SlotsGenerator
  def initialize(team:, menus:, start_date:, end_date:)
    @team = team
    @menus = menus
    @start_date = start_date
    @end_date = end_date
    @business_setting = team.team_business_setting
  end

  def call
    slots = []
    current_date = @start_date

    while current_date <= @end_date
      slots << generate_slots_for_day(current_date)
      current_date += 1.day
    end

    slots
  end

  private

  def generate_slots_for_day(date)
    # 営業日であること
    # 営業開始時間より後であること
    # 予約で埋まっているスタッフを除外する
    # 各メニューのrequired_count分の担当者が空いていること
    # 
    # 予約と予約の間が合計の所要時間以上であること
    business_hours = @business_setting.send(date.strftime('%a').downcase.to_sym)
    return { date: date, slots: {} } if business_hours['working_day'] === '0'

    binding.pry
    start_time = Time.zone.parse("#{date} #{business_hours['open']}")
    end_time = Time.zone.parse("#{date} #{business_hours['close']}")

    slots = []
    # reservations = Reservation.where(date: date).order(:start_time)
    while (start_time + @interval_minutes) <= end_time
      slots << { start_time: start_time, end_time: start_time + @interval_minutes }
      start_time += @interval_minutes
    end
    { date: date, slots: slots }
  end
end
