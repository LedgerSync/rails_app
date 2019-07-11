# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /accounts/:id', type: :api do
  let(:account) { FactoryBot.create(:account) }
  let(:path) { "accounts/#{account.external_id}" }
  let(:name) { 'new-name' }

  let(:params) do
    {
      name: name
    }
  end

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_put path, params: params
      expect_401
    end
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect(account.name).not_to eq(name)
      api_put path, params: params
      expect_object_of_type(:account)
      expect(account.reload.name).to eq(name)
    end
  end
end
