class SlotSummarizer
  def initialize(service_menus:)
    @duration = service_menus.sum(&:duration).minutes
  end

  def summarize(slots)
    merge_continuous_slots(slots).flat_map do |slot|
      separate_by_duration(slot)
    end
  end

  private

  def merge_continuous_slots(slots)
    return [] if slots.blank?

    slots[1..].each_with_object([{ start: slots.first[:start], end: slots.first[:end] }]) do |slot, merged_slots|
      last_slot = merged_slots.last

      if continuous_slot?(last_slot[:end], slot[:start])
        last_slot[:end] = [last_slot[:end], slot[:end]].max
      else
        merged_slots << { start: slot[:start], end: slot[:end] }
      end
    end
  end

  def continuous_slot?(current_end, next_start)
    next_start - current_end <= @duration
  end

  def separate_by_duration(slot)
    start_time = slot[:start]
    end_time = slot[:end]

    (start_time.to_i..(end_time - @duration).to_i).step(@duration.seconds).map do |start|
      { start: Time.zone.at(start), end: Time.zone.at(start + @duration.seconds) }
    end
  end
end
