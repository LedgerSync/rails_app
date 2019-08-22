# frozen_string_literal: true

require 'rails_helper'

describe 'POST /organizations/:id', type: :api do
  let(:organization) { FactoryBot.create(:organization) }
  let(:external_id) { organization.external_id }
  let(:path) { "organizations/#{external_id}" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_get path
      expect_401
    end
  end

  context 'when authenticated', :with_authorization do
    it 'finds by od' do
      api_get "organizations/#{organization.id}"
      expect_object_of_type(:organization)
    end

    it 'finds by external_id' do
      api_get path
      expect_object_of_type(:organization)
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
