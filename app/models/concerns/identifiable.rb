# frozen_string_literal: true

module Identifiable
  extend ActiveSupport::Concern

  included do
    before_validation :populate_id
  end

  module ClassMethods
    # include_root_in_json = false

    def find(val, api: false, param: :id)
      ret = nil
      ret ||= find_by(id: val)
      ret ||= find_by(external_id: val) if column_names.include?('external_id')

      if ret.blank?
        raise NoSuchRecordError.new(self::API_OBJECT, param) if api

        raise ActiveRecord::RecordNotFound
      end

      ret
    end
  end

  def populate_id(override: false)
    return if !override && id.present?

    set_unique_token(:id, self.class::ID_PREFIX)
  end

  def set_unique_token(field, prefix = '', n = 16)
    return unless send(field).blank?

    10.times do
      break unless send(field).blank? || self.class.exists?(field => self[field])

      self[field] = if prefix.present?
                      prefix + '_' + SecureRandom.urlsafe_base64(n).gsub(/[_\-=O]/, '')
                    else
                      SecureRandom.urlsafe_base64(n).gsub(/[_\-=O]/, '')
                    end
    end
  end
end
