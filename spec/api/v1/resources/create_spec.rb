# frozen_string_literal: true

require 'rails_helper'

describe 'POST /resources', type: :api do
  let(:path) { 'resources' }
  let(:resource) { FactoryBot.create(:resource) }
  let(:external_id) { 'an-id' }
  let(:organization) { resource.organization }
  let(:type) { resource.type }
  let(:params) do
    {
      external_id: external_id,
      organization: organization.id,
      type: type
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
      resource # Go ahead and create it because it is referenced and we want to ensure only one additional is created.
      expect { api_post path, params: params }.to change(Resource, :count).from(1).to(2)
      expect_object_of_type(:resource)
    end

    context 'when external_id exists' do
      let(:external_id) { resource.external_id }

      it do
        api_post path, params: params
        expect_error_with_param(:external_id)
      end
    end
  end
end
