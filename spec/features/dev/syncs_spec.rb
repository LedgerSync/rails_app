# frozen_string_literal: true

require 'rails_helper'

describe 'sync_ledgers/create', js: true, type: :feature do
  xit do
    login
    expect { visit r.new_dev_sync_path }.to raise_error(ActionController::RoutingError)
  end

  it do
    ClimateControl.modify(DEVELOPMENT: 'true') do
      login(FactoryBot.create(:user, :admin))
      visit r.new_dev_sync_path
      expect_content 'Create Sync'
      expect do
        click_on 'Send'
        expect_content 'Operation'
      end.to change(Sync, :count).from(0).to(1)
    end
  end
end
