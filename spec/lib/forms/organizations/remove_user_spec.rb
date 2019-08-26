# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Organizations::RemoveUser, type: :form do
  include Formify::SpecHelpers

  let(:organization_user) { user.organization_users.first }
  let(:organization) { organization_user.organization }
  let(:user) { FactoryBot.create(:user) }

  let(:attributes) do
    {
      organization: organization,
      user: user
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(OrganizationUser) }

  describe '#organization' do
    it { expect_error_with_missing_attribute(:organization) }
  end

  describe '#user' do
    it { expect_error_with_missing_attribute(:user) }
  end

  context 'when not previously added' do
    let(:organization) { FactoryBot.create(:organization) }
    let(:user) { FactoryBot.create(:user, :without_organization) }

    it { expect_invalid }
  end
end
