# frozen_string_literal: true

class InvalidRequestError < APIError
  def initialize(message, **additional)
    super(
      message,
      **{
        see_docs: true,
        status: 400,
        type: 'invalid_request_error'
      }.merge(additional)
    )
  end
end
