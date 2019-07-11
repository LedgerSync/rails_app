# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    return if value.blank? && options[:allow_blank]
    return if value =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    record.errors.add(:attribute, 'does not look like a valid email.')
  end
end
