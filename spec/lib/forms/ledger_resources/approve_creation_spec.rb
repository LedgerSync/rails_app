# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::LedgerResources::ApproveCreation, type: :form do
  include Formify::SpecHelpers


  let(:ledger_resource) { FactoryBot.create(:ledger_resource, resource_ledger_id: nil) }
  let(:approved_by) { FactoryBot.create(:user) }
  let(:resource) { ledger_resource.resource }

  let(:attributes) do
    {
      approved_by: approved_by,
      ledger_resource: ledger_resource
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(LedgerResource) }
  it { expect(value).to be_approved }
  it do
    expect { ledger_resource }.to change { LedgerResource.not_approved.count }.from(0).to(1)
    expect { value }.to change { LedgerResource.not_approved.count }.from(1).to(0)
  end

  it do
    expect { ledger_resource }.to change { LedgerResource.todo.count }.from(0).to(1)
    expect { value }.to change { LedgerResource.todo.count }.from(1).to(0)
  end

  context 'with sync' do
    let(:ledger_resource) { FactoryBot.create(:ledger_resource, :with_sync) }

    it do
      expect { value }.to change(SyncJobs::Perform.jobs, :size).from(0).to(1)
    end
  end

  describe '#approved_by' do
    it { expect_error_with_missing_attribute(:approved_by) }
  end

  context 'with sync' do
    let(:sync) { FactoryBot.create(:sync_resource, resource: resource).sync }

    before { Forms::Syncs::UpdateStatus.new(sync: sync).save }

    it do
      expect(sync.reload).to be_blocked
      value
      expect(sync.reload).to be_queued
    end
  end
end
