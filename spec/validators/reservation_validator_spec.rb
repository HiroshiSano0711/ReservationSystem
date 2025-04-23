require "rails_helper"

RSpec.describe ReservationValidator, type: :validator do
  describe "#validate" do
    before do
      allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)
    end

    let(:team) { create(:team) }

    describe "#validate_start_date" do
      it "adds an error if the start date is too early" do
        create(:team_business_setting, team: team, reservation_start_delay_days: 1)
        reservation = build(:reservation, team: team, date: Time.zone.today)

        ReservationValidator.new(reservation).validate
        possible_start_date = Time.zone.today + reservation.team.team_business_setting.reservation_start_delay_days.days

        expect(reservation.errors[:start_time]).to include("は#{possible_start_date.strftime("%Y年%m月%d日")}から受付けしています")
      end
    end

    describe "#validate_end_date" do
      it "adds an error if the end date is too late" do
        create(:team_business_setting, team: team)
        reservation = build(:reservation, team: team, date: Time.zone.today + team.team_business_setting.max_reservation_month.months + 1.day)

        ReservationValidator.new(reservation).validate
        possible_end_date = Time.zone.today + reservation.team.team_business_setting.max_reservation_month.months

        expect(reservation.errors[:start_time]).to include("は#{possible_end_date.strftime("%Y年%m月%d日")}までしか受付けられません")
      end
    end

    describe "#validate_overlapping_reservations" do
      it "adds an error if the customer has overlapping reservations" do
        customer = create(:customer)
        create(:team_business_setting, team: team)
        create(:reservation, team: team, customer: customer, date: Time.zone.today, start_time: "12:00", end_time: "13:00")

        reservation = build(:reservation, team: team, customer: customer, date: Time.zone.today, start_time: "12:30", end_time: "13:30")

        ReservationValidator.new(reservation).validate

        expect(reservation.errors[:base]).to include("すでに予約している時間帯と重複しています")
      end
    end
  end
end
