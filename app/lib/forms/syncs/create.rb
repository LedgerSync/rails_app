# frozen_string_literal: true

module Forms
  module Syncs
    class Create
      include Formify::Form

      attr_accessor :account_external_id,
                    :sync

      delegate_accessor :account,
                        :resource_external_id,
                        :resource_type,
                        :operation_method,
                        :references,
                        to: :sync

      before_validation :populate_account

      validates_presence_of :account_external_id,
                            :resource_external_id,
                            :resource_type,
                            :operation_method,
                            :references

      validate :validate_account

      initialize_with :account_external_id do |_attributes|
        self.sync = Sync.new
      end

      def save
        with_advisory_lock_transaction(:syncs, account, :create) do
          validate_or_fail
            .and_then { create_sync }
            .and_then { schedule_upsert_references }
            .and_then { success(sync) }
        end
      end

      private

      def create_sync
        sync.save!
        success(sync)
      end

      def schedule_upsert_references
        SyncJobs::SetupSync.perform_async(sync.id)
        success(sync)
      end

      def populate_account
        self.account = Account.find_by(external_id: account_external_id)
      end

      def validate_account
        return if account_external_id.blank?
        return if account.present?

        errors.add(:base, :test)
      end
    end
  end
end
