# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Syncs::Retry, type: :form do
  include Formify::SpecHelpers

  let(:sync) { FactoryBot.create(:sync, status: :failed) }

  let(:attributes) do
    {
      sync: sync
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Sync) }
  it do
    sync.update!(status: :failed)
    expect(sync).to be_failed
    expect { value }.to change(SyncJobs::Perform.jobs, :count).from(0).to(1)
  end

  describe '#sync' do
    it { expect_error_with_missing_attribute(:sync) }
  end
end
