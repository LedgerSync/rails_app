# frozen_string_literal: true

require 'rails_helper'
support :klass_helpers,
        :routing_helpers,
        :settings_helpers

describe 'settings' do
  include KlassHelpers
  include RoutingHelpers
  include SettingsHelpers

  let(:config) { Settings }

  it do
    expect(Settings.application.name).to eq('Ledger Sync')

    with_settings(application: { name: 'foo' }) do
      expect(Settings.application.name).to eq('foo')
    end

    expect(Settings.application.name).to eq('Ledger Sync')
  end

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

    context 'with smtp' do
      context 'when delivery_method != smtp' do
        let(:delivery_method) { 'test' }

        it { expect(config.validate!).to be_nil }
      end

      context 'when delivery_method = smtp' do
        let(:delivery_method) { 'smtp' }

        it { expect_invalid_config(config: config, message: 'mailer.smtp: must be filled') }
        it do
          config.merge!(mailer: { smtp: { username: :base } })
          expect_invalid_config(
            config: config,
            message: [
              'mailer.smtp.address: is missing',
              'mailer.smtp.authentication: is missing',
              'mailer.smtp.enable_starttls_auto: is missing',
              'mailer.smtp.password: is missing',
              'mailer.smtp.port: is missing',
              'mailer.smtp.username: must be a string'
            ]
          )
        end

        it do
          smtp = {
            address: 'foo',
            authentication: 'foo',
            enable_starttls_auto: true,
            password: 'foo',
            port: 1234,
            username: 'foo'
          }
          config.merge!(mailer: { smtp: smtp })
          expect_invalid_config(
            config: config,
            message: [
              'mailer.smtp.address: is missing',
              'mailer.smtp.authentication: is missing',
              'mailer.smtp.enable_starttls_auto: is missing',
              'mailer.smtp.password: is missing',
              'mailer.smtp.port: is missing',
              'mailer.smtp.username: must be a string'
            ]
          )
        end
      end
    end
  end
end
