# frozen_string_literal: true

require 'rails_helper'

describe 'idempotency', type: :api do
  let(:user) { FactoryBot.create(:user) }
  let(:path) { "users/#{user.external_id}/auth_tokens" }
  let(:auth_token) { FactoryBot.create(:auth_token, user: user) }
  let(:params) { { 'user_id' => user.external_id, 'foo' => 'bar' } }

  def do_post
    api_post path, params: params
  end

  it do
    do_post
    expect_401
  end

  context 'with authorization', :with_authorization do
    it do
      do_post
      expect_idempotency_error(idempotency_error_type: 'idempotency_key_required')
    end

    context 'when using idempotency' do
      it do
        with_idempotency(key: 'asdf') do
          expect { do_post }.to change(AuthToken, :count).from(0).to(1)
          idempotency_key = IdempotencyKey.first
          expect(idempotency_key.request_body).to include(params)
        end
      end

      it do
        with_idempotency(key: 'asdf') do
          expect { do_post }.to change(AuthToken, :count).from(0).to(1)
          expect { do_post }.not_to change(AuthToken, :count)
        end
      end

      it do
        with_idempotency(key: 'asdf') do
          expect { do_post }.to change(AuthToken, :count).from(0).to(1)

          Timecop.freeze(Time.zone.now + 25.hours) do
            expect { do_post }.to change(AuthToken, :count).from(1).to(2)
          end
        end
      end

      it do
        with_idempotency(key: 'asdf') do
          expect { do_post }.to change(AuthToken, :count).from(0).to(1)
          do_post
          expect_idempotency_error(idempotency_error_type: :duplicate_idempotent_request)
        end
      end
    end
  end
end
