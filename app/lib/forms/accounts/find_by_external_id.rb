# frozen_string_literal: true

module Forms
  module Accounts
    class FindByExternalID
      include Formify::Form

      attr_accessor :external_id

      validates_presence_of :external_id,
                            :account

      def save
        validate_or_fail
          .and_then { success(account) }
      end

      private

      def account
        @account ||= Account.find_by(external_id: external_id)
      end
    end
  end
end
