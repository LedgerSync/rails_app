# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Accounts::RemoveUser, type: :form do
  include Formify::SpecHelpers

  let(:account_user) { user.account_users.first }
  let(:account) { account_user.account }
  let(:user) { FactoryBot.create(:user) }

  let(:attributes) do
    {
      account: account,
      user: user
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(AccountUser) }

  describe '#account' do
    it { expect_error_with_missing_attribute(:account) }
  end

  describe '#user' do
    it { expect_error_with_missing_attribute(:user) }
  end

  context 'when not previously added' do
    let(:account) { FactoryBot.create(:account) }
    let(:user) { FactoryBot.create(:user, :without_account) }

    it { expect_invalid }
  end
end
