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
        'id' => auth_token.id,
        'object' => 'auth_token',
        'resource' => auth_token.resource.id,
        'resource_type' => 'User',
        'url' => "http://lvh.me:3000/auth/#{auth_token.id}",
        'token' => auth_token.id
      }.merge(
        'created_at' => auth_token.created_at.to_i,
        'updated_at' => auth_token.updated_at.to_i
      )
      expect(api_as_json).to eq(h)
    end
  end
end
