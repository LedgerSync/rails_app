# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'


describe Forms::Syncs::Create, type: :form do
  include Formify::SpecHelpers

  let(:organization) { FactoryBot.create(:organization) }

  context 'when customer' do
    let(:attributes) { Util::InputHelpers::Customer.new.sync_request_body(organization: organization) }

    it { expect(result).to be_success }
    it { expect { result }.to change(SyncJobs::SetupSync.jobs, :size).from(0).to(1) }
    it { expect(value).to be_a(Sync) }
    it { expect { value }.to change(Sync, :count).from(0).to(1) }
    it { expect_error_with_missing_attribute(:organization_external_id) }
    it { expect_error_with_missing_attribute(:resource_external_id) }
    it { expect_error_with_missing_attribute(:resource_type) }
    it { expect_error_with_missing_attribute(:operation_method) }
    it { expect_error_with_missing_attribute(:references) }
  end

  context 'when payment' do
    let(:attributes) { Util::InputHelpers::Payment.new.sync_request_body(organization: organization) }

    it { expect(result).to be_success }
    it { expect(value).to be_a(Sync) }
    it { expect { value }.to change(Sync, :count).from(0).to(1) }
    it { expect_error_with_missing_attribute(:organization_external_id) }
    it { expect_error_with_missing_attribute(:resource_external_id) }
    it { expect_error_with_missing_attribute(:resource_type) }
    it { expect_error_with_missing_attribute(:operation_method) }
    it { expect_error_with_missing_attribute(:references) }
  end
end
