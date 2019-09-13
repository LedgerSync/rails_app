require 'rails_helper'


describe 'POST syncs/:id/skip', type: :api do
  let(:sync) { FactoryBot.create(:sync) }

  def post_skip_sync
    post "/api/v1/syncs/#{sync.id}/skip"
  end

  it 'returns unauthorized' do
    post_skip_sync
    expect_401
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      sync.update!(status: :succeeded)
      expect(sync).to be_succeeded
      post_skip_sync
      expect_invalid_request_error('cannot be skipped as it has already succeeded.')
      expect(sync.reload).to be_succeeded
    end

    it do
      sync.update!(status: :failed)
      next_sync = FactoryBot.create(:sync)
      expect(sync.reload.next_sync).to eq(next_sync)
      expect(sync).to be_failed
      expect { post_skip_sync }.to change(SyncJobs::Perform.jobs, :count).from(0).to(1)
      expect_object_of_type(:sync)
      expect(sync.reload).to be_skipped
    end
  end
end
