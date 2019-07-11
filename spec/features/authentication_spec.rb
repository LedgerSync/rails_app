# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe 'authentication', js: true, type: :feature do
  let(:auth_token) { FactoryBot.create(:auth_token) }

  def expect_authorized
    expect_content('authorized')
  end

  def expect_unauthorized
    expect_content('unauthorized')
  end

  it do
    # starts logged out
    visit r.auth_tokens_path
    expect_unauthorized

    # logs in
    visit r.auth_token_path(auth_token)
    expect_count '#dashboard-container'
    visit r.auth_tokens_path
    expect_authorized

    # logs out
    visit r.logout_path
    expect_content t('auth_tokens.destroy.success')
    expect_count '#home-container'
  end

  context 'when auth_token is expired' do
    before do
      auth_token
        .update!(
          created_at: auth_token.created_at - (Settings.authentication.auth_token_valid_for_minutes + 1).minutes
        )
    end

    it do
      visit r.auth_token_path(auth_token)
      expect_unauthorized
      visit r.auth_tokens_path
      expect_unauthorized
    end
  end
end
