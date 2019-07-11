# frozen_string_literal: true

module API
  module V1
    class UsersController < API::V1::BaseController
      before_action :set_user, only: %i[show update]

      def create
        Forms::Users::Create
          .new(user_create_params)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def show
        api_render(@user)
      end

      def update
        Forms::Users::Update
          .new(
            user_update_params.merge(
              user: @user
            )
          )
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      private

      def set_user
        @user = User.find(params[:id], api: true)
      end

      def user_create_params
        params
          .permit(
            :email,
            :external_id,
            :name
          )
      end

      def user_update_params
        params
          .permit(
            :email,
            :name
          )
      end
    end
  end
end
