# frozen_string_literal: true

module API
  module Search
    module V1
      class SearchController < API::Search::V1::BaseController
        before_action :ensure_valid_lib_resource_type
        before_action :set_ledger

        def search
          api_render(
            searcher,
            params: {
              ledger: ledger,
              original_url: request.original_url
            },
            serializer: LibSearchResultSerializer
          )
        end

        private

        def adaptor
          @adaptor ||= adaptor_builder.adaptor
        end

        def adaptor_builder
          @adaptor_builder ||= Util::AdaptorBuilder.new(ledger: ledger)
        end

        def ensure_valid_lib_resource_type
          return if LedgerSync.resources.keys.include?(lib_resource_type)

          raise_404(message: "#{lib_resource_type_param} is not a valid resource.")
        end

        def ledger
          @ledger ||= Ledger.find(params[:id], api: true)
        end

        def lib_resource
          @lib_resource ||= LedgerSync.resources.fetch(lib_resource_type)
        end

        def lib_resource_type
          @lib_resource_type ||= lib_resource_type_param.try(:singularize).try(:to_sym)
        end

        def lib_resource_type_param
          @lib_resource_type_param ||= params.fetch(:lib_resource_type, nil).try(:to_s)
        end

        def searcher
          @searcher ||= adaptor_builder
                        .searcher_klass_for(resource_type: lib_resource_type)
                        .new(
                          adaptor: adaptor,
                          query: params.fetch(:query, ''),
                          pagination: params.fetch(:pagination, {})
                        )
        end

        def set_ledger
          ledger
        end
      end
    end
  end
end
