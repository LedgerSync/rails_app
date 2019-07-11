# frozen_string_literal: true

require 'rails_helper'
support :klass_helpers

describe 'settings/add_ons/paper_trail' do
  include KlassHelpers

  it do
    ClimateControl.modify(SETTINGS__ADD_ONS__PAPER_TRAIL__ENABLED: 'true') do
      Settings.reload!
      # Creates a User, Account, and AccountUser
      expect { FactoryBot.create(:user) }.to change(PaperTrail::Version, :count).from(0).to(3)
    end
    Settings.reload!
  end

  it do
    ClimateControl.modify(SETTINGS__ADD_ONS__PAPER_TRAIL__ENABLED: 'false') do
      Settings.reload!
      expect { FactoryBot.create(:user) }.not_to change(PaperTrail::Version, :count)
    end
    Settings.reload!
  end

  it do
    ClimateControl.modify(SETTINGS__ADD_ONS__PAPER_TRAIL__ENABLED: 'asdf') do
      expect { Settings.reload! }.to raise_error(Config::Validation::Error)
    end
    Settings.reload!
  end

  context 'when current_user', js: true, type: :feature do
    it do
      user = FactoryBot.create(:user)
      login(user)

      sync = FactoryBot.create(:sync)
      FactoryBot.create(:ledger)

      visit r.sync_path(sync)
      expect_content(sync.decorate.title)
      click_on 'Sync to Ledger'
      accept_alert
      expect_content 'blocked'

      expect(SyncLedger.count).to eq(1)
      sync_ledger = SyncLedger.first
      expect(sync_ledger.versions.length).to eq(1)
      version = sync_ledger.versions.first
      expect(version.user).to eq(user)
    end
  end
end
