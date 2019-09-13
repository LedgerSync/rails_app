# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Syncs::Skip, type: :form do
  include Formify::SpecHelpers

  let(:sync) { FactoryBot.create(:sync) }

  let(:attributes) do
    {
      sync: sync
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Sync) }
  it do
    next_sync = FactoryBot.create(:sync, organization: sync.organization)
    expect(sync.reload.next_sync).to eq(next_sync)
    expect { value }.to change(SyncJobs::Perform.jobs, :count).from(0).to(1)
  end

  describe '#sync' do
    it { expect_error_with_missing_attribute(:sync) }
  end
end
