# frozen_string_literal: true

module Forms
  module LedgerResources
    class UpsertLedgerID
      include Formify::Form

      attr_accessor :ledger_resource

      delegate_accessor :ledger,
                        :resource_ledger_id,
                        to: :ledger_resource

      validates_presence_of :ledger,
                            :ledger_resource,
                            :resource_external_id,
                            :resource_ledger_id,
                            :resource_type,
                            :resource

      initialize_with :ledger_resource, :resource_external_id, :resource_type do |attributes|
        self.ledger_resource ||= LedgerResource.find_or_initialize_by(
          ledger: attributes[:ledger],
          resource: resource
        )
      end

      def save
        with_advisory_lock_transaction(:ledger_resources, ledger_resource) do
          validate_or_fail
            .and_then { upsert_ledger_id }
            .and_then { success(ledger_resource) }
        end
      end

      private

      attr_accessor :resource_external_id, :resource_type

      def resource
        @resource ||= begin
          Resource.find_by(
            external_id: resource_external_id,
            type: resource_type
          )
        end
      end

      def upsert_ledger_id
        ledger_resource.save!
        success(ledger_resource)
      end
    end
  end
end
