module Forms
  module AuthTokens
    class Create
      include Formify::Form

      attr_accessor :user, :auth_token

      validates_presence_of :auth_token,
                            :user

      def initialize(attributes = {})
        self.user = attributes[:user]
        self.auth_token = AuthToken.new(user: user)
      end

      def save
        with_advisory_lock_transaction do
          validate_or_fail
            .and_then { expire_old_tokens }
            .and_then { create_auth_token }
            .and_then { Resonad.Success(auth_token) }
        end
      end

      private

      def create_auth_token
        auth_token.save!
        Resonad.Success(auth_token)
      end

      def expire_old_tokens
        user.auth_tokens.not_used.find_each { |e| e.update!(used_at: Time.zone.now) }
        success
      end
    end
  end
end
