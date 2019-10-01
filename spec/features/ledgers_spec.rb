# frozen_string_literal: true

require 'rails_helper'

describe 'ledgers/test', js: true, type: :feature do
  let(:ledger) { FactoryBot.create(:ledger) }

  it do
    login
    visit r.ledgers_path
    expect_content 'Ledgers'
    expect_content 'Connect QuickBooks'
  end

  it do
    login
    ledger
    visit r.ledgers_path
    expect_content 'Test Ledger Adaptor'
    click_on 'View'
    expect_content 'You made it!'
    expect_path ledger.decorate.show_path
  end
end
