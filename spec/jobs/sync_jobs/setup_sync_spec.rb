require 'rails_helper'

describe SyncJobs::SetupSync do
  let(:sync) { FactoryBot.create(:sync, :with_ledger) }
  let(:perform) { Sidekiq::Testing.inline! { described_class.perform_async(sync.id) } }
  let(:result) { described_class.new.perform(sync.id) }

  it { expect(result).to be_success }
  it { expect { perform }.to change(LedgerResource, :count).from(0).to(1) }
end
