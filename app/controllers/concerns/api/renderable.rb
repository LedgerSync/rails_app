# frozen_string_literal: true

module API
  module Renderable
    def api_render(obj, params: {}, status: 200, serializer: nil)
      raise InvalidRequestError, obj.error.message if obj.is_a?(Resonad::Failure)

      obj = obj.value if obj.is_a?(Resonad::Success)
      serializer ||= obj.serializer

      render(
        json: serializer.new(
          obj,
          params: params
        ).serializable_hash,
        status: status
      )
    end
  end
end
