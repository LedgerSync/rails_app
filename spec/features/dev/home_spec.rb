# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe 'dev/home', js: true, type: :feature do
  it do
    ClimateControl.modify(DEVELOPMENT: 'true') do
      visit r.root_path
      click_on 'Dev Log In'
      visit r.dev_path
      expect_content 'Create Sync'
    end
  end
end
