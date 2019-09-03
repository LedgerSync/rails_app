# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Resources::Update, type: :form do
  include Formify::SpecHelpers

  let(:external_id) { 'new-external-id' }
  let(:resource) { FactoryBot.create(:resource) }

  let(:attributes) do
    {
      external_id: external_id,
      resource: resource
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Resource) }
  it { expect(value.external_id).to eq(external_id) }
end
