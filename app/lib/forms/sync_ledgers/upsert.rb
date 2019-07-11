# frozen_string_literal: true

module Forms
  module SyncLedgers
    class Upsert
      include Formify::Form

      attr_accessor :sync_ledger

      delegate_accessor :ledger,
                        :sync,
                        to: :sync_ledger

      validates_presence_of :ledger,
                            :sync,
                            :sync_ledger

      initialize_with :sync_ledger do |attributes|
        self.sync_ledger ||= SyncLedger.find_or_initialize_by(
          ledger: attributes[:ledger],
          sync: attributes[:sync]
        )
      end

      def save
        with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { upsert_sync_ledger }
            .and_then { upsert_resources }
            .and_then { success(sync_ledger) }
        end
      end

      private

      def upsert_resources
        Forms::SyncLedgers::UpsertResources.new(
          sync_ledger: sync_ledger
        ).save
      end

      def upsert_sync_ledger
        sync_ledger.save!
        success(sync_ledger)
      end
    end
  end
end
