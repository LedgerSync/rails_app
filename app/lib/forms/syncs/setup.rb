# frozen_string_literal: true

module Forms
  module Syncs
    class Setup
      include Formify::Form

      attr_accessor :sync

      validates_presence_of :sync

      def save
        result = with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { destroy_sync_resources(sync) }
            .and_then { |sync| upsert_resources(sync) }
            .and_then { |sync| set_sync_resource(sync) }
            .and_then { |sync| upsert_sync_ledgers(sync) }
            .and_then { success(sync) }
        end

        result.and_then { |sync| schedule_perform_sync(sync) }
              .and_then { success(sync) }
      end

      private

      def destroy_sync_resources(sync)
        Forms::Syncs::DestroySyncResources
          .new(sync: sync)
          .save
      end

      def schedule_perform_sync(sync)
        SyncJobs::Perform.perform_async(sync.id)
        success(sync)
      end

      def set_sync_resource(sync)
        sync.update!(
          resource: sync.resources.find_by!(
            external_id: sync.resource_external_id,
            type: sync.resource_type
          )
        )

        success(sync)
      end

      def upsert_resources(sync)
        result = Forms::Syncs::UpsertResources
                 .new(sync: sync)
                 .save

        result
      end

      def upsert_sync_ledgers(sync)
        Forms::Syncs::UpsertSyncLedgers
          .new(sync: sync)
          .save
      end
    end
  end
end
