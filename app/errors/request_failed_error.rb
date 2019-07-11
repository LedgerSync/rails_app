class RequestFailedError < APIError
  def initialize(message = nil, additional = {})
    message ||= 'Something went wrong with your request.'
    super(message, status: 402, additional: additional)
  end
end
