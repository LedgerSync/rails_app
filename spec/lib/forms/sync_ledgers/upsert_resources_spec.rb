# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::SyncLedgers::UpsertResources, type: :form do
  include Formify::SpecHelpers

  let(:sync_ledger) { FactoryBot.create(:sync_ledger) }
  let(:sync) { sync_ledger.sync }
  let(:ledger) { sync_ledger.ledger }

  let(:attributes) do
    {
      sync_ledger: sync_ledger
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(SyncLedger) }
  it do
    Forms::Syncs::UpsertResources.new(sync: sync).save
    expect { value }.to change(LedgerResource, :count).from(0).to(1)
  end

  describe '#sync_ledger' do
    it { expect_error_with_missing_attribute(:sync_ledger) }
  end

end
