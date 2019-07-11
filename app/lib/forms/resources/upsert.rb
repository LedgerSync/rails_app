# frozen_string_literal: true

module Forms
  module Resources
    class Upsert
      include Formify::Form

      attr_accessor :resource

      delegate_accessor :account,
                        :external_id,
                        :type,
                        to: :resource

      validates_presence_of :account,
                            :external_id,
                            :resource,
                            :type

      initialize_with :resource do |attributes|
        self.resource ||= Resource.find_or_initialize_by(
          account: attributes[:account],
          external_id: attributes[:external_id],
          type: attributes[:type]
        )
      end

      def save
        with_advisory_lock_transaction(:account, account, :resources, resource) do
          validate_or_fail
            .and_then { upsert_resource }
            .and_then { success(resource) }
        end
      end

      private

      def upsert_resource
        resource.save!
        success(resource)
      end
    end
  end
end
