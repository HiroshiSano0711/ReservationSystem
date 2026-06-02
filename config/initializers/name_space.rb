module Services; end
module Queries; end
module Forms; end
module Presenters; end
module Reservations; end
module UseCases; end

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
  "#{Rails.root}/app/reservations",
  namespace: Reservations
)

Rails.autoloaders.main.push_dir(
  "#{Rails.root}/app/use_cases",
  namespace: UseCases
)
