# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Syncs::UpsertResources, type: :form do
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
  it { expect { value }.to change(SyncResource, :count).from(0).to(1) }
end
