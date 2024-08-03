# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0', '>= 7.0.2.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
# gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
# gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# gem "stimulus-rails

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0' # https://github.com/redis/redis-rb
gem 'redis-namespace' # https://github.com/resque/redis-namespace

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
gem 'nokogiri', '~> 1.13', '>= 1.13.1'

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

gem 'active_interaction', '~> 4.1'                    # https://github.com/AaronLasseigne/active_interaction
gem 'active_interaction-extras', '~> 1.0', '>= 1.0.3' # https://github.com/antulik/active_interaction-extras
gem 'activeresource'                                  # https://github.com/rails/activeresource
gem 'acts-as-taggable-on', '~> 9.0'                   # https://github.com/mbleigh/acts-as-taggable-on
gem 'appsignal'                                       # https://github.com/appsignal/appsignal-ruby
gem 'aws-sdk-mediaconvert'                            # https://github.com/aws/aws-sdk-ruby/tree/version-3/gems/aws-sdk-mediaconvert/lib/aws-sdk-mediaconvert
gem 'aws-sdk-s3', '~> 1.113'                          # https://github.com/aws/aws-sdk-ruby
gem 'faraday', '~> 1.10.0'                            # https://github.com/lostisland/faraday
gem 'jsonapi-serializer'                              # https://github.com/jsonapi-serializer/jsonapi-serializer
gem 'jwt'                                             # https://github.com/jwt/ruby-jwt
gem 'rack-cors', '~> 1.1', '>= 1.1.1'                 # https://github.com/cyu/rack-cors
gem 'sidekiq', '~> 6.5.7'                             # https://github.com/mperham/sidekiq
gem 'versionist'                                      # https://github.com/bploetz/versionist

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem

  gem 'awesome_print'               # https://github.com/awesome-print/awesome_print
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2' # https://github.com/thoughtbot/factory_bot_rails
  gem 'faker'                       # https://github.com/faker-ruby/faker
  gem 'figaro'                      # https://github.com/laserlemon/figaro
  gem 'rspec-rails'                 # https://github.com/rspec/rspec-rails
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem 'rubocop', require: false             # https://github.com/rubocop/rubocop
  gem 'rubocop-performance', require: false # https://github.com/rubocop/rubocop-performance
  gem 'rubocop-rails', require: false       # https://github.com/rubocop/rubocop-rails
  gem 'rubocop-rspec', require: false       # https://github.com/rubocop/rubocop-rspec
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  gem 'database_cleaner-active_record', '~> 2.0', '>= 2.0.1'  # https://github.com/DatabaseCleaner/database_cleaner-active_record
  gem 'fakeredis', require: 'fakeredis/rspec'                 # https://github.com/guilleiguaran/fakeredis
  gem 'jsonapi-rspec'                                         # https://github.com/jsonapi-rb/jsonapi-rspec
  gem 'shoulda-matchers', '~> 5.0'                            # https://github.com/thoughtbot/shoulda-matchers
end
