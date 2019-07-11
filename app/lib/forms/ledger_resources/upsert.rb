# frozen_string_literal: true

module Forms
  module LedgerResources
    class Upsert
      include Formify::Form

      attr_accessor :ledger_resource

      delegate_accessor :ledger,
                        :resource,
                        to: :ledger_resource

      validates_presence_of :ledger,
                            :ledger_resource,
                            :resource

      initialize_with :ledger_resource do |attributes|
        self.ledger_resource ||= LedgerResource.find_or_initialize_by(
          ledger: attributes[:ledger],
          resource: attributes[:resource]
        )
      end

      def save
        with_advisory_lock_transaction(:ledger_resources, ledger, :resources, resource) do
          validate_or_fail
            .and_then { upsert_ledger_resource }
            .and_then { success(ledger_resource) }
        end
      end

      private

      def upsert_ledger_resource
        ledger_resource.save!
        success(ledger_resource)
      end
    end
  end
end
