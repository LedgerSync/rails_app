# frozen_string_literal: true

module Forms
  module Syncs
    class Skip
      include Formify::Form
      include Eventable

      attr_accessor :sync

      validates_presence_of :sync

      validate :validate_not_succeeded

      def save
        with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { skip }
            .and_then { schedule_next_sync }
            .and_then { success(sync) }
        end
      end

      private

      def schedule_next_sync
        next_sync = sync.next_sync
        return success if next_sync.blank?

        SyncJobs::Perform.perform_async(next_sync.id)
        success
      end

      def skip
        sync.update!(status: :skipped)
        log_event(object: sync, type: 'sync.skipped')
        success(sync)
      end

      def validate_not_succeeded
        return if sync.blank?
        return unless sync.succeeded?

        errors.add(:sync, 'cannot be skipped as it has already succeeded.')
      end
    end
  end
end
