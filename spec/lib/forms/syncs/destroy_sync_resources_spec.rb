# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Syncs::DestroySyncResources, type: :form do
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

  describe '#sync' do
    it { expect_error_with_missing_attribute(:sync) }
  end
end
