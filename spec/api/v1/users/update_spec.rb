# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /users/:id', type: :api do
  let(:user) { FactoryBot.create(:user) }
  let(:path) { "users/#{user.external_id}" }
  let(:email) { "1#{user.email}" }
  let(:name) { 'new-name' }

  let(:params) do
    {
      email: email,
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
      expect(user.name).not_to eq(name)
      expect(user.email).not_to eq(email)
      api_put path, params: params
      expect_object_of_type(:user)
      expect(user.reload.name).to eq(name)
      expect(user.email).to eq(email)
    end
  end
end
