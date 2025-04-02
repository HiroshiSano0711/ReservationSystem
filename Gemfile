source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"

gem "stimulus-rails"

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

gem 'devise'
gem 'devise-two-factor'
gem 'devise-i18n'
gem 'nanoid'
gem 'rqrcode'

gem 'slim-rails'
gem 'dartsass-rails'

group :development, :test do
  gem 'pry-rails'
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'rspec-rails'
end
