# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::LedgerResources::Update, type: :form do
  include Formify::SpecHelpers

  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }
  let(:resource_ledger_id) { Time.now.to_s }

  let(:attributes) do
    {
      ledger_resource: ledger_resource,
      resource_ledger_id: resource_ledger_id
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(LedgerResource) }
  it { expect(value.resource_ledger_id).to eq(resource_ledger_id) }
end
