require "rails_helper"

RSpec.describe ReservationRules::Overlapping, type: :model do
  describe "#validate" do
    before do
      allow(Time.zone).to receive(:today).and_return(Time.zone.local(2025, 1, 1, 9, 0, 0).to_date)
    end

    let(:team) { create(:team) }

    describe "#validate_overlapping_reservations" do
      it "adds an error if the customer has overlapping reservations" do
        customer = create(:customer)
        create(:team_business_setting, team: team)
        create(:reservation, team: team, customer: customer, start_time: Time.zone.today + 3.hours, end_time: Time.zone.today + 4.hours)

        reservation = build(:reservation, team: team, customer: customer,
          start_time: Time.zone.today + 3.hours + 30.minutes,
          end_time: Time.zone.today + 4.hours + 30.minutes
        )

        described_class.new(reservation).validate

        expect(reservation.errors[:overlapp]).to be_present
      end
    end
  end
end
