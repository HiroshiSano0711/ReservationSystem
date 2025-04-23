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

  describe "public method" do
    before do
      allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)
    end

    let(:team) { create(:team) }

    describe "#cancelable?" do
      context "when the cancellation deadline has passed" do
        it "returns false" do
          allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2024-12-31 12:00:00"))

          reservation = create(:reservation, team: team, date: FIXED_TIME.call.to_date, start_time: "12:00", end_time: "13:00")
          expect(reservation.cancelable?).to be_falsey
        end
      end

      context "when the cancellation deadline has not passed" do
        it "returns false" do
          allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2024-12-31 11:59:59"))

          reservation = create(:reservation, team: team, date: FIXED_TIME.call.to_date, start_time: "12:00", end_time: "13:00")
          expect(reservation.cancelable?).to be_truthy
        end
      end
    end
  end
end
