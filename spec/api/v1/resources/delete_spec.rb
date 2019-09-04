# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /resources/:id', type: :api do
  let(:resource) { FactoryBot.create(:resource) }
  let(:path) { "resources/#{resource.id}" }

  before { resource } # Create resource before API calls

  it 'returns unauthorized' do
    api_delete path
    expect_401
  end

  context 'when authenticated', :with_authorization do
    it { expect { api_delete path }.to change(Resource, :count).from(1).to(0) }

    context 'when using external_id' do
      let(:path) { "resources/#{resource.external_id}" }

      it { expect { api_delete path }.to change(Resource, :count).from(1).to(0) }
    end

    context 'when id does not exist' do
      let(:path) { "resources/foo" }

      it do
        api_delete path
        expect_404
      end
    end
  end
end
