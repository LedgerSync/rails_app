# frozen_string_literal: true

module Forms
  module Resources
    class UpsertLedgerResources
      include Formify::Form

      attr_accessor :resource

      validates_presence_of :resource

      def save
        with_advisory_lock_transaction(:foo) do
          validate_or_fail
            .and_then { upsert_ledger_resource_resource }
            .and_then { success(resource) }
        end
      end

      private

      delegate  :account,
                to: :resource

      delegate  :ledgers,
                to: :account

      def upsert_ledger_resource_resource
        ledgers.inject(success) do |result, ledger|
          result.and_then do
            Forms::LedgerResources::Upsert.new(
              ledger: ledger,
              resource: resource
            ).save
          end
        end

        success(resource)
      end
    end
  end
end
