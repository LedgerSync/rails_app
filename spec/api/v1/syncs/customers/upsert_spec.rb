# frozen_string_literal: true

require 'rails_helper'

describe 'sync:customer/upsert', type: :api do
  let(:organization) { FactoryBot.create(:organization) }
  let(:sync_request_body) { Util::InputHelpers::Customer.new.sync_request_body(organization: organization) }

  it 'returns unauthorized' do
    api_post 'sync'
    expect_401
  end

  context 'when authorized', :with_idempotency, :with_authorization do
    it do
      expect do
        api_post 'sync', params: sync_request_body
      end.to change(Sync, :count).from(0).to(1)
    end

    it do
      expect do
        api_post(
          'sync',
          params: sync_request_body.merge(
            without_create_confirmation: true
          )
        )
      end.to change(Sync, :count).from(0).to(1)
      expect(Sync.first).to be_without_create_confirmation
    end
  end
end
