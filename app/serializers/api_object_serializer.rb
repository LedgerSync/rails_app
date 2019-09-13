class APIObjectSerializer
  include FastJsonapi::ObjectSerializer

  # def self.belongs_to(object_attr, serializer:)
  #   attribute object_attr do |object|
  #     serializer.new(object_attr).as_json['data']['attributes']
  #   end
  # end

  # def self.belongs_to(object_attr)
  #   attribute object_attr do |object|
  #     object.send(object_attr).try(:id)
  #   end
  # end

  def self.date(object_attr)
    attribute object_attr do |object|
      object.send(object_attr).to_s
    end
  end

  def self.datetime(object_attr)
    attribute object_attr do |object|
      object.send(object_attr).to_i
    end
  end

  def self.decorator_attribute(object_attr)
    attribute object_attr do |object|
      object.decorate.send(object_attr)
    end
  end

  def self.decorator_attributes(*object_attrs)
    object_attrs.each do |object_attr|
      decorator_attribute object_attr
    end
  end

  # def self.has_one(object_attr, serializer:)
  #   attribute object_attr do |object|
  #     serializer.new(object_attr).as_json['data']['attributes']
  #   end
  # end

  # def self.has_many(object_attr, serializer:)
  #   attribute object_attr do |object|
  #     object.send(object_attr).map do |object_attr_instance|
  #       serializer.new(object_attr_instance).as_json['data']['attributes']
  #     end
  #   end
  # end

  # attribute :id

  # attribute :object do |object|
  #   object.class::API_OBJECT
  # end

  datetime :created_at
  datetime :updated_at
end
