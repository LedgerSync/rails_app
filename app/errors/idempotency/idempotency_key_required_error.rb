# frozen_string_literal: true

module Idempotency
  class IdempotencyKeyRequiredError < IdempotencyError
    def initialize
      super(
        'An idempotency key is required for all POST requests.',
        idempotency_error_type: :idempotency_key_required
      )
    end
  end
end
