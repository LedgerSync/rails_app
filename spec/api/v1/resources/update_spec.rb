# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /resources/:id', type: :api do
  let(:resource) { FactoryBot.create(:resource) }
  let(:path) { "resources/#{resource.id}" }
  let(:external_id) { "#{resource.external_id}-foo" }
  let(:params) do
    {
      external_id: external_id
    }
  end

  it 'returns unauthorized' do
    api_put path, params: params
    expect_401
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect(resource.external_id).not_to eq(external_id)
      api_put path, params: params
      expect_object_of_type(:resource)
      resource.reload
      expect(resource.external_id).to eq(external_id)
    end
  end
end
