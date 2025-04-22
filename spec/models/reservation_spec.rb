require "rails_helper"

RSpec.describe Reservation, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:customer).optional }
    it { should have_many(:reservation_details).dependent(:destroy) }
    it { should have_many(:staffs).through(:reservation_details) }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values(finalize: 1, canceled: 99) }
  end

  describe "validations" do
    it { should validate_presence_of(:public_id) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:customer_name) }
    it { should validate_presence_of(:customer_phone_number) }
    it { should validate_presence_of(:total_price) }
    it { should validate_presence_of(:total_duration) }
    it { should validate_presence_of(:required_staff_count) }
    it { should validate_presence_of(:menu_summary) }
    it { should validate_presence_of(:assigned_staff_name) }
    it { should validate_presence_of(:status) }
  end

  describe "custom validations" do
    before do
      allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)
    end

    describe "#start_date_within_allowed_range" do
      it "adds an error if the start date is too early" do
        team = create(:team)
        create(:team_business_setting, team: team, reservation_start_delay_days: 1)
        reservation = build(:reservation, team: team, date: Time.zone.today)

        reservation.valid?

        expect(reservation.errors[:start_time]).to include("予約は#{team.team_business_setting.reservation_start_delay_days}日後からしか受付けられません。")
      end
    end

    describe "#end_date_within_allowed_range" do
      it "adds an error if the end date is too late" do
        team = create(:team)
        create(:team_business_setting, team: team)
        reservation = build(:reservation, team: team, date: Time.zone.today + team.team_business_setting.max_reservation_month.months + 1.day)

        reservation.valid?

        expect(reservation.errors[:start_time]).to include("予約は#{team.team_business_setting.max_reservation_month}ヶ月後までしか受付けられません。")
      end
    end

    describe "#customer_does_not_have_overlapping_reservations" do
      it "adds an error if the customer has overlapping reservations" do
        customer = create(:customer)
        team = create(:team)
        create(:team_business_setting, team: team)
        create(:reservation, team: team, customer: customer, date: Time.zone.today, start_time: "12:00", end_time: "13:00")

        new_reservation = build(:reservation, team: team, customer: customer, date: Time.zone.today, start_time: "12:30", end_time: "13:30")

        new_reservation.valid?

        expect(new_reservation.errors[:base]).to include("すでに予約している時間帯と重複しています。")
      end
    end
  end

  describe "public method" do
    before do
      allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)
    end

    describe "#cancelable?" do
      context "when the cancellation deadline has passed" do
        it "returns false" do
          allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2024-12-31 12:00:00"))

          team = create(:team)
          reservation = create(:reservation, team: team, date: FIXED_TIME.call.to_date, start_time: "12:00", end_time: "13:00")
          expect(reservation.cancelable?).to be_falsey
        end
      end

      context "when the cancellation deadline has not passed" do
        it "returns false" do
          allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2024-12-31 11:59:59"))

          team = create(:team)
          reservation = create(:reservation, team: team, date: FIXED_TIME.call.to_date, start_time: "12:00", end_time: "13:00")
          expect(reservation.cancelable?).to be_truthy
        end
      end
    end
  end
end
