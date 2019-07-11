# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::Ledgers::QuickBooksOnline::RefreshToken, type: :form do
  include Formify::SpecHelpers

  let(:attributes) do
    {
      ledger: FactoryBot.create(:ledger)
    }
  end

  it { expect_valid } # Expect the form to be valid
  it { expect(result).to be_success }
  it { expect(value).to be_a(Ledger) } # Model name inferred
end
