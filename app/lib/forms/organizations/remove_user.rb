# frozen_string_literal: true

module Forms
  module Organizations
    class RemoveUser
      include Formify::Form

      attr_accessor :organization,
                    :user

      validates_presence_of :organization,
                            :user

      validate :validate_organization_user_present

      def save
        with_advisory_lock_transaction(:organizations, organization) do
          validate_or_fail
            .and_then { remove_user }
        end
      end

      private

      def organization_user
        @organization_user ||= OrganizationUser.find_by(organization: organization, user: user)
      end

      def remove_user
        success(organization_user.destroy!)
      end

      def validate_organization_user_present
        return if organization_user.present?

        errors.add(:base, 'User does not belong to this organization.')
      end
    end
  end
end
