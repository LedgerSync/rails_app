 # frozen_string_literal: true

require 'rails_helper'

describe 'sync_ledgers/create', js: true, type: :feature do
  # let(:sync_ledger) { FactoryBot.create(:sync_ledger) }
  # let(:sync) { sync_ledger.sync }
  # let(:ledger) { sync_ledger.ledger }
  let(:sync_ledger) { FactoryBot.create(:sync_ledger, sync: sync) }
  let(:sync) { FactoryBot.create(:sync) }
  let(:ledger) { FactoryBot.create(:ledger) }

  it do
    login
    sync
    ledger
    visit r.sync_path(sync)
    expect(SyncLedger.count).to be_zero
    expect_content(sync.decorate.title)
    click_on 'Sync to Ledger'
    accept_alert
    expect_content 'Test Ledger Adaptor'
    expect_content 'BLOCKED'
    expect(SyncLedger.count).to eq(1)
  end
end
