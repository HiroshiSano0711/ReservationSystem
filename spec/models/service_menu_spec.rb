require 'rails_helper'

RSpec.describe ServiceMenu, type: :model do
  describe 'associations' do
    it { should belong_to(:team) }
    it { should have_many(:service_menu_staffs) }
    it { should have_many(:staffs).through(:service_menu_staffs) }
    it { should have_many(:reservation_details) }
  end

  describe 'scopes' do
    let!(:now) { fixed_time }
    let!(:team) { create(:team) }

    before { travel_to(now) }
    after { travel_back }

    it 'returns only currently available menus' do
      available_menu = create(:service_menu, team: team, available_from: now, available_until: now + 1.day)
      no_end_menu = create(:service_menu, team: team, available_from: now, available_until: nil)
      expect(ServiceMenu.available).to contain_exactly(available_menu, no_end_menu)
    end

    it 'returns only unavailable menus' do
      future_menu = create(:service_menu, team: team, available_from: now + 1.day, available_until: nil)
      past_menu = create(:service_menu, team: team, available_from: now - 2.days, available_until: now - 1.day)
      expect(ServiceMenu.unavailable).to contain_exactly(future_menu, past_menu)
    end
  end

  describe '#available?' do
    let!(:now) { fixed_time }
    let!(:team) { create(:team) }

    before { travel_to(now) }
    after { travel_back }

    it 'returns true when within availability period' do
      menu = build(:service_menu, team: team, available_from: now, available_until: now + 1.day)
      expect(menu.available?).to be true
    end

    it 'returns true when no end date and already started' do
      menu = build(:service_menu, team: team, available_from: now, available_until: nil)
      expect(menu.available?).to be true
    end

    it 'returns false when start date is in the future' do
      menu = build(:service_menu, team: team, available_from: now + 1.day)
      expect(menu.available?).to be false
    end

    it 'returns false when end date is in the past' do
      menu = build(:service_menu, team: team, available_from: now - 5.days, available_until: now - 1.day)
      expect(menu.available?).to be false
    end
  end
end
