# frozen_string_literal: true

module Forms
  module Users
    class Create
      include Formify::Form

      attr_accessor :user

      delegate_accessor :email,
                        :external_id,
                        :name,
                        to: :user

      validates_presence_of :email,
                            :external_id,
                            :name,
                            :user

      validates :email,
                email: true

      validates :external_id,
                external_id: {
                  resource_attribute: :user
                }

      initialize_with :user do |_attributes|
        self.user = User.new
      end

      def save
        with_advisory_lock_transaction(:users) do
          validate_or_fail
            .and_then { create_user }
            .and_then { success(user) }
        end
      end

      private

      def create_user
        user.save!
        success(user)
      end
    end
  end
end
