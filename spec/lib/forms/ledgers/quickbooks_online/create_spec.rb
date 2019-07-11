# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Ledgers::QuickBooksOnline::Create, type: :form do
  include Formify::SpecHelpers

  let(:attributes) do
    {
      access_token: :ACCESS_TOKEN_VALUE,
      account: FactoryBot.create(:account),
      code: :CODE_VALUE,
      expires_at: Time.zone.now + 1.week,
      realm_id: :REALM_ID_VALUE,
      refresh_token: :REFRESH_TOKEN_VALUE,
      response: :RESPONSE_VALUE,
      state: :STATE_VALUE
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Ledger) }
  it { expect { value }.to change(Ledger, :count).from(0).to(1) }

  describe '#access_token' do
    it { expect_error_with_missing_attribute(:access_token) }
  end

  describe '#account' do
    it { expect_error_with_missing_attribute(:account) }
  end

  describe '#code' do
    it { expect_error_with_missing_attribute(:code) }
  end

  describe '#expires_at' do
    it { expect_error_with_missing_attribute(:expires_at) }
  end

  describe '#realm_id' do
    it { expect_error_with_missing_attribute(:realm_id) }
  end

  describe '#refresh_token' do
    it { expect_error_with_missing_attribute(:refresh_token) }
  end

  describe '#response' do
    it { expect_error_with_missing_attribute(:response) }
  end

  describe '#state' do
    it { expect_error_with_missing_attribute(:state) }
  end
end
