# frozen_string_literal: true

require 'rails_helper'

describe 'pagination', type: :api do
  let(:resource) { FactoryBot.create(:resource) }

  context 'when authenticated', :with_authorization do
    it do
      FactoryBot.create_list(:resource, 2)
      api_get 'resources'
      expect_api_list_structure(2)

      api_get 'resources?page=2'

      expect_api_list_structure(0)

      api_get 'resources?per_page=1'
      expect_api_list_structure(1)

      api_get 'resources?page=1&per_page=1'
      expect_api_list_structure(1)

      api_get 'resources?page=2&per_page=1'
      expect_api_list_structure(1)

      api_get 'resources?page=3&per_page=1'
      expect_api_list_structure(0)
    end
  end
end
