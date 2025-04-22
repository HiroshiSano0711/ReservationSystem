FactoryBot.define do
  factory :service_menu_staff do
    transient do
      team { create(:team) }
    end

    service_menu { create(:service_menu, team: team) }
    staff { create(:staff, team: team) }
  end
end
