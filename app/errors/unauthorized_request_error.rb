class UnauthorizedRequestError < APIError
  def initialize(message = nil, see_docs = true, is_public = false)
    if is_public
      message ||= 'Invalid publishable API token.'
    else
      message ||= 'Invalid API token.'
    end

    message += see_docs_text if see_docs
    super(message, type: 'unauthorized', status: 401)
  end
end
