# frozen_string_literal: true

module Forms
  module Syncs
    class UpsertSyncLedgers
      include Formify::Form

      attr_accessor :sync

      validates_presence_of :sync

      initialize_with :sync do |attributes|
        puts attributes
      end

      def save
        with_advisory_lock_transaction(:syncs, sync) do
          validate_or_fail
            .and_then { upsert_sync_ledgers }
            .and_then { success(sync) }
        end
      end

      private

      delegate :account,
               to: :sync

      delegate :ledgers,
               to: :account

      def upsert_sync_ledgers
        ledgers.inject(success) do |result, ledger|
          result.and_then do
            Forms::SyncLedgers::Upsert.new(
              ledger: ledger,
              sync: sync
            ).save
          end
        end
        success(sync)
      end
    end
  end
end
