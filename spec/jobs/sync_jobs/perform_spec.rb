require 'rails_helper'

describe SyncJobs::Perform do
  let(:sync) { FactoryBot.create(:sync, :with_ledger) }
  let(:perform) { Sidekiq::Testing.inline! { described_class.perform_async(sync.id) } }
  let(:result) { described_class.new.perform(sync.id) }

  it { expect(result).to be_success }
  it { expect(result.value).to be_succeeded }
end
