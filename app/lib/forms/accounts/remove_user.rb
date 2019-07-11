# frozen_string_literal: true

module Forms
  module Accounts
    class RemoveUser
      include Formify::Form

      attr_accessor :account,
                    :user

      validates_presence_of :account,
                            :user

      validate :validate_account_user_present

      def save
        with_advisory_lock_transaction(:accounts, account) do
          validate_or_fail
            .and_then { remove_user }
        end
      end

      private

      def account_user
        @account_user ||= AccountUser.find_by(account: account, user: user)
      end

      def remove_user
        success(account_user.destroy!)
      end

      def validate_account_user_present
        return if account_user.present?

        errors.add(:base, 'User does not belong to this account.')
      end
    end
  end
end
