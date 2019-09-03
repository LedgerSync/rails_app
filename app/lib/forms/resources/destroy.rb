# frozen_string_literal: true

module Forms
  module Resources
    class Destroy
      include Formify::Form
      attr_accessor :resource

      validates_presence_of :resource

      validate :validate_no_sync_resources

      initialize_with :resource

      def save
        with_advisory_lock_transaction(:resources) do
          validate_or_fail
            .and_then { destroy }
            .and_then { success(resource) }
        end
      end

      private

      def destroy
        resource.destroy!
        success(resource)
      end

      def validate_no_sync_resources
        return if resource.try(:sync_resources).blank?

        errors.add(:base, 'You cannot delete a resource that is associated with existing syncs.')
      end
    end
  end
end
