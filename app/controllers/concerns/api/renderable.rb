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
      serializer.new(obj).serializable_hash
    end
  end
end
