module Services
  class SlotSummarizer
    def summarize(slots)
      return [] if slots.blank?

      selected_slots = [ slots.first ]

      slots[1..].each do |slot|
        last_selected = selected_slots.last

        if slot[:start] >= last_selected[:end]
          selected_slots << slot
        end
      end

      selected_slots
    end
  end
end
