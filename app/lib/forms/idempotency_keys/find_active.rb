# frozen_string_literal: true

module Forms
  module IdempotencyKeys
    class FindActive
      include Formify::Form

      attr_accessor :key

      validates_presence_of :key
      validates_presence_of :idempotency_key

      def save
        with_advisory_lock_transaction(:idempotency_keys, key) do
          validate_or_fail
            .and_then { success(idempotency_key) }
        end
      end

      private

      def idempotency_key
        @idempotency_key ||= IdempotencyKey
          .where(
            key: key
          ).where(
            'created_at >= ?', Time.zone.now - 24.hours
          ).first
      end
    end
  end
end
