require 'rails_helper'


describe 'sync:customer/upsert', type: :api do
  let(:account) { FactoryBot.create(:account) }
  let(:sync_request_body) { Util::InputHelpers::Customer.new.sync_request_body(account: account) }

  xit do
    expect {
      post '/api/v1/sync', sync_request_body # post from provider
    }.to change(Sync, :count).from(0).to(1)
  end
end