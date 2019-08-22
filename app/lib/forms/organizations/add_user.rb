# frozen_string_literal: true

module Forms
  module Organizations
    class AddUser
      include Formify::Form

      attr_accessor :organization,
                    :user

      validates_presence_of :organization,
                            :user

      validate :validate_organization_user_not_present

      def save
        with_advisory_lock_transaction(:organizations, organization) do
          validate_or_fail
            .and_then { add_user }
        end
      end

      private

      def add_user
        success(OrganizationUser.create!(organization: organization, user: user))
      end

      def validate_organization_user_not_present
        return if OrganizationUser.where(organization: organization, user: user).blank?

        errors.add(:base, 'User already belongs to this organization.')
      end
    end
  end
end
