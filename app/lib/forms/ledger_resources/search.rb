# frozen_string_literal: true

module Forms
  module LedgerResources
    class Search
      include Formify::Form

      attr_accessor :ledger_resource,
                    :pagination,
                    :q

      validates_presence_of :ledger_resource

      def save
        validate_or_fail
          .and_then { search }
      end

      private

      delegate  :ledger,
                :resource,
                to: :ledger_resource

      def adaptor
        @adaptor ||= Util::AdaptorBuilder.new(ledger: ledger).adaptor
      end

      def search
        searcher_klass.new(
          adaptor: adaptor,
          pagination: pagination,
          query: q
        ).search
      end

      def searcher_klass
        @searcher_klass ||= adaptor.searcher_klass_for(resource_type: resource.type)
      end
    end
  end
end
