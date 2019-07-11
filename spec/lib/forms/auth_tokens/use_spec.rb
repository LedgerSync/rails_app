# frozen_string_literal: true

require 'rails_helper'
require 'formify/spec_helpers'

describe Forms::AuthTokens::Use, type: :form do
  include Formify::SpecHelpers

  let(:auth_token) { FactoryBot.create(:auth_token) }

  let(:attributes) do
    {
      token: auth_token.id
    }
  end

  it { expect(result).to be_success }
  it { expect(value).to be_a(AuthToken) }
  it { expect(value).to eq(auth_token) }

  context 'when used' do
    let(:auth_token) { FactoryBot.create(:auth_token, :used) }

    it { expect(result).to be_failure }
    it { expect_error_message(t('auth_tokens.use.failure.already_used')) }
  end
end
