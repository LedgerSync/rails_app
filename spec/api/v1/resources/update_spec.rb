# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /resources/:id', type: :api do
  let(:resource) { FactoryBot.create(:resource) }
  let(:path) { "resources/#{resource.id}" }
  let(:external_id) { "#{resource.external_id}-foo" }
  let(:organization) { FactoryBot.create(:organization) }
  let(:type) { (LedgerSync.resources.keys - [resource.type.to_sym]).first }
  let(:params) do
    {
      external_id: external_id,
      organization: organization.id,
      type: type
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
      expect(resource.external_id).not_to eq(external_id)
      expect(resource.organization).not_to eq(organization)
      expect(resource.type).not_to eq(type)
      api_put path, params: params
      expect_object_of_type(:resource)
      resource.reload
      expect(resource.external_id).to eq(external_id)
      expect(resource.organization).to eq(organization)
      expect(resource.type).to eq(type.to_s)
    end
  end
end
