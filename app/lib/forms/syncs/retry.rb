# frozen_string_literal: true

module Forms
  module Syncs
    class Retry
      include Formify::Form
      attr_accessor :sync

      validates_presence_of :sync

      validate :validate_failure

      initialize_with :sync

      def save
        with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { retry_sync }
            .and_then { success(sync) }
        end
      end

      private

      def retry_sync
        sync.update!(status: :queued)
        Forms::Syncs::Perform.new(sync: sync).save
      end

      def validate_failure
        return if sync.blank?
        return if sync.failed?

        errors.add(:sync, 'must have failed to retry it.')
      end
    end
  end
end
