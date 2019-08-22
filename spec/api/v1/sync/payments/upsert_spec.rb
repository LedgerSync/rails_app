require 'rails_helper'


describe 'sync:payments/upsert', type: :api do
  let(:organization) { FactoryBot.create(:organization) }
  let(:sync_request_body) { Util::InputHelpers::Payment.new.sync_request_body(organization: organization) }

  context 'with authorization', :with_authorization, :with_idempotency do
    it do
      expect {
        api_post '/sync', params: sync_request_body # post from provider
      }.to change(Sync, :count).from(0).to(1)
    end
  end
end