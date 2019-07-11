# frozen_string_literal: true

module Forms
  module AuthTokens
    class Use
      include Formify::Form

      attr_accessor :token

      validates_presence_of :auth_token,
                            :token

      validate :validate_not_used
      validate :validate_not_expired

      def save
        with_advisory_lock_transaction do
          validate_or_fail
            .and_then { success(auth_token) }
        end
      end

      private

      def auth_token
        return if token.blank?

        @auth_token ||= AuthToken.find_by(id: token)
      end

      def validate_not_expired
        return if auth_token.blank?
        return unless auth_token.expired?

        errors.add(:base, t('auth_tokens.use.failure.expired'))
      end

      def validate_not_used
        return if auth_token.blank?
        return unless auth_token.used?

        errors.add(:base, t('auth_tokens.use.failure.already_used'))
      end
    end
  end
end
