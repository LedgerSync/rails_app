# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::SyncLedgerLogs::Create, type: :form do
  include Formify::SpecHelpers

  let(:action) { :test }
  let(:data) { { foo: :bar } }
  let(:sync_ledger) { FactoryBot.create(:sync_ledger) }

  let(:attributes) do
    {
      action: action,
      data: data,
      sync_ledger: sync_ledger
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(SyncLedgerLog) }

  describe '#action' do
    it { expect_error_with_missing_attribute(:action) }
  end

  describe '#data' do
    it { expect_error_with_missing_attribute(:data) }
  end

  describe '#sync_ledger' do
    it { expect_error_with_missing_attribute(:sync_ledger) }
  end
end
