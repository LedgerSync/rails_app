# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Organizations::AddUser, type: :form do
  include Formify::SpecHelpers

  let(:organization) { FactoryBot.create(:organization) }
  let(:user) { FactoryBot.create(:user, :without_organization) }

  let(:attributes) do
    {
      organization: organization,
      user: user
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(OrganizationUser) }
  it { expect(value.organization).to eq(organization) }
  it { expect(value.user).to eq(user) }

  describe '#organization' do
    it { expect_error_with_missing_attribute(:organization) }
  end

  describe '#user' do
    it { expect_error_with_missing_attribute(:user) }
  end

  context 'when already added' do
    let(:organization) { user.organizations.first }
    let(:user) { FactoryBot.create(:user) }

    it { expect_invalid }
  end
end
