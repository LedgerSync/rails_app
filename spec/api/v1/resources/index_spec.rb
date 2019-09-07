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
      api_get path
      expect_object_of_type(:list)
    end
  end
end
