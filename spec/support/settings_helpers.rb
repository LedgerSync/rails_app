# frozen_string_literal: true

module SettingsHelpers
  def deep_to_h(h = Settings.to_h)
    return h unless h.is_a?(Hash) || h.is_a?(Config::Options)

    Hash[h.map { |k, v| [k, deep_to_h(v)] }]
  end

  def settings_hash
    @settings_hash ||= deep_to_h
  end

  def with_settings(settings_changes)
    raise 'Not a hash' unless settings_changes.is_a?(Hash)

    sources = Settings.add_source!(deep_to_h.deep_merge(settings_changes))
    Settings.reload!

    yield

    sources.pop

    Settings.reload!
    nil
  end
end
