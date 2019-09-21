# frozen_string_literal: true

module API
  module V1
    class SyncsController < API::V1::BaseController
      before_action :set_sync, only: %i[retry show skip]

      def create
        Forms::Syncs::Create
          .new(sync_create_params)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def retry
        Forms::Syncs::Retry
          .new(sync: @sync)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      def show
        api_render(@sync)
      end

      def skip
        Forms::Syncs::Skip
          .new(sync: @sync)
          .save
          .on_success(&method(:api_render))
          .raise_if_error
      end

      private

      def set_sync
        @sync = Sync.find(params[:id], api: true)
      end

      def sync_create_params
        params
          .permit(
            :organization_external_id,
            :operation_method,
            :resource_external_id,
            :resource_type,
            :without_create_confirmation,
            references: {}
          )
      end
    end
  end
end
