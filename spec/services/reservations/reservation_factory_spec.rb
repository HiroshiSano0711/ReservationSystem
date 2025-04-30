require "rails_helper"

RSpec.describe Reservations::ReservationFactory do
  def expect_common_reservation_attributes(reservation)
    expect(reservation.team).to eq(team)
    expect(reservation.date).to eq(start_time.to_date)
    expect(reservation.start_time.hour).to eq(10)
    expect(reservation.start_time.min).to eq(0)
    expect(reservation.end_time.hour).to eq(12)
    expect(reservation.end_time.min).to eq(30)
    expect(reservation.total_price).to eq(12000)
    expect(reservation.total_duration).to eq(150)
    expect(reservation.required_staff_count).to eq(2)
    expect(reservation.menu_summary).to eq("#{service_menu1.name},#{service_menu2.name}")
    expect(reservation.assigned_staff_name).to eq("山田 太郎")
    expect(reservation.public_id).to be_present
  end

  let(:team) { create(:team) }
  let(:service_menu1) { create(:service_menu, team: team, price: 5000, duration: 60, required_staff_count: 1) }
  let(:service_menu2) { create(:service_menu, team: team, price: 7000, duration: 90, required_staff_count: 2) }
  let(:service_menus) { [service_menu1, service_menu2] }
  let(:staff) { create(:staff, team: team) }
  let!(:staff_profile) { create(:staff_profile, staff: staff, nick_name: "山田 太郎") }
  let(:start_time) { Time.zone.local(2025, 5, 1, 10, 0, 0) }

  describe "#build" do
    context "when guest customer" do
      let(:form) { double("Form", customer_name: "ゲスト太郎", customer_phone_number: "090-1234-5678") }
      let(:factory) {
        described_class.new(team: team, service_menus: service_menus, staff: staff, start_time: start_time, form: form, customer: nil)
      }

      it "builds a reservation correctly" do
        reservation = factory.build
        
        expect_common_reservation_attributes(reservation)
        expect(reservation.customer).to be_nil
        expect(reservation.customer_name).to eq("ゲスト太郎")
        expect(reservation.customer_phone_number).to eq("090-1234-5678")
      end
    end

    context "when logged-in customer" do
      let(:form) { double("Form", customer_name: "鈴木 太郎", customer_phone_number: "090-1111-2222") }
      let(:customer) { create(:customer) }
      let!(:customer_profile) { create(:customer_profile, customer: customer, name: "鈴木 太郎", phone_number: "090-1111-2222") }
      let(:factory) {
        described_class.new(team: team, service_menus: service_menus, staff: staff, start_time: start_time, form: form, customer: customer)
      }

      it "builds a reservation correctly" do
        reservation = factory.build

        expect_common_reservation_attributes(reservation)
        expect(reservation.customer).to eq(customer)
        expect(reservation.customer_name).to eq("鈴木 太郎")
        expect(reservation.customer_phone_number).to eq("090-1111-2222")
      end
    end
  end
end
