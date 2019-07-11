# frozen_string_literal: true

require 'rails_helper'

describe 'POST /accounts', type: :api do
  let(:account) { FactoryBot.create(:account) }
  let(:external_id) { 'an-id' }
  let(:path) { 'accounts' }
  let(:params) do
    {
      external_id: external_id,
      name: 'name'
    }
  end

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_post path, params: params
      expect_401
    end
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect { api_post path, params: params }.to change(Account, :count).from(0).to(1)
      expect_object_of_type(:account)
    end

    context 'when external_id exists' do
      let(:external_id) { account.external_id }

      it do
        api_post path, params: params
        expect_error_with_param(:external_id)
      end
    end
  end
end
