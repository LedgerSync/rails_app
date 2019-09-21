# frozen_string_literal: true

class NoUnapprovedCreatesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    raise "#{attribute} for #{record} must be a Sync" unless value.is_a?(Sync)
    return unless value.requires_create_confirmation?

    record.errors.add(:base, "Cannot sync (id: #{value.id}) with unapproved creates.")
  end
end
