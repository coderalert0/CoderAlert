source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'actiontext', github: 'kobaltz/actiontext', branch: 'archive', require: 'action_text'
gem 'active_storage_validations'
gem 'amazing_print'
gem 'american_date'
gem 'attr_encrypted'
gem 'aws-sdk-s3', require: false
gem 'aws-ses'
gem 'bootstrap'
gem 'bootstrap4-datetime-picker-rails'
gem 'bootstrap_form', '~> 4.5'
gem 'browser-timezone-rails'
gem 'cancancan'
gem 'carrierwave'
gem 'data-confirm-modal'
gem 'delayed_job_active_record'
gem 'devise'
gem 'devise_invitable'
gem 'dgp-schedule_attributes'
gem 'draper', '~> 4.0', '>= 4.0.1'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'faraday'
gem 'font-awesome-rails'
gem 'friendly_id'
gem 'fullcalendar-rails'
gem 'gon'
gem 'ice_cube', '~> 0.16.2'
gem 'image_processing'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'momentjs-rails'
gem 'paper_trail'
gem 'popper_js'
gem 'slack-ruby-client'
gem 'store_base_sti_class'
gem 'time_difference'
gem 'twilio-ruby'
gem 'valid_email'
gem 'webpacker'
gem 'wicked'
gem 'wisper'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rubocop'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'fuubar'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'

  gem 'rspec-rails', '~> 4.0', '>= 4.0.1'
  gem 'with_model'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
