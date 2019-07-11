class RoutingError < APIError
  def initialize
    super(
      "Invalid route. Please check that the path is typed correctly.",
      type: 'routing_error',
      status: 404
    )
  end
end
