# frozen_string_literal: true

require 'rails_helper'

describe 'POST /user/:id/auth_tokens', type: :api do
  let(:user) { FactoryBot.create(:user) }
  let(:external_id) { user.external_id }
  let(:path) { "users/#{external_id}/auth_tokens" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_post path
      expect_401
    end
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      api_post path
      expect_object_of_type(:auth_token)
    end

    it do
      api_post 'users/does-not-exist/auth_tokens'
      expect_no_such_record_error
    end
  end
end
