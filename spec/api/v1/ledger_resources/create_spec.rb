# frozen_string_literal: true

require 'rails_helper'

describe 'POST /ledger_resources', type: :api do
  let(:path) { 'ledger_resources' }
  let(:resource) { FactoryBot.create(:resource) }
  let(:ledger) { FactoryBot.create(:ledger) }
  let(:resource_ledger_id) { 'resource_ledger_id' }
  let(:params) do
    {
      ledger: ledger.id,
      resource: resource.id,
      resource_ledger_id: resource_ledger_id
    }
  end

  it 'returns unauthorized' do
    api_post path, params: params
    expect_401
  end

  context 'when authenticated', :with_authorization, :with_idempotency do
    it do
      expect { api_post path, params: params }.to change(LedgerResource, :count).from(0).to(1)
      expect_object_of_type(:ledger_resource)
    end
  end
end
