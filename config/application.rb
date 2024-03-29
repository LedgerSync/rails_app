# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LedgerSyncApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_job.queue_adapter = :sidekiq

    url_options = { host: Settings.application.host_url }
    url_options[:port] = Settings.application.host_port if Settings.application.host_port.present?

    config.default_url_options = url_options
    config.action_mailer.default_url_options = url_options
    Rails.application.routes.default_url_options = url_options

    config.action_mailer.delivery_method = Settings.mailer.delivery_method.to_sym

    case config.action_mailer.delivery_method
    when :smtp
      config.action_mailer.smtp_settings = {
        address: Settings.dig(:mailer, :smtp, :address),
        port: Settings.dig(:mailer, :smtp, :port),
        user_name: Settings.dig(:mailer, :smtp, :user_name),
        password: Settings.dig(:mailer, :smtp, :password),
        authentication: Settings.dig(:mailer, :smtp, :authentication),
        enable_starttls_auto: true
       }
    end
  end
end
