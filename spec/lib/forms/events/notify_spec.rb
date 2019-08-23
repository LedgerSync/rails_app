# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Events::Notify, type: :form do
  include Formify::SpecHelpers

  let(:event) { FactoryBot.create(:event) }
  let(:url) { 'https://www.example.com' }

  let(:attributes) do
    {
      event: event,
      url: url
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Event) }

  describe '#event' do
    it { expect_error_with_missing_attribute(:event) }
  end

  describe '#url' do
    it { expect_error_with_missing_attribute(:url) }
  end
end
