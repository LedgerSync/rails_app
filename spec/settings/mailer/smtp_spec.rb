# frozen_string_literal: true

require 'rails_helper'

describe 'Settings.mailer.smtp', type: :settings do
  let(:config) { Settings }

  context 'when delivery_method != smtp' do
    before { config.merge!(mailer: { delivery_method: 'test' }) }

    it { expect_valid_config(config: config) }
  end

  context 'when delivery_method = smtp' do
    before { config.merge!(mailer: { delivery_method: 'smtp' }) }

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
      expect_valid_config(config: config)
    end
  end
end
