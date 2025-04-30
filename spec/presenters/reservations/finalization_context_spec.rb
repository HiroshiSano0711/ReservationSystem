require "rails_helper"
require "ostruct"

RSpec.describe Reservations::FinalizationContext, type: :model do
  let(:team) { create(:team) }
  let(:staff) { create(:staff, team: team) }
  let(:service_menu1) { create(:service_menu, team: team, name: "メニューA", price: 3000, duration: 60) }
  let(:service_menu2) { create(:service_menu, team: team, name: "メニューB", price: 4000, duration: 30) }
  let(:start_time) { Time.zone.local(2025, 1, 1, 10, 0, 0) }

  let(:session) do
    OpenStruct.new(
      selected_service_menu_ids: [service_menu1.id, service_menu2.id],
      selected_staff_id: staff.id,
      selected_slot: start_time.to_s
    )
  end

  subject(:context) { described_class.new(team: team, session: session) }

  describe "#staff_name" do
    it "returns the nick_name of the selected staff" do
      create(:staff_profile, staff: staff, nick_name: "テスト太郎")

      expect(context.staff_name).to eq "テスト太郎"
    end

    it "returns 'おまかせ' if no staff is selected" do
      session.selected_staff_id = nil
      new_context = described_class.new(team: team, session: session)

      expect(new_context.staff_name).to eq "おまかせ"
    end
  end

  describe "#service_menu_list" do
    it "returns a comma separated list of service menu names" do
      expect(context.service_menu_list).to eq "メニューA, メニューB"
    end
  end

  describe "#total_price" do
    it "returns the sum of the selected service menu prices" do
      expect(context.total_price).to eq 7000
    end
  end

  describe "#total_duration" do
    it "returns the sum of the selected service menu durations" do
      expect(context.total_duration).to eq 90
    end
  end

  describe "#reservation_time_str" do
    it "returns the formatted reservation time string" do
      expect(context.reservation_time_str).to eq "2025年01月01日 10:00~11:30"
    end
  end

  describe "#end_time" do
    it "returns the calculated end time based on start time and total duration" do
      expect(context.end_time).to eq start_time + 90.minutes
    end
  end
end
