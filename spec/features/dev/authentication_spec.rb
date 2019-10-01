# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe 'dev/authentication', js: true, type: :feature do
  def expect_authorized
    expect_content('authorized')
  end

  def expect_unauthorized
    expect_content('unauthorized')
  end

  it do
    visit r.root_path
    expect_no_content :invisible, 'Dev Log In'
    visit r.auth_tokens_path
    expect_unauthorized
  end

  it do
    ClimateControl.modify(DEVELOPMENT: 'true') do
      visit r.root_path
      click_on 'Dev Log In'
      visit r.auth_tokens_path
      expect_authorized
    end
  end
end
