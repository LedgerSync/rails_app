# frozen_string_literal: true

module Forms
  module SyncLedgerLogs
    class Create
      include Formify::Form
      attr_accessor :sync_ledger_log

      delegate_accessor :action,
                        :data,
                        :sync_ledger,
                        to: :sync_ledger_log

      validates_presence_of :action,
                            :data,
                            :sync_ledger,
                            :sync_ledger_log

      initialize_with do
        self.sync_ledger_log = SyncLedgerLog.new
      end

      def save
        with_advisory_lock_transaction(:sync_ledger_logs, :create) do
          validate_or_fail
            .and_then { create_sync_ledger_log }
            .and_then { success(sync_ledger_log) }
        end
      end

      private

      def create_sync_ledger_log
        sync_ledger_log.save!
        success(sync_ledger_log)
      end
    end
  end
end
