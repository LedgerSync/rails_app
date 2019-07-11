# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::SyncLedgers::Perform, type: :form do
  include Formify::SpecHelpers

  let(:sync_ledger) { FactoryBot.create(:sync_ledger) }
  let(:sync) { sync_ledger.sync }
  let(:ledger) { sync_ledger.ledger }

  let(:attributes) do
    {
      sync_ledger: sync_ledger
    }
  end

  before do
    Forms::Syncs::UpsertResources
      .new(sync: sync)
      .save
      .value
    Forms::SyncLedgers::UpsertResources
      .new(sync_ledger: sync_ledger)
      .save
    LedgerResource.update_all(approved_by_id: create(:user).id)
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(SyncLedger) }
end
