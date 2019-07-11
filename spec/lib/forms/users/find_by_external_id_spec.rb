# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Users::FindByExternalID, type: :form do
  include Formify::SpecHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:external_id) { user.external_id }

  let(:attributes) do
    {
      external_id: external_id
    }
  end

  it { expect_valid }
  it { expect(result).to be_success }
  it { expect(value).to be_a(User) }

  describe '#external_id' do
    it { expect_error_with_missing_attribute(:external_id) }
  end

  context 'when external_id does not exist' do
    let(:external_id) { 'does-not-exist' }

    it { expect_error_with_attribute(:user) }
  end
end
