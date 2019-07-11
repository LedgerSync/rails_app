# frozen_string_literal: true

module ExternallyIdentifiable
  extend ActiveSupport::Concern

  module ClassMethods
    def external_id_invalid_message
      "cannot start with '#{self::ID_PREFIX}_'"
    end

    def external_id_valid?(external_id)
      external_id !~ /\A#{self::ID_PREFIX}_/
    end

    def id_prefix
      "#{self::ID_PREFIX}_"
    end
  end

  included do |base|
    include Identifiable
    base.extend ClassMethods

    validates :external_id,
              uniqueness: true

    validate :external_id_does_not_use_prefix

    private

    def external_id_valid?
      self.class.external_id_valid?(external_id)
    end

    def external_id_does_not_use_prefix
      return if external_id_valid?

      errors.add(:external_id, self.class.external_id_invalid_message)
    end
  end
end
