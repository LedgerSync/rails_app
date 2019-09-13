# frozen_string_literal: true

require 'rails_helper'

describe 'POST /users', type: :api do
  let(:user) { FactoryBot.create(:user) }
  let(:email) { 'test@example.com' }
  let(:external_id) { 'an-id' }
  let(:path) { 'users' }
  let(:params) do
    {
      email: email,
      external_id: external_id,
      name: 'name'
    }
  end

  it 'returns unauthorized' do
    api_post path, params: params
    expect_401
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect { api_post path, params: params }.to change(User, :count).from(0).to(1)
      expect_object_of_type(:user)
    end

    context 'when external_id exists' do
      let(:external_id) { user.external_id }

      it do
        api_post path, params: params
        expect_error_with_param(:external_id)
      end
    end
  end
end
