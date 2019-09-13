class APIObjectSerializer
  include FastJsonapi::ObjectSerializer

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

  datetime :created_at
  datetime :updated_at
end
