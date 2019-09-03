# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::LedgerResources::Destroy, type: :form do
  include Formify::SpecHelpers


  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }


  let(:attributes) do
    {
      ledger_resource: ledger_resource
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(LedgerResource) }

  describe '#ledger_resource' do
    it { expect_error_with_missing_attribute(:ledger_resource) }
    xit { expect_error_with_attribute_value(:ledger_resource, LEDGER_RESOURCE_BAD_VALUE, message: nil) } # :message is optional
    xit { expect_valid_with_attribute_value(:ledger_resource, LEDGER_RESOURCE_GOOD_VALUE) }
  end

end
