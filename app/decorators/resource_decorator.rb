class ResourceDecorator < ApplicationDecorator # :nodoc:
  def type
    @type ||= object.type.titleize
  end
end
