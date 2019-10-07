require 'rails_helper'

support :routing_helpers

RSpec.describe LedgerDecorator do
  include RoutingHelpers

  describe '#show_path' do
    it do
      ledger = create(:ledger, :quickbooks_online)
      expect(ledger.decorate.show_path).to eq(r.ledgers_quickbooks_online_path(ledger))
    end

    it do
      ledger = create(:ledger, :test)
      expect(ledger.decorate.show_path).to eq(r.ledgers_test_path(ledger))
    end

    it do
      ledger = create(:ledger, kind: :asdf)
      expect { ledger.decorate.show_path }.to raise_error(NotImplementedError)
    end
  end
end
