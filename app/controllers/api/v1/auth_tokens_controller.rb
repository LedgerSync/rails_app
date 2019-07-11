# frozen_string_literal: true

module API
  module V1
    class AuthTokensController < API::V1::BaseController
      before_action :set_user

      def create
        Forms::AuthTokens::Create.new(user: @user).save
                                 .on_success { |auth_token| api_render(auth_token) }
                                 .raise_if_error
      end

      private

      def set_user
        @user = User.find(params[:user_id], api: true)
        no_such_record(:user) if @user.blank?
      end
    end
  end
end
