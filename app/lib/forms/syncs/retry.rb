# frozen_string_literal: true

module Forms
  module Syncs
    class Retry
      include Formify::Form
      include Eventable

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
        log_event(object: sync, type: 'sync.retried')
        log_event(object: sync, type: 'sync.queued')
        SyncJobs::Perform.perform_async(sync.id)
        success
      end

      def validate_failure
        return if sync.blank?
        return if sync.failed?

        errors.add(:sync, 'must have failed to retry it.')
      end
    end
  end
end
