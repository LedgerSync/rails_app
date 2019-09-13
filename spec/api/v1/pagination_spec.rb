# frozen_string_literal: true

require 'rails_helper'

describe 'pagination', type: :api do
  let(:resource) { FactoryBot.create(:resource) }
  let(:path) { 'resources' }

  context 'when authenticated', :with_authorization do
    it do
      FactoryBot.create_list(:resource, 2)
      api_get path
      expect_api_list_structure(2)


      api_get path, headers: { 'X-Page' => 2 }
      expect_api_list_structure(0)
    end
  end
end
