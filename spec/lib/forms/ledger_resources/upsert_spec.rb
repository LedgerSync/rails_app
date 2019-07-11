# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'


describe Forms::LedgerResources::Upsert, type: :form do
  include Formify::SpecHelpers

  let(:ledger) { FactoryBot.create(:ledger) }
  let(:resource) { FactoryBot.create(:resource) }

  let(:attributes) do
    {
      ledger: ledger,
      resource: resource
    }
  end

  it { expect_valid } # Expect the form to be valid
  it { expect(result).to be_success }
  it { expect(value).to be_a(LedgerResource) } # Model name inferred
  it do
    expect { value }.to change(LedgerResource, :count).from(0).to(1)
    expect { do_value }.not_to change(LedgerResource, :count)
  end

  describe '#ledger' do
    it { expect_error_with_missing_attribute(:ledger) }
  end

  describe '#resource' do
    it { expect_error_with_missing_attribute(:resource) }
  end
end
