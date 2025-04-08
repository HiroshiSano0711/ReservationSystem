class SlotsGenerator
  def initialize(team:, menus:, start_date:, end_date:)
    @team = team
    @business_setting = team.team_business_setting
    @start_date = start_date
    @end_date = end_date
    @total_duration = menus.sum(&:duration).minutes

    @slot_calculator = SlotCalculator.new(@business_setting, team.staffs.count, @total_duration)
    @slot_summarizer = SlotSummarizer.new(@total_duration)
  end

  def call
    reservations_by_date = preload_reservations

    (@start_date..@end_date).map do |date|
      if @business_setting.working_day?(date)
        slots = @slot_calculator.generate_slots_for_date(date, reservations_by_date)
        { date: date, slots: @slot_summarizer.summarize(slots) }
      else
        { date: date, slots: [] }
      end
    end
  end

  private

  def preload_reservations
    @team.reservations
         .select(:id, :date, :start_time, :end_time)
         .where(date: @start_date..@end_date)
         .group_by(&:date)
  end
end
