# frozen_string_literal: true

require 'rails_helper'

describe 'Settings.mailer', type: :settings do
  let(:config) { Settings }

  describe '.mailer' do
    let(:delivery_method) { 'test' }

    around do |example|
      config.merge!(mailer: { delivery_method: delivery_method })
      example.run
      config.reload!
    end

    it { expect(config.validate!).to be_nil }

    it do
      config.merge!(mailer: { delivery_method: nil })
      expect { config.validate! }.to raise_error(Config::Validation::Error)
    end
  end
end
