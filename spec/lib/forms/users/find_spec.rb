# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Users::Find, type: :form do
  include Formify::SpecHelpers

  let(:user) { FactoryBot.create(:user) }

  let(:attributes) do
    {
      id: id
    }
  end

  context 'when using id' do
    let(:id) { user.id }

    it { expect(result).to be_success }
    it { expect(value).to be_a(User) }
  end

  context 'when using external_id' do
    let(:id) { user.external_id }

    it { expect(result).to be_success }
    it { expect(value).to be_a(User) }
  end

  context 'when not present' do
    let(:id) { 'does-not-exist' }

    it { expect_invalid }
  end
end
