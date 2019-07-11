# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /accounts/:account_id/users/:user_id', type: :api do
  let(:account) { user.accounts.first }
  let(:user) { FactoryBot.create(:user) }
  let(:params) do
    {
      account: account.id,
      user: user.id
    }
  end

  let(:path) { "accounts/#{account.id}/users/#{user.id}" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_delete path, params: params
      expect_401
    end
  end

  context 'when authenticated', :with_authorization do
    it do
      user
      expect { api_delete path, params: params }.to change(AccountUser, :count).from(1).to(0)
      expect_object_of_type(:account_user)
    end
  end
end
