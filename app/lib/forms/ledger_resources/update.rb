# frozen_string_literal: true

module Forms
  module LedgerResources
    class Update
      include Formify::Form
      attr_accessor :ledger_resource

      delegate_accessor :resource_ledger_id,
                        to: :ledger_resource

      validates_presence_of :ledger_resource,
                            :resource_ledger_id

      initialize_with :ledger_resource

      def save
        with_advisory_lock_transaction(:ledger_resources, ledger_resource) do
          validate_or_fail
            .and_then { update_ledger_resource }
            .and_then { success(ledger_resource) }
        end
      end

      private

      def update_ledger_resource
        ledger_resource.save!
        success(ledger_resource)
      end
    end
  end
end
