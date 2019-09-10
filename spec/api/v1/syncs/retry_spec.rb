# frozen_string_literal: true

require 'rails_helper'

describe 'POST syncs/:id/retry', type: :api do
  let(:sync) { FactoryBot.create(:sync) }

  def post_retry_sync
    post "/api/v1/syncs/#{sync.id}/retry"
  end

  it 'returns unauthorized' do
    post_retry_sync
    expect_401
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      sync.update!(status: :queued)
      expect(sync).to be_queued
      post_retry_sync
      expect_invalid_request_error('Sync must have failed to retry it.')
      expect(sync.reload).to be_queued
    end

    it do
      sync.update!(status: :failed)
      expect(sync).to be_failed
      expect { post_retry_sync }.to change(SyncJobs::Perform.jobs, :count).from(0).to(1)
      expect_object_of_type(:sync)
      expect(sync.reload).to be_queued
    end
  end
end
