# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /ledger_resources/:id', type: :api do
  let(:path) { "ledger_resources/#{ledger_resource.id}" }
  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }
  let(:resource_ledger_id) { 'new_resource_ledger_id' }
  let(:params) do
    {
      resource_ledger_id: resource_ledger_id
    }
  end

  it 'returns unauthorized' do
    api_put path, params: params
    expect_401
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect(ledger_resource.resource_ledger_id).not_to eq(resource_ledger_id)
      api_put path, params: params
      expect_object_of_type(:ledger_resource)
      ledger_resource.reload
      expect(ledger_resource.resource_ledger_id).to eq(resource_ledger_id)
    end
  end
end
