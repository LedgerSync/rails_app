# frozen_string_literal: true

require 'rails_helper'

describe 'POST /organizations/:organization_id/users/:user_id', type: :api do
  let(:organization) { FactoryBot.create(:organization) }
  let(:user) { FactoryBot.create(:user, :without_organization) }
  let(:params) do
    {
      organization: organization.id,
      user: user.id
    }
  end

  let(:path) { "organizations/#{organization.id}/users/#{user.id}" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_post path, params: params
      expect_401
    end
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect { api_post path, params: params }.to change(OrganizationUser, :count).from(0).to(1)
      expect_object_of_type(:organization_user)
    end
  end
end
