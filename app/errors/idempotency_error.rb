class IdempotencyError < InvalidRequestError
  def initialize(message, idempotency_error_type:, **additional)
    super(
      message,
      **{
        idempotency_error_type: idempotency_error_type,
        sub_type: 'idempotency_error'
      }.merge(additional)
    )
  end
end
