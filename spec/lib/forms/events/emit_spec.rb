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
    ).to_return(
      body: 'success',
      status: 200
    )
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Event) }

  describe '#event' do
    it { expect_error_with_missing_attribute(:event) }
  end
end
