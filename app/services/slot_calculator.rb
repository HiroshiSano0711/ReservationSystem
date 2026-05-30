class SlotCalculator
  # TODO:ユーザーの設定によって10分刻み、15分刻みかを変更できるようにしたい
  INTERVAL = 10.minutes

  # TODO:引数が多すぎるので責務過多。設計を考え直す。
  def initialize(team:, business_setting:, service_menus:, selected_staff:)
    @team = team
    @business_setting = business_setting
    @service_menus = service_menus
    @selected_staff = selected_staff
    @duration = service_menus.sum(&:duration).minutes
    @required_staff_count = service_menus.map(&:required_staff_count).max
    @available_staff_list = selected_staff.present? ? [ selected_staff ] : preload_available_staff.to_a
  end

  def generate_slots_for_date(date, reservations_by_date)
    earliest_date = Time.zone.today + @business_setting.reservation_start_delay_days

    return [] if date < earliest_date.to_date

    reservations_for_day = reservations_by_date[date] || []

    opening_hours = @business_setting.opening_hours(date)
    open_time  = opening_hours[:open]
    close_time = opening_hours[:close]

    available_counts = build_available_counts(open_time, close_time, reservations_for_day)
    extract_slots(open_time, close_time, available_counts)
  end

  private

  def preload_available_staff
    AvailableStaffQuery.new(@team).by_service_menus(@service_menus)
  end

  # 差分配列 → 累積和で各時間帯の空きスタッフ数を算出
  def build_available_counts(open_time, close_time, reservations)
    diff = Hash.new(0)

    reservations.each do |r|
      diff[r.start_time] -= r.required_staff_count || 1
      diff[r.end_time]   += r.required_staff_count || 1
    end

    # 累積和
    available = @available_staff_list.size
    result = {}
    current = open_time

    while current < close_time
      available += diff[current]
      result[current] = available
      current += INTERVAL
    end

    result
  end

  # 空きスタッフ数がrequired_staff_count以上の枠を収集
  def extract_slots(open_time, close_time, available_counts)
    slots = []
    current = open_time

    while current + @duration <= close_time
      if available_for_duration?(current, available_counts)
        slots << { start: current, end: current + @duration }
      end
      current += INTERVAL
    end

    slots
  end

  # メニュー時間分すべての区間で空きがあるか
  # TODO: Sparse Tableにして高速化する
  def available_for_duration?(start_time, available_counts)
    current = start_time
    while current < start_time + @duration
      return false if (available_counts[current] || 0) < @required_staff_count
      current += INTERVAL
    end
    true
  end
end
