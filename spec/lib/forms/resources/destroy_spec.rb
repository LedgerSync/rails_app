# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Resources::Destroy, type: :form do
  include Formify::SpecHelpers


  let(:resource) { FactoryBot.create(:resource) }


  let(:attributes) do
    {
      resource: resource
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Resource) }

  describe '#resource' do
    it { expect_error_with_missing_attribute(:resource) }
    xit { expect_error_with_attribute_value(:resource, RESOURCE_BAD_VALUE, message: nil) } # :message is optional
    xit { expect_valid_with_attribute_value(:resource, RESOURCE_GOOD_VALUE) }
  end

end
