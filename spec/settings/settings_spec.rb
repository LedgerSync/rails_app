# frozen_string_literal: true

require 'rails_helper'
support :klass_helpers,
        :routing_helpers,
        :settings_helpers

describe 'settings' do
  include KlassHelpers
  include RoutingHelpers
  include SettingsHelpers

  it do
    expect(Settings.application.name).to eq('Ledger Sync')

    with_settings(application: { name: 'foo' }) do
      expect(Settings.application.name).to eq('foo')
    end

    expect(Settings.application.name).to eq('Ledger Sync')
  end
end
