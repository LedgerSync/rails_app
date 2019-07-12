if Settings.dig(:add_ons, :sentry, :enabled) == true
  Raven.configure do |config|
    config.dsn = Settings.dig(:add_ons, :sentry, :dsn)
  end
end