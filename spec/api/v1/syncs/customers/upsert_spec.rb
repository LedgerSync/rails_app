require 'rails_helper'


describe 'sync:customer/upsert', type: :api do
  let(:organization) { FactoryBot.create(:organization) }
  let(:sync_request_body) { Util::InputHelpers::Customer.new.sync_request_body(organization: organization) }

  xit do
    expect {
      post '/api/v1/sync', sync_request_body # post from provider
    }.to change(Sync, :count).from(0).to(1)
  end
end