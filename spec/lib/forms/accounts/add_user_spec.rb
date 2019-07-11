# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Accounts::AddUser, type: :form do
  include Formify::SpecHelpers

  let(:account) { FactoryBot.create(:account) }
  let(:user) { FactoryBot.create(:user, :without_account) }

  let(:attributes) do
    {
      account: account,
      user: user
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(AccountUser) }
  it { expect(value.account).to eq(account) }
  it { expect(value.user).to eq(user) }

  describe '#account' do
    it { expect_error_with_missing_attribute(:account) }
  end

  describe '#user' do
    it { expect_error_with_missing_attribute(:user) }
  end

  context 'when already added' do
    let(:account) { user.accounts.first }
    let(:user) { FactoryBot.create(:user) }

    it { expect_invalid }
  end
end
