class NoSuchRecordError < APIError
  def initialize(object_type, param = 'id', external_id: false)
    msg = if external_id
            "No such #{object_type.to_s.downcase} with matching id or external_id"
          else
            "No such #{object_type.to_s.downcase}"
          end

    super(
      msg,
      param: param,
      type: 'no_such_record',
      status: 404
    )
  end
end
