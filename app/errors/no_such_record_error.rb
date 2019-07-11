class NoSuchRecordError < APIError
  def initialize(object_type, param = 'id')
    super(
      "No such #{object_type.to_s.downcase}",
      param: param,
      type: 'no_such_record',
      status: 404
    )
  end
end
