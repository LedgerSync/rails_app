# frozen_string_literal: true

require 'rails_helper'
support :routing_helpers

describe Util::WebhookSigner do
  include SettingsHelpers

  let(:data) { { foo: :bar }.to_s }

  subject { described_class.new(data: data) }

  let(:key) { Settings.application.webhooks.key }

  it { expect(Settings.application.webhooks.key).to be_present }
  it { expect(Settings.application.webhooks.url).to be_present }
  it { expect(subject.key).to eq(key) }
  it { expect(subject.signature).to eq(OpenSSL::HMAC.hexdigest('SHA256', key, data.to_s)) }

  context 'without key' do
    around do |example|
      with_settings(application: { webhooks: { key: nil } }) do
        example.run
      end
    end

    it { expect { subject }.to raise_error(RuntimeError, 'Missing Settings.application.webhooks.key') }
  end

  context 'without data as string' do
    let(:data) { {} }

    it { expect { subject }.to raise_error(RuntimeError, 'data must be a string') }
  end
end
