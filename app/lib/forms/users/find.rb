# frozen_string_literal: true

module Forms
  module Users
    class Find
      include Formify::Form

      attr_accessor :id

      validates_presence_of :id,
                            :user

      def save
        validate_or_fail
          .and_then { success(user) }
      end

      private

      def user
        @user ||= User.find_by(id: id) || User.find_by(external_id: id)
      end
    end
  end
end
