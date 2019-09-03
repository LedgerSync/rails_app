# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::LedgerResources::Create, type: :form do
  include Formify::SpecHelpers

  let(:ledger) { FactoryBot.create(:ledger) }
  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }
  let(:resource) { FactoryBot.create(:resource) }
  let(:resource_ledger_id) { 'resource_ledger_id_1' }

  let(:attributes) do
    {
      ledger: ledger,
      resource: resource,
      resource_ledger_id: resource_ledger_id
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(LedgerResource) }

  context 'when exists' do
    let(:ledger) { ledger_resource.ledger }
    let(:resource) { ledger_resource.resource }

    it { expect_invalid }
  end

  describe '#ledger' do
    it { expect_error_with_missing_attribute(:ledger) }
  end

  describe '#resource' do
    it { expect_error_with_missing_attribute(:resource) }
  end

  describe '#resource_ledger_id' do
    it { expect_error_with_missing_attribute(:resource_ledger_id) }
  end

end
