# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Resources::Upsert, type: :form do
  include Formify::SpecHelpers

  let(:organization) { FactoryBot.create(:organization) }
  let(:external_id) { 'external_id' }
  let(:resource) { FactoryBot.create(:resource) }
  let(:type) { 'customer' }

  let(:attributes) do
    {
      organization: organization,
      external_id: external_id,
      type: type
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Resource) }

  describe '#organization' do
    it { expect_error_with_missing_attribute(:organization) }
  end

  describe '#external_id' do
    it { expect_error_with_missing_attribute(:external_id) }
  end

  describe '#type' do
    it { expect_error_with_missing_attribute(:type) }
  end

end
