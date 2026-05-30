module ReservationRules
  class TeamBusinessSetting
    def initialize(reservation)
      @reservation = reservation
      @team_business_setting = reservation.team.team_business_setting
    end

    def validate
      result = Result.new
      result.add_error(validate_start_time)
      result.add_error(validate_end_date)
      result
    end

    private

    def validate_start_time
      return if @reservation.start_time.blank? || @reservation.team.blank?

      possible_start_date = Time.zone.today + @team_business_setting.reservation_start_delay_days.days
      return if @reservation.start_time.to_date >= possible_start_date

      "#{possible_start_date.strftime("%Y年%m月%d日")}から受付しています"
    end

    def validate_end_date
      return if @reservation.end_time.blank? || @reservation.team.blank?

      possible_end_date = Time.zone.today + @team_business_setting.max_reservation_month.months
      return if @reservation.end_time.to_date <= possible_end_date

      "#{possible_end_date.strftime("%Y年%m月%d日")}までしか受付していません"
    end
  end
end
