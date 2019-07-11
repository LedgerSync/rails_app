# frozen_string_literal: true

module API
  module Renderable
    def api_render(obj, status: 200, serializer: nil)
      raise InvalidRequestError, obj.error.message if obj.is_a?(Resonad::Failure)

      obj = obj.value if obj.is_a?(Resonad::Success)

      render(json: api_as_json(obj, serializer: serializer), status: status)
    end

    def api_as_json(obj, serializer: nil)
      return obj if obj.is_a?(Hash)

      serializer ||= obj.serializer
      raw_json = serializer.new(obj).as_json['data']
      # return raw_json['attributes'] if raw_json.is_a?(Hash)

      # {
      #   object: 'list',
      #   data: raw_json.map { |e| e['attributes'] }
      # }
      raw_json['attributes']
    end

    # def api_render_error(_error)
    #   attribute = record.errors.first.first

    #   if attribute == :base
    #     raise InvalidRequestError, record.errors.full_messages.first
    #   else
    #     raise ParamValueError,
    #           attribute,
    #           message: record.errors.full_messages_for(attribute).first
    #   end
    # end
  end
end
