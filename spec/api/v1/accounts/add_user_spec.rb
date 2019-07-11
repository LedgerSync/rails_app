# frozen_string_literal: true

require 'rails_helper'

describe 'POST /accounts/:account_id/users/:user_id', type: :api do
  let(:account) { FactoryBot.create(:account) }
  let(:user) { FactoryBot.create(:user, :without_account) }
  let(:params) do
    {
      account: account.id,
      user: user.id
    }
  end

  let(:path) { "accounts/#{account.id}/users/#{user.id}" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_post path, params: params
      expect_401
    end
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect { api_post path, params: params }.to change(AccountUser, :count).from(0).to(1)
      expect_object_of_type(:account_user)
    end
  end
end
