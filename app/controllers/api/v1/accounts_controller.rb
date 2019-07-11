# frozen_string_literal: true

module API
  module V1
    class AccountsController < API::V1::BaseController
      before_action :set_account, only: %i[add_user remove_user show update]

      def add_user
        find_user
          .and_then { |user| do_add_user(user: user) }
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def create
        Forms::Accounts::Create
          .new(account_create_params)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def remove_user
        find_user
          .and_then { |user| do_remove_user(user: user) }
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def show
        api_render(@account)
      end

      def update
        Forms::Accounts::Update
          .new(
            account_update_params.merge(
              account: @account
            )
          )
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      private

      def find_user
        Forms::Users::Find.new(
          id: params[:user_id]
        ).save
      end

      def account_create_params
        params
          .permit(
            :external_id,
            :name
          )
      end

      def account_update_params
        params
          .permit(
            :name
          )
      end

      def do_add_user(user:)
        Forms::Accounts::AddUser
          .new(
            account: @account,
            user: user
          )
          .save
      end

      def do_remove_user(user:)
        Forms::Accounts::RemoveUser
          .new(
            account: @account,
            user: user
          )
          .save
      end

      def set_account
        @account = Account.find(params[:id], api: true)
      end
    end
  end
end
