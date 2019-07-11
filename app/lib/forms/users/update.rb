# frozen_string_literal: true

module Forms
  module Users
    class Update
      include Formify::Form

      attr_accessor :user

      delegate_accessor :email,
                        :name,
                        to: :user

      validates_presence_of :email,
                            :name,
                            :user

      validates :email,
                email: true

      initialize_with :user

      def save
        with_advisory_lock_transaction(:users, user) do
          validate_or_fail
            .and_then { update_user }
            .and_then { success(user) }
        end
      end

      private

      def update_user
        user.save!
        success(user)
      end
    end
  end
end
