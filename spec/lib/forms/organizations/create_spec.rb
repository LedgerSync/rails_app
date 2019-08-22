# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Organizations::Create, type: :form do
  include Formify::SpecHelpers

  let(:organization) { FactoryBot.create(:organization) }
  let(:external_id) { 'EXTERNAL_ID_VALUE' }
  let(:name) { 'NAME_VALUE' }

  let(:attributes) do
    {
      external_id: external_id,
      name: name
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Organization) }
  it { expect { value }.to change(Organization, :count).from(0).to(1) }
  it { expect(value.external_id).to eq(external_id) }
  it { expect(value.name).to eq(name) }

  describe '#external_id' do
    it { expect_error_with_missing_attribute(:external_id) }
  end

  describe '#name' do
    it { expect_error_with_missing_attribute(:name) }
  end

  context 'when external_id exists' do
    let(:external_id) { FactoryBot.create(:organization).external_id }

    it { expect_error_with_attribute(:external_id) }
  end
end
