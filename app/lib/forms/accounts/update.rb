# frozen_string_literal: true

module Forms
  module Accounts
    class Update
      include Formify::Form

      attr_accessor :account

      delegate_accessor :name,
                        to: :account

      validates_presence_of :account,
                            :name

      initialize_with :account

      def save
        with_advisory_lock_transaction(:accounts, account) do
          validate_or_fail
            .and_then { update_account }
            .and_then { success(account) }
        end
      end

      private

      def update_account
        account.save!
        success(account)
      end
    end
  end
end
