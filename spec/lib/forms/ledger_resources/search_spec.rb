# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::LedgerResources::Search, type: :form do
  include Formify::SpecHelpers

  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }
  let(:q) { nil }

  let(:attributes) do
    {
      ledger_resource: ledger_resource,
      q: q
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(result).to be_a(LedgerSync::SearchResult::Success) }
  it { expect(result.resources.first).to be_a(LedgerSync::Customer) }

  describe '#ledger_resource' do
    it { expect_error_with_missing_attribute(:ledger_resource) }
  end
end
