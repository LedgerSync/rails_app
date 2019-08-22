# frozen_string_literal: true
module Util
  module InputHelpers
    class Customer

      attr_accessor :external_id

      def initialize(external_id: SecureRandom.uuid)
        self.external_id = external_id
      end

      def data
        {
          name: "Test Customer #{external_id}",
          email: 'test@example.com'
        }
      end

      def reference(ledger_id: nil, merge: {}, merge_data: {})
        {
          "ledger_id": ledger_id,
          "data": data.merge(merge_data)
        }.merge(merge)
      end

      def references
        {
          "customer": {
            external_id => reference
          }
        }
      end

      def sync_request_body(organization: nil)
        {
          organization_external_id: organization.external_id,
          resource_external_id: external_id,
          resource_type: 'customer',
          operation_method: 'upsert',
          references: references
        }
      end
    end

    class Payment
      attr_accessor :customer, :external_id

      def initialize(customer: nil, external_id: SecureRandom.uuid)
        self.customer = customer || Customer.new
        self.external_id = external_id
      end

      def data
        {
          "amount": 1234,
          "currency": 'usd',
          "customer": customer.external_id
        }
      end

      def reference(merge_data: {}, ledger_id: nil, merge: {})
        {
          "ledger_id": ledger_id,
          "data": data.merge(merge_data)
        }.merge(merge)
      end

      def references
        {
          "payment": {
            external_id => reference
          },
          "customer": {
            customer.external_id => customer.reference
          }
        }
      end

      def sync_request_body(organization: nil)
        {
          "organization_external_id": organization.external_id,
          "resource_external_id": external_id,
          "resource_type": 'payment',
          "operation_method": 'upsert',
          "references": references
        }
      end
    end
  end
end