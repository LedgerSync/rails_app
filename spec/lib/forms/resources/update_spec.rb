# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Resources::Update, type: :form do
  include Formify::SpecHelpers

  let(:external_id) { 'new-external-id' }
  let(:organization) { FactoryBot.create(:organization) }
  let(:resource) { FactoryBot.create(:resource) }
  let(:type) { 'payment' }

  let(:attributes) do
    {
      external_id: external_id,
      organization: organization,
      resource: resource,
      type: type
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Resource) }
  it { expect(value.external_id).to eq(external_id) }
  it { expect(value.organization).to eq(organization) }
  it { expect(value.type).to eq(type) }
end
