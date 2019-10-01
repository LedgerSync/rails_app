require 'rails_helper'

describe EventJobs::CreateAndEmit do
  let(:sync) { FactoryBot.create(:sync, :with_ledger) }
  let(:args) do
    [
      sync.serialize,
      'Sync',
      sync.id,
      sync.organization.id,
      'sync.queued'
    ]
  end
  let(:perform) { Sidekiq::Testing.inline! { described_class.perform_async(*args) } }
  let(:result) { described_class.new.perform(*args) }

  before do
    stub_request(
      :post,
      Settings.application.webhooks.url
    )
  end

  it { expect(result).to be_success }
  it { expect { result.value }.to change(EventJobs::Emit.jobs, :count).from(0).to(1) }
end
