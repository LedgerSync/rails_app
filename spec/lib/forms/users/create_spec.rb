# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Users::Create, type: :form do
  include Formify::SpecHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:email) { 'test@example.com' }
  let(:external_id) { 'EXTERNAL_ID_VALUE' }
  let(:name) { 'NAME_VALUE' }

  let(:attributes) do
    {
      email: email,
      external_id: external_id,
      name: name
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(User) }
  it { expect { value }.to change(User, :count).from(0).to(1) }
  it { expect(value.external_id).to eq(external_id) }
  it { expect(value.name).to eq(name) }
  it { expect(value.email).to eq(email) }

  describe '#email' do
    it { expect_error_with_missing_attribute(:email) }
  end

  describe '#external_id' do
    it { expect_error_with_missing_attribute(:external_id) }
  end

  context 'when external_id exists' do
    let(:external_id) { FactoryBot.create(:user).external_id }

    it { expect_error_with_attribute(:external_id) }
  end
end
