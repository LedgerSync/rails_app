# frozen_string_literal: true

require 'rails_helper'
support :routing_helpers

describe Util::WebhookSigner do
  include SettingsHelpers

  let(:data) { { foo: :bar }.to_s }

  subject { described_class.new(data: data) }

  it { expect { subject }.to raise_error }

  context 'with key' do
    let(:key) { 'asdf' }

    around do |example|
      with_settings(application: { webhooks: { key: key } }) do
        example.run
      end
    end

    it { expect(subject.key).to eq('asdf') }
    it { expect(subject.signature).to eq(OpenSSL::HMAC.hexdigest('SHA256', key, data.to_s)) }

    context 'without data as string' do
      let(:data) { {} }

      it { expect { subject }.to raise_error }
    end
  end
end
