# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::LedgerResources::UpsertLedgerID, type: :form do
  include Formify::SpecHelpers

  let(:ledger) { FactoryBot.create(:ledger) }
  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }
  let(:resource) { FactoryBot.create(:resource) }
  let(:resource_external_id) { resource.external_id }
  let(:resource_ledger_id) { :RESOURCE_LEDGER_ID_VALUE }
  let(:resource_type) { resource.type }

  let(:attributes) do
    {
      ledger: ledger,
      resource_external_id: resource_external_id,
      resource_ledger_id: resource_ledger_id,
      resource_type: resource_type
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(LedgerResource) }

  describe '#ledger' do
    it { expect_error_with_missing_attribute(:ledger) }
  end

  describe '#resource_external_id' do
    it { expect_error_with_missing_attribute(:resource_external_id) }
  end

  describe '#resource_ledger_id' do
    it { expect_error_with_missing_attribute(:resource_ledger_id) }
  end

  describe '#resource_type' do
    it { expect_error_with_missing_attribute(:resource_type) }
  end
end
