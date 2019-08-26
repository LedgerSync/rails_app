require 'rails_helper'

describe EventJobs::Emit do
  let(:event) { FactoryBot.create(:event) }
  let(:args) do
    [
      event.id
    ]
  end
  let(:perform) { Sidekiq::Testing.inline! { described_class.perform_async(*args) } }
  let(:result) { described_class.new.perform(*args) }

  it do
    stub_request(
      :post,
      Settings.application.webhooks.url
    )
    expect(result).to be_success
  end
end
