# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::LedgerResources::SetResourceLedgerID, type: :form do
  include Formify::SpecHelpers

  let(:ledger_resource) { FactoryBot.create(:ledger_resource, resource_ledger_id: nil) }
  let(:resource_ledger_id) { 'RESOURCE_LEDGER_ID_VALUE' }
  let(:attributes) do
    {
      ledger_resource: ledger_resource,
      resource_ledger_id: resource_ledger_id
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(LedgerResource) }
  it { expect(value.reload.resource_ledger_id).to eq(resource_ledger_id) }
  it do
    ledger_resource.update!(resource_ledger_id: :asdf)
    expect { result }.to raise_error(DevError)
  end

  describe '#resource_ledger_id' do
    it { expect_error_with_missing_attribute(:resource_ledger_id) }
  end
end
