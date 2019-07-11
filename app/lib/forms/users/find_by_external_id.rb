# frozen_string_literal: true

module Forms
  module Users
    class FindByExternalID
      include Formify::Form

      attr_accessor :external_id

      validates_presence_of :external_id,
                            :user

      def save
        validate_or_fail
          .and_then { success(user) }
      end

      private

      def user
        @user ||= User.find_by(external_id: external_id)
      end
    end
  end
end
