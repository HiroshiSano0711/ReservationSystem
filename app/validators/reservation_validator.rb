class ReservationValidator
  def initialize(reservation)
    @reservation = reservation
  end

  def validate
    validate_start_date
    validate_end_date
    validate_overlapping_reservations
  end

  private

  def validate_start_date
    return if @reservation.date.blank? || @reservation.team.blank?

    possible_start_date = Time.zone.today + @reservation.team.team_business_setting.reservation_start_delay_days.days
    if @reservation.date < possible_start_date
      @reservation.errors.add(:start_time, "は#{possible_start_date.strftime("%Y年%m月%d日")}から受付しています")
    end
  end

  def validate_end_date
    return if @reservation.date.blank? || @reservation.team.blank?

    possible_end_date = Time.zone.today + @reservation.team.team_business_setting.max_reservation_month.months
    if @reservation.date > possible_end_date
      @reservation.errors.add(:start_time, "は#{possible_end_date.strftime("%Y年%m月%d日")}までしか受付していません")
    end
  end

  def validate_overlapping_reservations
    return unless @reservation.customer_id.present?

    overlapping = Reservation.where(customer_id: @reservation.customer_id)
                             .where.not(id: @reservation.id)
                             .where(date: @reservation.date)
                             .where("start_time < ? AND end_time > ?", @reservation.end_time, @reservation.start_time)
                             .exists?

    if overlapping
      @reservation.errors.add(:base, "すでに予約している時間帯と重複しています")
    end
  end
end
