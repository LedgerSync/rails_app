# frozen_string_literal: true

module Forms
  module LedgerResources
    class Assign
      include Formify::Form

      attr_accessor :ledger_resource, :resource_ledger_id

      validates_presence_of :ledger_resource,
                            :resource_ledger_id

      validate :validate_ledger_resource_not_assigned
      initialize_with :ledger_resource

      def save
        with_advisory_lock_transaction(:ledger_resources, ledger_resource) do
          validate_or_fail
            .and_then { assign }
            .and_then { update_sync_statuses }
            .and_then { schedule_perform_for_all_syncs }
            .and_then { success(ledger_resource) }
        end
      end

      private

      def assign
        ledger_resource.update!(
          resource_ledger_id: resource_ledger_id
        )
        success(ledger_resource)
      end

      def schedule_perform_for_all_syncs
        ledger_resource.syncs.not_succeeded.find_each do |sync|
          SyncJobs::Perform.perform_async(sync.id)
        end
        success(ledger_resource)
      end

      def update_sync_statuses
        ledger_resource.syncs.find_each { |e| Forms::Syncs::UpdateStatus.new(sync: e).save }
        success
      end

      def validate_ledger_resource_not_assigned
        return if ledger_resource.resource_ledger_id.blank?

        errors.add(:resource_ledger_id, t('ledger_resources.assign.already_assigned'))
      end
    end
  end
end
