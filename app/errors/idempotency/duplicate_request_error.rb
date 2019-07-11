# frozen_string_literal: true

module Idempotency
  class DuplicateRequestError < IdempotencyError
    def initialize(idempotency_key)
      super(
        "The idempotency key (#{idempotency_key}) has already been used with a different request body.",
        idempotency_error_type: :duplicate_idempotent_request,
        idempotency_key: idempotency_key
      )
    end
  end
end
