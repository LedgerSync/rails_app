class ExpiredTokenError < APIError
  def initialize
    super('API token has expired.', type: 'unauthorized', status: 498)
  end
end
