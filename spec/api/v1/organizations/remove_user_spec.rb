# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /organizations/:organization_id/users/:user_id', type: :api do
  let(:organization) { user.organizations.first }
  let(:user) { FactoryBot.create(:user) }
  let(:params) do
    {
      organization: organization.id,
      user: user.id
    }
  end

  let(:path) { "organizations/#{organization.id}/users/#{user.id}" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_delete path, params: params
      expect_401
    end
  end

  context 'when authenticated', :with_authorization do
    it do
      user
      expect { api_delete path, params: params }.to change(OrganizationUser, :count).from(1).to(0)
      expect_object_of_type(:organization_user)
    end
  end
end
