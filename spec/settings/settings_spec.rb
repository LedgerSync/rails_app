# frozen_string_literal: true

require 'rails_helper'

describe 'Settings', type: :settings do
  let(:config) { Settings }

  it do
    expect(Settings.application.name).to eq('Ledger Sync')

    with_settings(application: { name: 'foo' }) do
      expect(Settings.application.name).to eq('foo')
    end

    expect(Settings.application.name).to eq('Ledger Sync')
  end
end
