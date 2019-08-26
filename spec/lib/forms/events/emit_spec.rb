# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Events::Emit, type: :form do
  include Formify::SpecHelpers

  let(:event) { FactoryBot.create(:event) }

  let(:attributes) do
    {
      event: event
    }
  end

  before do
    stub_request(
      :post,
      Settings.application.webhooks.url
    )
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Event) }

  it do
    value
    serialized_event = event.serialize
    expect(WebMock).to have_requested(
      :post,
      Settings.application.webhooks.url
    ).with(
      body: serialized_event,
      headers: {
        'X-Signature' => Util::WebhookSigner.new(data: serialized_event.to_json).signature,
        'Content-Type' => 'application/json',
        'X-Organization-ID' => event.organization.id,
        'X-Event-ID' => event.id
      }
    )
  end

  describe '#event' do
    it { expect_error_with_missing_attribute(:event) }
  end
end
