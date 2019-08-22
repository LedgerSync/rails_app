# frozen_string_literal: true

module Forms
  module Organizations
    class Update
      include Formify::Form

      attr_accessor :organization

      delegate_accessor :name,
                        to: :organization

      validates_presence_of :organization,
                            :name

      initialize_with :organization

      def save
        with_advisory_lock_transaction(:organizations, organization) do
          validate_or_fail
            .and_then { update_organization }
            .and_then { success(organization) }
        end
      end

      private

      def update_organization
        organization.save!
        success(organization)
      end
    end
  end
end
