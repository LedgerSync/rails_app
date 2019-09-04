# frozen_string_literal: true

module Forms
  module Resources
    class Create
      include Formify::Form
      include Eventable

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

      initialize_with :resource do |_attributes|
        self.resource ||= Resource.new
      end

      def save
        with_advisory_lock_transaction(:resources) do
          validate_or_fail
            .and_then { create_resource }
            .and_then { success(resource) }
        end
      end

      private

      def create_resource
        resource.save!
        success(resource)
      end
    end
  end
end
