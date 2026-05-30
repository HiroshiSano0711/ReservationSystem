class ReservationValidator
  def initialize(reservation)
    @reservation = reservation
  end

  def validate
    validate_start_time
    validate_end_date
    validate_overlapping_reservations
  end

  private

  def validate_start_time
    return if @reservation.start_time.blank? || @reservation.team.blank?

    possible_start_date = Time.zone.today + @reservation.team.team_business_setting.reservation_start_delay_days.days
    if @reservation.start_time.to_date < possible_start_date
      @reservation.errors.add(:start_time, "は#{possible_start_date.strftime("%Y年%m月%d日")}から受付しています")
    end
  end

  def validate_end_date
    return if @reservation.end_time.blank? || @reservation.team.blank?

    possible_end_date = Time.zone.today + @reservation.team.team_business_setting.max_reservation_month.months
    if @reservation.end_time.to_date > possible_end_date
      @reservation.errors.add(:end_time, "は#{possible_end_date.strftime("%Y年%m月%d日")}までしか受付していません")
    end
  end

  def validate_overlapping_reservations
    return unless @reservation.customer_id.present?

    overlapping = ReservationQuery.new(@reservation.team).overlapping_for_customer(@reservation)

    if overlapping
      @reservation.errors.add(:overlapp, "すでに予約している時間帯と重複しています")
    end
  end
end
