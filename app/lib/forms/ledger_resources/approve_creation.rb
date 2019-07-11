# frozen_string_literal: true

module Forms
  module LedgerResources
    class ApproveCreation
      include Formify::Form

      attr_accessor :ledger_resource

      delegate_accessor :approved_by,
                        to: :ledger_resource

      validates_presence_of :approved_by,
                            :ledger_resource

      initialize_with :ledger_resource

      def save
        with_advisory_lock_transaction(:ledger_resources, ledger_resource) do
          validate_or_fail
            .and_then { approve_creation }
            .and_then { schedule_perform_for_all_syncs }
            .and_then { update_sync_statuses }
            .and_then { success(ledger_resource) }
        end
      end

      private

      def approve_creation
        ledger_resource.save!
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
    end
  end
end
