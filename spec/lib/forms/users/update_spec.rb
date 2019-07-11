# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Users::Update, type: :form do
  include Formify::SpecHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:email) { "1#{user.email}" }
  let(:name) { 'NAME_VALUE' }

  let(:attributes) do
    {
      email: email,
      name: name,
      user: user
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(User) }
  it { expect(value.name).to eq(name) }
  it { expect(value.email).to eq(email) }
  it { expect_error_with_attribute_value(:name, '') }
  it { expect_error_with_attribute_value(:email, '') }
end
