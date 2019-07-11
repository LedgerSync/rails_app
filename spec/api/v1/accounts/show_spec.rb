# frozen_string_literal: true

require 'rails_helper'

describe 'POST /accounts/:id', type: :api do
  let(:account) { FactoryBot.create(:account) }
  let(:external_id) { account.external_id }
  let(:path) { "accounts/#{external_id}" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_get path
      expect_401
    end
  end

  context 'when authenticated', :with_authorization do
    it 'finds by od' do
      api_get "accounts/#{account.id}"
      expect_object_of_type(:account)
    end

    it 'finds by external_id' do
      api_get path
      expect_object_of_type(:account)
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
