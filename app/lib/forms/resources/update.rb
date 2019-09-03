# frozen_string_literal: true

module Forms
  module Resources
    class Update
      include Formify::Form
      attr_accessor :resource

      delegate_accessor :external_id,
                        :organization,
                        :type,
                        to: :resource

      validates_presence_of :external_id,
                            :organization,
                            :resource,
                            :type

      validates :type,
                resource_type: true

      validates :external_id,
                external_id: {
                  resource_attribute: :resource
                }

      initialize_with :resource

      def save
        with_advisory_lock_transaction(:resources) do
          validate_or_fail
            .and_then { update_resource }
            .and_then { success(resource) }
        end
      end

      private

      def update_resource
        resource.save!
        success(resource)
      end
    end
  end
end
