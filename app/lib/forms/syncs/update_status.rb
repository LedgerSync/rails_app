# frozen_string_literal: true

module Forms
  module Syncs
    class UpdateStatus
      include Formify::Form
      include Eventable

      attr_accessor :sync

      validates_presence_of :sync

      def save
        with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { update_status }
            .and_then { success(sync) }
        end
      end

      private

      def update_status
        return success if sync.terminated?

        if sync.requires_create_confirmation?
          sync.update!(status: :blocked)
          log_event(
            object: sync,
            type: 'sync.blocked'
          )
        else
          sync.update!(status: :queued)
          log_event(
            object: sync,
            type: 'sync.queued'
          )
        end

        success(sync)
      end
    end
  end
end
