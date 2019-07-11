# frozen_string_literal: true

module Forms
  module LedgerResources
    class SetResourceLedgerID
      include Formify::Form

      attr_accessor :ledger_resource, :resource_ledger_id

      validates_presence_of :ledger_resource,
                            :resource_ledger_id

      validate :validate_resource_ledger_id

      initialize_with :ledger_resource

      def save
        with_advisory_lock_transaction(:ledger_resources, ledger_resource) do
          validate_or_fail
            .and_then { upsert_resource_ledger_id }
            .and_then { success(ledger_resource) }
        end
      end

      private

      def upsert_resource_ledger_id
        ledger_resource.update!(
          resource_ledger_id: resource_ledger_id
        )
        success(ledger_resource)
      end

      def validate_resource_ledger_id
        return if ledger_resource.blank?
        return if ledger_resource.resource_ledger_id.blank?

        raise DevError.new(
          'resource_ledger_id already exists',
          ledger_resource_id: ledger_resource.id,
          resource_ledger_id: ledger_resource.resource_ledger_id
        )
      end
    end
  end
end
