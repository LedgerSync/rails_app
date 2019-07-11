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
        with_advisory_lock_transaction(:sync_ledgers, sync_ledger) do
          validate_or_fail
            .and_then { sync_to_ledger }
            .and_then { save_new_ledger_resources }
            .and_then { update_local_ledger }
            .on_success { update_sync_ledger_status(:success) }
            .on_failure { update_sync_ledger_status(:failure) }
            .and_then { success(sync_ledger) }
        end
      end

      private

      delegate  :ledger,
                :sync,
                :sync_resources,
                to: :sync_ledger

      delegate :ledger_resources,
                to: :sync

      def adaptor
        @adaptor ||= Util::AdaptorBuilder.new(ledger: ledger).adaptor
      end

      def lib_sync
        @lib_sync ||= LedgerSync::Sync.new(
          adaptor: adaptor,
          method: sync.operation_method,
          resources_data: resources_data,
          resource_external_id: sync.resource_external_id,
          resource_type: sync.resource_type
        )
      end

      def lib_sync_result
        @lib_sync_result = lib_sync.perform
      end

      def operations
        @operations ||= lib_sync.operations
      end

      def resources_data
        @resources_data ||= begin
          ret = {}

          ledger_resources.each do |ledger_resource|
            resource = ledger_resource.resource
            sync_resource = sync_resources.find_by!(sync: sync, resource: resource)

            ret[resource.type] ||= {}
            ret[resource.type][resource.external_id] = {
              ledger_id: ledger_resource.resource_ledger_id,
              data: sync_resource.data
            }
          end

          ret
        end
      end

      def save_new_ledger_resources
        lib_sync_result.sync.operations.inject(success) do |result, op|
          result.and_then do
            resource = op.resource
            Forms::LedgerResources::UpsertLedgerID
              .new(
                ledger: ledger,
                resource_external_id: resource.external_id,
                resource_ledger_id: resource.ledger_id,
                resource_type: resource.class.resource_type
              )
              .save
          end
        end
      end

      def sync_to_ledger
        lib_sync_result
      end

      def update_local_ledger
        return success if adaptor.ledger_attributes_to_save.blank?

        ledger.update!(adaptor.ledger_attributes_to_save)

        success
      end

      def update_sync_ledger_status(status)
        if status == :success
          sync_ledger.update!(status: :succeeded)
        else
          sync_ledger.update!(status: :failed)
        end
      end

      def upsert_resources
        Forms::Syncs::UpsertResources.new(sync: sync).save
      end
    end
  end
end
