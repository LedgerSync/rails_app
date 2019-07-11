# frozen_string_literal: true

class NotFailedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    raise "#{attribute} for #{record} must be a Sync" unless value.is_a?(Sync)
    return unless value.failed?

    record.errors.add(attribute, 'has already failed.')
  end
end
