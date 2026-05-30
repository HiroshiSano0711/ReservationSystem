class ReservationQuery
  def initialize(team)
    @team = team
  end

  def by_date_range(start_date, end_date)
    @team.reservations
         .select(:id, :start_time, :end_time, :required_staff_count)
         .where(start_time: start_date.beginning_of_day..end_date.end_of_day)
         .where(status: :finalize)
         .group_by { |r| r.start_time.to_date }
  end

  def overlapping_for_customer(reservation)
    Reservation.where(customer_id: reservation.customer_id)
               .where.not(id: reservation.id)
               .where("start_time < ? AND end_time > ?", reservation.end_time, reservation.start_time)
               .exists?

  end
end
