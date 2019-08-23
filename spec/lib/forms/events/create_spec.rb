# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Events::Create, type: :form do
  include Formify::SpecHelpers

  let(:event) { FactoryBot.create(:event) }
  let(:event_object) { FactoryBot.create(:sync) }
  let(:type) { 'sync.succeeded' }
  let(:organization) { FactoryBot.create(:organization) }

  let(:attributes) do
    {
      event_object: event_object,
      type: type,
      organization: organization
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Event) }
  it { expect(JSON.parse(value.data)).to eq(event_object.serialize) }

  describe '#type' do
    it { expect_error_with_missing_attribute(:type) }
  end

  describe '#event_object' do
    it { expect_error_with_missing_attribute(:event_object) }
  end
end
