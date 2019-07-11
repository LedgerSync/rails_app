# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::IdempotencyKeys::FindActive, type: :form do
  include Formify::SpecHelpers

  let(:idempotency_key) { FactoryBot.create(:idempotency_key) }
  let(:key) { idempotency_key.key }

  let(:attributes) do
    {
      key: key
    }
  end

  it { expect_valid } # Expect the form to be valid
  it { expect(result).to be_success }
  it { expect(value).to be_a(IdempotencyKey) } # Model name inferred

  describe '#key' do
    it { expect_error_with_missing_attribute(:key) }
  end

  context 'when key does not exist' do
    let(:key) { 'asdf' }

    it { expect_invalid }
  end

  context 'when key expired' do
    before { idempotency_key.update!(created_at: idempotency_key.created_at - 25.hours) }

    it { expect_invalid }
  end
end
