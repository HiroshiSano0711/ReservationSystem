module Services; end
module Queries; end
module Forms; end
module Presenters; end
module ReservationRules; end

Rails.autoloaders.main.push_dir(
  "#{Rails.root}/app/services",
  namespace: Services
)

Rails.autoloaders.main.push_dir(
  "#{Rails.root}/app/queries",
  namespace: Queries
)

Rails.autoloaders.main.push_dir(
  "#{Rails.root}/app/forms",
  namespace: Forms
)

Rails.autoloaders.main.push_dir(
  "#{Rails.root}/app/presenters",
  namespace: Presenters
)

Rails.autoloaders.main.push_dir(
  "#{Rails.root}/app/reservation_rules",
  namespace: ReservationRules
)
