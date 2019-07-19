# frozen_string_literal: true

module SettingsHelpers
  def expect_invalid_config(config:, message: [])
    val = config.validate!
    raise "Config did not raise an error and returned: #{val.inspect}"
  rescue StandardError => e
    expect(e).to be_a(Config::Validation::Error)
    message = [] unless message.is_a?(Array)
    message.each { |msg| expect(e.message).to include(msg) } if message.present?
  end

  def expect_valid_config(config:)
    expect(config.validate!).to be_nil
  end

  def deep_to_h(h = Settings.to_h)
    return h unless h.is_a?(Hash) || h.is_a?(Config::Options)

    Hash[h.map { |k, v| [k, deep_to_h(v)] }]
  end

  def settings_hash
    @settings_hash ||= deep_to_h
  end

  def with_settings(settings_changes)
    raise 'Not a hash' unless settings_changes.is_a?(Hash)

    Settings.merge!(settings_changes)

    yield

    Settings.reload!
    nil
  end
end
