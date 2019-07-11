# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'


describe Forms::SyncResources::Upsert, type: :form do
  include Formify::SpecHelpers

  let(:resource) { FactoryBot.create(:resource) }
  let(:sync) { FactoryBot.create(:sync) }
  let(:sync_resource) { FactoryBot.create(:sync_resource) }
  let(:data) { Util::InputHelpers::Customer.new.data }

  let(:attributes) do
    {
      data: data,
      resource: resource,
      sync: sync
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(SyncResource) }

  describe '#resource' do
    it { expect_error_with_missing_attribute(:resource) }
  end

  describe '#sync' do
    it { expect_error_with_missing_attribute(:sync) }
  end
end
