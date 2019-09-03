# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /ledger_resources/:id', type: :api do
  let(:ledger_resource) { FactoryBot.create(:ledger_resource) }
  let(:path) { "ledger_resources/#{ledger_resource.id}" }

  before { ledger_resource } # Create ledger_resource before API calls

  it 'returns unauthorized' do
    api_delete path
    expect_401
  end

  context 'when authenticated', :with_authorization do
    it { expect { api_delete path }.to change(LedgerResource, :count).from(1).to(0) }

    context 'when id does not exist' do
      let(:path) { 'ledger_resources/foo' }

      it do
        api_delete path
        expect_404
      end
    end
  end
end
