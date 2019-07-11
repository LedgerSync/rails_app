class APIError < StandardError
  attr_accessor :status, :message

  def initialize(message = nil, see_docs: false, status: 500, type: :api_error, **additional)

    message ||= 'API request failed.  Ledger Sync App has been notified.'

    message += see_docs_text if see_docs

    @status = status
    @message = {
      error: {
        type: type,
        message: message
      }.merge(additional)
    }
  end

  def see_docs_text
    ' Please see API docs for more information.'
  end
end
