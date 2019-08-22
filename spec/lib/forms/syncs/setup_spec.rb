# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Syncs::Setup, type: :form do
  include Formify::SpecHelpers

  let(:ledger) { FactoryBot.create(:ledger) }
  let(:sync) { FactoryBot.create(:sync, organization: ledger.organization) }
  let(:attributes) do
    {
      sync: sync
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Sync) }
  it { expect { value }.to change(SyncLedger, :count).from(0).to(1) }

  describe '#sync' do
    it { expect_error_with_missing_attribute(:sync) }
  end
end
