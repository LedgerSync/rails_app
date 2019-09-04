# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Resources::Create, type: :form do
  include Formify::SpecHelpers

  let(:external_id) { 'external_id' }
  let(:organization) { FactoryBot.create(:organization) }
  let(:resource) { FactoryBot.create(:resource) }
  let(:type) { 'customer' }

  let(:attributes) do
    {
      external_id: external_id,
      organization: organization,
      type: type
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Resource) }

  describe '#external_id' do
    it { expect_error_with_missing_attribute(:external_id) }
  end

  describe '#organization' do
    it { expect_error_with_missing_attribute(:organization) }
  end

  describe '#type' do
    it { expect_error_with_missing_attribute(:type) }
  end
end
