# frozen_string_literal: true

module API
  module V1
    class LedgerResourcesController < API::V1::BaseController
      def create
        Forms::LedgerResources::Create
          .new(
            ledger_resource_params.merge(
              ledger: ledger,
              resource: resource
            )
          )
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def destroy
        Forms::LedgerResources::Destroy
          .new(ledger_resource: ledger_resource)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def show
        api_render(ledger_resource)
      end

      def update
        Forms::LedgerResources::Update
          .new(
            ledger_resource_params.merge(
              ledger_resource: ledger_resource
            )
          )
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      private

      def ledger
        @ledger ||= Ledger.find(params[:ledger], api: true)
      end

      def resource
        @resource ||= Resource.efind!(params[:resource], api: true)
      end

      def ledger_resource
        @ledger_resource ||= LedgerResource.find(params[:id], api: true)
      end

      def ledger_resource_params
        params
          .permit(
            :resource_ledger_id
          )
      end
    end
  end
end
