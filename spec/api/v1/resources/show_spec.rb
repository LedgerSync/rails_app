# frozen_string_literal: true

require 'rails_helper'

describe 'GET /resources/:id', type: :api do
  let(:resource) { FactoryBot.create(:resource) }
  let(:external_id) { resource.external_id }
  let(:path) { "resources/#{external_id}" }

  it 'returns unauthorized' do
    api_get path
    expect_401
  end

  context 'when authenticated', :with_authorization do
    it 'finds by id' do
      api_get "resources/#{resource.id}"
      expect_object_of_type(:resource)
    end

    it 'finds by external_id' do
      api_get path
      expect_object_of_type(:resource)
    end

    context 'when does not exist' do
      let(:external_id) { 'asdf' }

      it do
        api_get path
        expect_404
      end
    end
  end
end
