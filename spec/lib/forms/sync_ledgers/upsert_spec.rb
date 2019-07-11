# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::SyncLedgers::Upsert, type: :form do
  include Formify::SpecHelpers

  let(:ledger) { FactoryBot.create(:ledger) }
  let(:sync) { FactoryBot.create(:sync) }

  let(:attributes) do
    {
      ledger: ledger,
      sync: sync
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(SyncLedger) }
  it do
    expect { value }.to change(SyncLedger, :count).from(0).to(1)
    expect { described_class.new(attributes).save }.to_not change(SyncLedger, :count)
  end

  describe '#ledger' do
    it { expect_error_with_missing_attribute(:ledger) }
  end

  describe '#sync' do
    it { expect_error_with_missing_attribute(:sync) }
  end
end
