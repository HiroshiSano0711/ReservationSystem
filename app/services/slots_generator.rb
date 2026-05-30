module Services
  class SlotsGenerator
    def initialize(team:, service_menus:, start_date:, end_date:, selected_staff: nil)
      @team = team
      @business_setting = team.team_business_setting
      @start_date = start_date
      @end_date = end_date
      @service_menus = service_menus

      @slot_calculator = Services::SlotCalculator.new(
        team: @team,
        business_setting: @business_setting,
        service_menus: @service_menus,
        selected_staff: selected_staff
      )
      @slot_summarizer = Services::SlotSummarizer.new(service_menus: service_menus)
    end

    def call
      reservations_by_date = Queries::Reservation.new(@team).by_date_range(@start_date, @end_date)

      slots = (@start_date..@end_date).map do |date|
        if @business_setting.working_day?(date)
          slots = @slot_calculator.generate_slots_for_date(date, reservations_by_date)
          { date: date, slots: @slot_summarizer.summarize(slots) }
        else
          { date: date, slots: [] }
        end
      end

      Result.new(success: true, resource: slots)
    end
  end
end
