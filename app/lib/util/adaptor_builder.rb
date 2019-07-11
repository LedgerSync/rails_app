module Util
  class AdaptorBuilder
    attr_reader :ledger

    def initialize(ledger:)
      @ledger = ledger
    end

    def adaptor
      @adaptor ||= adaptor_klass.new(
        access_token: ledger.access_token,
        client_id: Settings.adaptors.quickbooks_online.oauth_client_id,
        client_secret: Settings.adaptors.quickbooks_online.oauth_client_secret,
        realm_id: ledger.data['realm_id'],
        refresh_token: ledger.refresh_token,
        test: Rails.env.test? || Rails.env.development?
      )
    end

    def adaptor_klass
      @adaptor_klass ||= LedgerSync.adaptors.send(ledger.kind).adaptor_klass
    end

    def searcher_klass_for(resource_type:)
      adaptor.searcher_klass_for(resource_type: resource_type)
    end
  end
end
