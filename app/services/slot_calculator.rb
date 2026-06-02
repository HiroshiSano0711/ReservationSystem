module Services
  class SlotCalculator
    INTERNAL_STEP = 5.minutes.freeze

    # TODO: インスタンス変数をReservations::Draftからの読み出しに修正する。
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

      diff_array = build_available_counts_diff_array(open_time, close_time, reservations_for_day)
      sparse_table = build_sparse_table(diff_array)
      extract_slots(open_time, close_time, sparse_table)
    end

    private

    def preload_available_staff
      Queries::AvailableStaff.new(@team).by_service_menus(@service_menus)
    end

    def build_available_counts_diff_array(open_time, close_time, reservations)
      diff = Hash.new(0)

      reservations.each do |r|
        diff[r.start_time] -= r.required_staff_count || 1
        diff[r.end_time] += r.required_staff_count || 1
      end

      available = @available_staff_list.size
      counts = []
      current = open_time

      while current < close_time
        available += diff[current]
        counts << available
        current += INTERNAL_STEP
      end

      counts
    end

    def build_sparse_table(diff_array)
      total_slots = diff_array.size
      return if total_slots == 0

      max_power_exponent = Math.log2(total_slots).to_i
      sparse_table = Array.new(total_slots) { Array.new(max_power_exponent + 1) }

      total_slots.times { |i| sparse_table[i][0] = diff_array[i] }

      (1..max_power_exponent).each do |exponent|
        current_length = 2**exponent
        half_length    = 2**(exponent - 1)

        (0..(total_slots - current_length)).each do |start_index|
          sparse_table[start_index][exponent] = [
            sparse_table[start_index][exponent - 1],
            sparse_table[start_index + half_length][exponent - 1]
          ].min
        end
      end

      sparse_table
    end

    def extract_slots(open_time, close_time, sparse_table)
      slots = []
      current = open_time

      slot_length = (@duration / INTERNAL_STEP).to_i
      index = 0

      while current + @duration <= close_time
        left = index
        right_index = index + slot_length - 1

        min_available_staff = range_min_query(left, right_index, sparse_table)

        if min_available_staff >= @required_staff_count
          slots << { start: current, end: current + @duration }
        end

        current += INTERNAL_STEP
        index += 1
      end

      slots
    end

    def range_min_query(left_index, right_index, sparse_table)
      return 0 if left_index > right_index

      len = right_index - left_index + 1
      exponent = Math.log2(len).to_i

      [
        sparse_table[left_index][exponent],
        sparse_table[right_index - (1 << exponent) + 1][exponent]
      ].min
    end
  end
end
