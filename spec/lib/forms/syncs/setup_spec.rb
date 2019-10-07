# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Syncs::Setup, type: :form do
  include ActiveJob::TestHelper
  include Formify::SpecHelpers

  let(:ledger) { FactoryBot.create(:ledger) }
  let(:sync) { FactoryBot.create(:sync, organization: ledger.organization) }
  let(:attributes) do
    {
      sync: sync
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Sync) }
  it { expect { value }.to change(SyncLedger, :count).from(0).to(1) }

  it do
    external_id = '928db55e-6552-4aaf-96d7-10c693922b1f'

    sync.update!(
      operation_method: 'upsert',
      resource_type: :customer,
      without_create_confirmation: true,
      resource_external_id: external_id,
      references: {
        'customer' => {
          external_id => {
            'data' => {
              'name' => 'John Smith',
              'email' => 'renato_powlowski@oconner.com'
            }
          }
        }
      }
    )

    perform_enqueued_jobs do
      expect(value.resources.first.external_id).to eq(external_id)
    end
  end

  describe '#sync' do
    it { expect_error_with_missing_attribute(:sync) }
  end
end
