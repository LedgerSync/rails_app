# frozen_string_literal: true

module Forms
  module Syncs
    class DestroySyncResources
      include Formify::Form

      attr_accessor :sync

      validates_presence_of :sync

      def save
        with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { destroy_sync_resources }
            .and_then { success(sync) }
        end
      end

      private

      def destroy_sync_resources
        sync.sync_resources.destroy_all
        success(sync)
      end
    end
  end
end
