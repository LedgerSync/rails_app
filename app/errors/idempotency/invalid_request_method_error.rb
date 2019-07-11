# frozen_string_literal: true

module Idempotency
  class PostAndPutRequestsOnlyError < IdempotencyError
    def initialize
      super(
        'You can only use Idempotency Keys with POST and PUT requests.',
        idempotency_error_type: :post_requests_only
      )
    end
  end
end
