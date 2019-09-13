# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe API::Renderable do
  include Formify::SpecHelpers

  subject { new_klass }

  let(:new_klass) { Class.new.include(described_class).new }

  describe '#api_as_json' do
    subject(:api_as_json) { new_klass.api_as_json(auth_token) }

    let(:auth_token) { create(:auth_token) }

    it do
      h = {
        'data': {
          'id': auth_token.id,
          'type': :auth_token,
          attributes: {
            'url': "http://lvh.me:3000/auth/#{auth_token.id}",
            'token': auth_token.id,
            'created_at': auth_token.created_at.to_i,
            'updated_at': auth_token.updated_at.to_i
          },
          'relationships': {
            'user': {
              'data': {
                id: auth_token.user.id,
                type: :user
              }
            }
          }
        }
      }
      expect(api_as_json).to eq(h)
    end
  end
end
