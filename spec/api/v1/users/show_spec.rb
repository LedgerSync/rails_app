# frozen_string_literal: true

require 'rails_helper'

describe 'POST /users/:id', type: :api do
  let(:user) { FactoryBot.create(:user) }
  let(:external_id) { user.external_id }
  let(:path) { "users/#{external_id}" }

  context 'unsigned request' do
    it 'returns unauthorized' do
      api_get path
      expect_401
    end
  end

  context 'when authenticated', :with_authorization do
    it 'finds by od' do
      api_get "users/#{user.id}"
      expect_object_of_type(:user)
    end

    it 'finds by external_id' do
      api_get path
      expect_object_of_type(:user)
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
