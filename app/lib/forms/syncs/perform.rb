# frozen_string_literal: true

module Forms
  module Syncs
    class Perform
      include Formify::Form

      attr_accessor :sync

      validates_presence_of :sync

      validate :validate_not_terminated

      initialize_with :sync

      def save
        with_advisory_lock_transaction(account, :syncs) do
          validate_or_fail
            .and_then { perform_sync }
            .and_then { schedule_next_if_succeeded }
            .and_then { success(sync) }
        end
      end

      private

      delegate  :account,
                :next_sync,
                :sync_ledgers,
                to: :sync

      delegate  :ledgers,
                to: :account

      def schedule_next_if_succeeded
        return success unless sync.succeeded?
        return success unless next_sync.present?

        SyncJobs::Perform.perform_async(next_sync.id)

        success
      end

      def perform_sync
        if sync_ledger_forms.reject(&:valid?).empty?
          sync_ledger_forms
            .inject(success) { |res, form| res.and_then { form.save } }
            .on_success { sync.update!(status: :succeeded) }
            .on_failure { sync.update!(status: :failed) }
        else
          sync_ledger_forms.map(&:save)
        end

        success(sync)
      end

      def sync_ledger_forms
        @sync_ledger_forms ||= sync_ledgers.map do |sync_ledger|
          Forms::SyncLedgers::Perform.new(
            sync_ledger: sync_ledger
          )
        end
      end

      def validate_not_terminated
        return unless sync.succeeded? || sync.failed?

        raise DevError.new(
          'Sync has already terminated.',
          sync_id: sync.id,
          sync_status: sync.status,
          sync_status_message: sync.status_message
        )
      end
    end
  end
end
