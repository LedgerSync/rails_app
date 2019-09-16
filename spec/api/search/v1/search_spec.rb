# frozen_string_literal: true

require 'rails_helper'

describe 'GET api/search/v1/ledgers/:id/:lib_resource_type', type: :api do
  let(:ledger) { FactoryBot.create(:ledger) }
  let(:path) { "ledgers/#{ledger.id}/customers" }

  it 'returns unauthorized' do
    search_api_get path
    expect_401
  end

  context 'when authenticated', :with_authorization do
    it do
      search_api_get "#{path}?query=foobarbaz"
      expect_object_of_type('lib_search_result')
      expect(json.dig(:data, :attributes, :query)).to eq('foobarbaz')
      expect(json.dig(:data, :attributes, :next_page_url)).to eq("http://example.org/api/search/v1/ledgers/#{ledger.id}/customers?pagination%5Bcursor%5D=asdf&query=foobarbaz")
      expect(json.dig(:data, :attributes, :previous_page_url)).to eq("http://example.org/api/search/v1/ledgers/#{ledger.id}/customers?pagination%5Bcursor%5D=asdf&query=foobarbaz")
    end
  end
end
