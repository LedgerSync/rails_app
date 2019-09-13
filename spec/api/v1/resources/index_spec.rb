# frozen_string_literal: true

require 'rails_helper'

describe 'GET /resources/:id', type: :api do
  let(:resource) { FactoryBot.create(:resource) }
  let(:path) { 'resources' }

  it 'returns unauthorized' do
    api_get path
    expect_401
  end

  context 'when authenticated', :with_authorization do
    it do
      FactoryBot.create_list(:resource, 2)
      api_get path
      expect_api_list_structure(2)
    end
  end
end
