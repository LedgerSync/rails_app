# frozen_string_literal: true

module API
  module V1
    class OrganizationsController < API::V1::BaseController
      before_action :set_organization, only: %i[add_user remove_user show update]

      def add_user
        find_user
          .and_then { |user| do_add_user(user: user) }
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def create
        Forms::Organizations::Create
          .new(organization_create_params)
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
        api_render(@organization)
      end

      def update
        Forms::Organizations::Update
          .new(
            organization_update_params.merge(
              organization: @organization
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

      def organization_create_params
        params
          .permit(
            :external_id,
            :name
          )
      end

      def organization_update_params
        params
          .permit(
            :name
          )
      end

      def do_add_user(user:)
        Forms::Organizations::AddUser
          .new(
            organization: @organization,
            user: user
          )
          .save
      end

      def do_remove_user(user:)
        Forms::Organizations::RemoveUser
          .new(
            organization: @organization,
            user: user
          )
          .save
      end

      def set_organization
        @organization = Organization.find(params[:id], api: true)
      end
    end
  end
end
