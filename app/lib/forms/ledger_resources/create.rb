# frozen_string_literal: true

module Forms
  module LedgerResources
    class Create
      include Formify::Form
      attr_accessor :ledger_resource

      delegate_accessor :ledger,
                        :resource,
                        :resource_ledger_id,
                        to: :ledger_resource

      validates_presence_of :ledger,
                            :ledger_resource,
                            :resource,
                            :resource_ledger_id

      validate :validate_ledger_resource_does_not_exist

      initialize_with do |_attributes|
        self.ledger_resource ||= LedgerResource.new
      end

      def save
        with_advisory_lock_transaction(:ledger_resources) do
          validate_or_fail
            .and_then { create_ledger_resource }
            .and_then { success(ledger_resource) }
        end
      end

      private

      def create_ledger_resource
        ledger_resource.save!
        success(ledger_resource)
      end

      def validate_ledger_resource_does_not_exist
        return unless LedgerResource.exists?(ledger: ledger, resource: resource)

        errors.add(:base, 'This resource for this ledger already exists.')
      end
    end
  end
end
