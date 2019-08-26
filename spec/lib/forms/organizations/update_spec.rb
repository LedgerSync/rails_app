# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Organizations::Update, type: :form do
  include Formify::SpecHelpers

  let(:organization) { FactoryBot.create(:organization) }
  let(:name) { 'NAME_VALUE' }

  let(:attributes) do
    {
      organization: organization,
      name: name
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Organization) }
  it { expect(value.name).to eq(name) }
  it { expect_error_with_attribute_value(:name, '') }
end
