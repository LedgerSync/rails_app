# frozen_string_literal: true

require 'rails_helper'

describe 'GET /ledger_resources/:id', type: :api do
  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }
  let(:id) { ledger_resource.id }
  let(:path) { "ledger_resources/#{id}" }

  it 'returns unauthorized' do
    api_get path
    expect_401
  end

  context 'when authenticated', :with_authorization do
    it 'finds by id' do
      api_get "ledger_resources/#{ledger_resource.id}"
      expect_object_of_type(:ledger_resource)
    end

    context 'when does not exist' do
      let(:id) { 'foo' }

      it do
        api_get path
        expect_404
      end
    end
  end
end
