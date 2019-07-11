# frozen_string_literal: true

class NoUpstreamSyncValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    raise "#{attribute} for #{record} must be a Sync" unless value.is_a?(Sync)
    return unless value.unterminated_upstream_syncs?

    record.errors.add(:base, "Cannot sync (id: #{value.id}) with unterminated upstream syncs.")
  end
end
