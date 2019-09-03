# frozen_string_literal: true

class ResourceTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    return if value.nil? && options[:allow_nil]

    keys = LedgerSync.resources.keys
    return if keys.include?(value.try(:to_sym))

    record.errors.add(attribute, "must be one of the following valid resource types: #{keys.join(', ')}")
  end
end
