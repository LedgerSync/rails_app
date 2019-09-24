# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Syncs::Perform, type: :form do
  include Formify::SpecHelpers

  let(:sync) { FactoryBot.create(:sync) }
  let(:sync_ledger) { FactoryBot.create(:sync_ledger, sync: sync) }
  let(:ledger) { sync_ledger.ledger }
  let(:attributes) do
    {
      sync: sync
    }
  end

  context 'when no ledger' do
    it { expect_valid }
    it { expect(result).to be_success }
    it { expect(value).to be_succeeded }
  end

  context 'when ledger' do
    before { sync_ledger }

    it { expect_valid }
    it { expect(result).to be_success }
    it do
      expect(value).to be_a(Sync)
      expect(value.reload).not_to be_succeeded
      expect(value).to be_blocked
    end

    it do
      sync.update!(without_create_confirmation: true)
      resource = FactoryBot.create(:resource, external_id: sync.resource_external_id, type: sync.resource_type)
      FactoryBot.create(:ledger_resource, ledger: ledger, resource: resource)
      expect(value.reload).to be_succeeded
    end
  end

  context 'when next sync' do
    let(:next_sync) { FactoryBot.create(:sync, organization: sync.organization) }

    before { next_sync }

    it do
      sync.reload
      expect { value }.to change(SyncJobs::Perform.jobs, :size).from(0).to(1)
      expect(SyncJobs::Perform.jobs.first['args']).to eq([next_sync.id])
    end
  end
end
