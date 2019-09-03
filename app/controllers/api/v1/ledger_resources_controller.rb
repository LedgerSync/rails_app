# frozen_string_literal: true

module API
  module V1
    class LedgerResourcesController < API::V1::BaseController
      def create
        Forms::LedgerResources::Create
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
        Forms::LedgerResources::Destroy
          .new(resource: resource)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def show
        api_render(resource)
      end

      def update
        Forms::LedgerResources::Update
          .new(
            resource_params.merge(
              organization: organization,
              resource: resource
            )
          )
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      private

      def ledger
        @ledger ||= Ledger.efind!(params[:ledger])
      end

      def resource
        @resource ||= Lesource.efind!(params[:resource])
      end

      def ledger_resource
        @ledger_resource ||= LedgerResource.find(params[:id], api: true)
      end

      def resource_params
        params
          .permit(
            :ledger,
            :resource,
            :resource_ledger_id
          )
      end
    end
  end
end
