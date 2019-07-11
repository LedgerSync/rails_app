  # frozen_string_literal: true

require 'rails_helper'

describe 'sync_ledgers/create', js: true, type: :feature do
  let(:sync) { FactoryBot.create(:sync) }

  it do
    login
    visit r.sync_path(sync)
    expect(SyncJobs::Perform.jobs.count).to eq(0)
    click_on 'Sync Now'
    expect_content t('syncs.processing_in_background')
    expect(SyncJobs::Perform.jobs.count).to eq(1)
  end
end
