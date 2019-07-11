module Serializable
  extend ActiveSupport::Concern

  included do
    def serialize
      serializer.new(self).as_json['data']['attributes']
    end

    def serializer
      self.class.serializer
    end
  end

  class_methods do
    def serializer
      "#{name}Serializer".constantize
    end
  end
end
