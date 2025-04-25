class ReservationFactory
  def initialize(team:, service_menus:, staff:, start_time:, form:, customer:)
    @team = team
    @service_menus = service_menus
    @staff = staff
    @start_time = start_time
    @form = form
    @customer = customer
  end

  def build
    Reservation.new(base_attributes.merge(summary_attributes))
  end

  def base_attributes
    {
      team: @team,
      customer: @customer,
      date: @start_time.to_date,
      start_time: @start_time.strftime("%H:%M"),
      end_time: end_time.strftime("%H:%M"),
      status: :finalize,
      public_id: generate_unique_public_id,
      customer_name: customer_name,
      customer_phone_number: customer_phone_number
    }
  end

  def summary_attributes
    {
      total_price: @service_menus.sum(&:price),
      total_duration: @service_menus.sum(&:duration),
      required_staff_count: @service_menus.map(&:required_staff_count).max,
      menu_summary: @service_menus.map(&:name).join(","),
      assigned_staff_name: assigned_staff_name
    }
  end

  private

  def end_time
    @start_time + @service_menus.sum(&:duration).minutes
  end

  def assigned_staff_name
    @staff&.staff_profile&.nick_name || "おまかせ"
  end

  def generate_unique_public_id
    max_retries = 5
    max_retries.times do
      public_id = Nanoid.generate
      return public_id unless Reservation.exists?(public_id: public_id)
    end
    raise "Failed to generate unique public_id after #{max_retries} attempts"
  end

  def customer_name
    @customer&.customer_profile&.name || @form.customer_name
  end

  def customer_phone_number
    @customer&.customer_profile&.phone_number || @form.customer_phone_number
  end
end
