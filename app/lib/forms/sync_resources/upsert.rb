# frozen_string_literal: true

module Forms
  module SyncResources
    class Upsert
      include Formify::Form

      attr_accessor :sync_resource

      delegate_accessor :data,
                        :resource,
                        :sync,
                        to: :sync_resource

      validates_presence_of :data,
                            :resource,
                            :sync,
                            :sync_resource

      initialize_with :sync_resource do |attributes|
        self.sync_resource ||= SyncResource.find_or_initialize_by(
          resource: attributes[:resource],
          sync: attributes[:sync]
        )
      end

      def save
        with_advisory_lock_transaction(:sync_resources, sync_resource) do
          validate_or_fail
            .and_then { upsert_sync_resource }
            .and_then { success(sync_resource) }
        end
      end

      private

      def upsert_sync_resource
        sync_resource.save!
        success(sync_resource)
      end
    end
  end
end
