# frozen_string_literal: true

module Forms
  module SyncLedgers
    class Perform
      include Formify::Form

      attr_accessor :sync_ledger

      before_validation :upsert_resources

      validates_presence_of :ledger,
                            :resources_data,
                            :sync

      validates :sync,
                no_upstream_sync: true,
                no_unapproved_creates: true,
                not_succeeded: true

      initialize_with :sync_ledger

      def save
        with_advisory_lock(:sync_ledgers, sync_ledger) do
          validate_or_fail
            .and_then { sync_to_ledger }
            .on_success { sync_ledger.update!(status: :succeeded) }
            .on_failure { sync_ledger.update!(status: :failed) }
            .and_then { success(sync_ledger) }
        end
      end

      private

      delegate  :ledger,
                :sync,
                :sync_resources,
                to: :sync_ledger

      delegate  :ledger_resources,
                to: :sync

      def lib_sync
        @lib_sync ||= LedgerSync::Sync.new(
          adaptor: sync_ledger.adaptor,
          method: sync.operation_method,
          resources_data: resources_data,
          resource_external_id: sync.resource_external_id,
          resource_type: sync.resource_type
        )
      end

      def log(action:, data:)
        SyncLedgerLogs::Create.new(
          action: action,
          data: data,
          sync_ledger: sync_ledger
        ).save.raise_if_error
      end

      def resources_data
        @resources_data ||= sync_ledger.resources_data
      end

      def save_new_ledger_resources
        @lib_sync_result.sync.operations.each do |op|
          resource = op.resource
          Forms::LedgerResources::UpsertLedgerID
            .new(
              ledger: ledger,
              resource_external_id: resource.external_id,
              resource_ledger_id: resource.ledger_id,
              resource_type: resource.class.resource_type
            )
            .save
            .on_failure { log(action: :sync, data: op.serialize) }
        end
        success
      end

      def sync_to_ledger
        @lib_sync_result = lib_sync.perform

        log(action: :sync, data: @lib_sync_result.serialize)
        save_new_ledger_resources
        update_local_ledger

        @lib_sync_result
      end

      def update_local_ledger
        return success if sync_ledger.adaptor.ledger_attributes_to_save.blank?

        ledger.update!(lib_sync.adaptor.ledger_attributes_to_save)
        success
      end

      def upsert_resources
        Forms::Syncs::UpsertResources.new(sync: sync).save
      end
    end
  end
end
