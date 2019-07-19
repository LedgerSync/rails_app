# frozen_string_literal: true

require 'rails_helper'

describe 'Settings', type: :settings do
  let(:config) { Settings }

  it { expect_valid_config(config: Settings) }
  it { expect_valid_config(config: config) }

  it do
    config.merge!(application: { name: nil })
    expect_invalid_config(
      config: config,
      message: 'application.name'
    )
  end

  it do
    expect(Settings.application.name).to eq('Ledger Sync')

    with_settings(application: { name: 'foo' }) do
      expect(Settings.application.name).to eq('foo')
    end

    expect(Settings.application.name).to eq('Ledger Sync')
  end
end
