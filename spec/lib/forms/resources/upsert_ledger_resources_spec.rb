# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Resources::UpsertLedgerResources, type: :form do
  include Formify::SpecHelpers

  let(:resource) { FactoryBot.create(:resource) }
  let(:ledger) { FactoryBot.create(:ledger) }
  let(:attributes) do
    {
      resource: resource
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Resource) }

  describe '#resource' do
    it { expect_error_with_missing_attribute(:resource) }
  end

  context 'with two ledgers' do
    before { FactoryBot.create_list(:ledger, 2) }

    it { expect { value }.to change(LedgerResource, :count).from(0).to(2) }
  end
end
