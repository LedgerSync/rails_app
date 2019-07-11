# frozen_string_literal: true

module Forms
  module SyncLedgers
    class UpsertResources
      include Formify::Form

      attr_accessor :sync_ledger

      validates_presence_of :sync_ledger

      initialize_with :sync_ledger

      def save
        with_advisory_lock_transaction(:sync_ledgers, sync_ledger) do
          validate_or_fail
            .and_then { upsert_resources }
            .and_then { success(sync_ledger) }
        end
      end

      private

      delegate  :ledger,
                :sync,
                to: :sync_ledger
      delegate  :resources,
                to: :sync

      def upsert_resources
        resources.inject(success) do |result, resource|
          result.and_then do
            Forms::LedgerResources::Upsert.new(
              ledger: ledger,
              resource: resource
            ).save
          end
        end

        success(sync_ledger)
      end
    end
  end
end
