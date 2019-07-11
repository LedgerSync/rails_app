# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Accounts::Update, type: :form do
  include Formify::SpecHelpers

  let(:account) { FactoryBot.create(:account) }
  let(:name) { 'NAME_VALUE' }

  let(:attributes) do
    {
      account: account,
      name: name
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(Account) }
  it { expect(value.name).to eq(name) }
  it { expect_error_with_attribute_value(:name, '') }
end
