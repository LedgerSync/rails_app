# frozen_string_literal: true

module Forms
  module Organizations
    class Create
      include Formify::Form

      attr_accessor :organization

      delegate_accessor :external_id,
                        :name,
                        to: :organization

      validates_presence_of :organization,
                            :external_id,
                            :name

      validates :external_id,
                external_id: {
                  resource_attribute: :organization
                }

      initialize_with :organization do |_attributes|
        self.organization = Organization.new
      end

      def save
        with_advisory_lock_transaction(:organizations) do
          validate_or_fail
            .and_then { create_organization }
            .and_then { success(organization) }
        end
      end

      private

      def create_organization
        organization.save!
        success(organization)
      end
    end
  end
end
