# frozen_string_literal: true

module Forms
  module Accounts
    class Create
      include Formify::Form

      attr_accessor :account

      delegate_accessor :external_id,
                        :name,
                        to: :account

      validates_presence_of :account,
                            :external_id,
                            :name

      validates :external_id,
                external_id: {
                  resource_attribute: :account
                }

      initialize_with :account do |_attributes|
        self.account = Account.new
      end

      def save
        with_advisory_lock_transaction(:accounts) do
          validate_or_fail
            .and_then { create_account }
            .and_then { success(account) }
        end
      end

      private

      def create_account
        account.save!
        success(account)
      end
    end
  end
end
