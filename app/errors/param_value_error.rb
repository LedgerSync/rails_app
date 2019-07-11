class ParamValueError < InvalidRequestError
  def initialize(param, message: nil)
    message ||= "Invalid value for param: #{param}"
    super(message, param: param)
  end
end
