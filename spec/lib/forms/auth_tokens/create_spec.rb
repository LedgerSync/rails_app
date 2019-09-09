require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::AuthTokens::Create do
  include Formify::SpecHelpers

  let(:resource) { FactoryBot.create(:user) }

  let(:attributes) do
    {
      resource: resource
    }
  end

  it { expect(result).to be_success }
  it { expect(value).to be_a(AuthToken) }
  it { expect_error_with_missing_attribute(:resource) }
  it { expect { value }.to change(AuthToken, :count).from(0).to(1) }
end
