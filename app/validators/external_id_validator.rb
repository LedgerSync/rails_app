# frozen_string_literal: true

class ExternalIDValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    raise 'resource_attribute required.' if options[:resource_attribute].blank?

    resource = record.send(options[:resource_attribute])
    resource_klass = resource.class

    if value.blank?
      record.errors.add(:external_id, 'is missing.')
    elsif value.starts_with?(resource_klass.id_prefix)
      record.errors.add(:external_id, "cannot start with #{resource_klass.id_prefix}.")
    elsif resource.new_record? && resource_klass.where(external_id: value).any?
      record.errors.add(:external_id, 'has already been taken.')
    elsif !resource.new_record? && resource_klass.where.not(id: resource.id).where(external_id: value).any?
      record.errors.add(:external_id, 'has already been taken.')
    end
  end
end
