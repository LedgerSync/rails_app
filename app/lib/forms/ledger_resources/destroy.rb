# frozen_string_literal: true

module Forms
  module LedgerResources
    class Destroy
      include Formify::Form
      attr_accessor :ledger_resource

      validates_presence_of :ledger_resource

      initialize_with :ledger_resource

      def save
        with_advisory_lock_transaction(:ledger_resources) do
          validate_or_fail
            .and_then { destroy }
            .and_then { success(ledger_resource) }
        end
      end

      private

      def destroy
        ledger_resource.destroy!
        success(ledger_resource)
      end
    end
  end
end
