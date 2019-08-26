# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /organizations/:id', type: :api do
  let(:organization) { FactoryBot.create(:organization) }
  let(:path) { "organizations/#{organization.external_id}" }
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
      expect(organization.name).not_to eq(name)
      api_put path, params: params
      expect_object_of_type(:organization)
      expect(organization.reload.name).to eq(name)
    end
  end
end
