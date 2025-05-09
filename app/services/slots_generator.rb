class SlotsGenerator
  def initialize(team:, service_menus:, start_date:, end_date:, selected_staff: nil)
    @team = team
    @business_setting = team.team_business_setting
    @start_date = start_date
    @end_date = end_date
    @service_menus = service_menus

    @slot_calculator = SlotCalculator.new(
      team: @team,
      business_setting: @business_setting,
      service_menus: @service_menus,
      selected_staff: selected_staff
    )
    @slot_summarizer = SlotSummarizer.new(service_menus: service_menus)
  end

  def call
    reservations_by_date = preload_reservations

    slots = (@start_date..@end_date).map do |date|
      if @business_setting.working_day?(date)
        slots = @slot_calculator.generate_slots_for_date(date, reservations_by_date)
        { date: date, slots: @slot_summarizer.summarize(slots) }
      else
        { date: date, slots: [] }
      end
    end

    ServiceResult.new(success: true, data: slots)
  rescue => e
    Rails.logger.error("スロット生成エラー: #{e.class} - #{e.message}")
    ServiceResult.new(success: false, message: "空き時間の取得中にエラーが発生しました。")
  end

  private

  def preload_reservations
    @team.reservations
         .select(:id, :date, :start_time, :end_time, :required_staff_count)
         .where(date: @start_date..@end_date, status: :finalize)
         .group_by(&:date)
  end
end
