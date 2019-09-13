# frozen_string_literal: true

module API
  module V1
    class ResourcesController < API::V1::BaseController
      def create
        Forms::Resources::Create
          .new(
            resource_params.merge(
              organization: organization
            )
          )
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def destroy
        Forms::Resources::Destroy
          .new(resource: resource)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def index
        api_render(paginate(Resource.all))
      end

      def show
        api_render(resource)
      end

      def update
        Forms::Resources::Update
          .new(
            resource_params.merge(
              resource: resource
            )
          )
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      private

      def organization
        @organization ||= Organization.find_by_id_or_external_id!(params[:organization], api: true)
      end

      def resource
        @resource ||= Resource.find(params[:id], api: true)
      end

      def resource_params
        params
          .permit(
            :external_id,
            :organization,
            :type
          )
      end
    end
  end
end
