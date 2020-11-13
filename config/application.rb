require_relative 'boot'

require 'rails/all'
require 'factory_bot_rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CoderAlert
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.factory_bot.definition_file_paths = ["spec/factories"]

    config.assets.paths << Rails.root.join("assets", "fonts")
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

    config.action_mailer.perform_deliveries = true

    # Don't care if the mailer can't send.
    config.action_mailer.raise_delivery_errors = true

    config.action_mailer.perform_caching = false

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        port: 587,
        address: 'email-smtp.us-east-2.amazonaws.com',
        user_name: Rails.application.credentials.dig(:aws, :ses_username),
        password: Rails.application.credentials.dig(:aws, :ses_password),
        authentication: :login,
        enable_starttls_auto: true
    }

    config.active_job.queue_adapter = :delayed_job

    config.to_prepare do
      Devise::InvitationsController.layout proc{ |controller| user_signed_in? ? 'application' : 'devise' }
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? 'application' : 'devise' }
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
