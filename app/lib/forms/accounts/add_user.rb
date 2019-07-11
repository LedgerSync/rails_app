# frozen_string_literal: true

module Forms
  module Accounts
    class AddUser
      include Formify::Form

      attr_accessor :account,
                    :user

      validates_presence_of :account,
                            :user

      validate :validate_account_user_not_present

      def save
        with_advisory_lock_transaction(:accounts, account) do
          validate_or_fail
            .and_then { add_user }
        end
      end

      private

      def add_user
        success(AccountUser.create!(account: account, user: user))
      end

      def validate_account_user_not_present
        return if AccountUser.where(account: account, user: user).blank?

        errors.add(:base, 'User already belongs to this account.')
      end
    end
  end
end
