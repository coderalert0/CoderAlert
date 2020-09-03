ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# require 'capybara/email/rspec'
require 'database_cleaner'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara::Webkit.configure(&:allow_unknown_urls) if ENV['CAPYBARA_WEBKIT']

RSpec.configure do |config|
  config.fuubar_progress_bar_options = { format: 'Dont lose sight of the goal... <%B> %c/%C %P%% %E - %a' }

  config.infer_spec_type_from_file_location!
  Capybara.javascript_driver = :webkit
  Capybara.always_include_port = true
  Capybara.default_max_wait_time = 15

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = true
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # DBCleaner Setup
  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each, js: true do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.include FactoryBot::Syntax::Methods
  # config.include Features::FeatureHelpers, :type => :feature
  # config.extend Features::FeatureClassHelpers, :type => :feature
  # config.include Features::Pages, :type => :feature
  config.include Devise::TestHelpers, type: :controller
  # config.include ControllerClassHelpers, :type => :controller
  # config.include WaitForAjax, :type => :feature
  config.extend WithModel, type: :concern
  # config.include SpecHelpers

  # delete documents cached by carrierwave
  config.after(:all) do
    path = Rails.root.join('spec', 'support', 'tmp', ENV['TEST_ENV_NUMBER'] || '', 'uploads').to_s
    FileUtils.rm_rf(Dir[path])
  end
end

# override the cache dir used by Carrierwave
if defined?(CarrierWave)
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?

    klass.class_eval do
      def cache_dir
        Rails.root.join('spec', 'support', 'tmp', ENV['TEST_ENV_NUMBER'] || '', 'uploads').to_s
      end
    end
  end
end
