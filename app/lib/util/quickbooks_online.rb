module Util
  class QuickBooksOnline
    KEY = LedgerSync.adaptors.quickbooks_online.root_key.to_s.freeze

    module Helpers
      module ClassMethods
        def grant_url
          oauth_client.auth_code.authorize_url(
            redirect_uri: Settings.adaptors.quickbooks_online.oauth_redirect_uri,
            response_type: 'code',
            state: SecureRandom.hex(12),
            scope: 'com.intuit.quickbooks.organizationing'
          )
        end

        def oauth_client
          @oauth_client ||= begin
            client_id = Settings.adaptors.quickbooks_online.oauth_client_id
            client_secret = Settings.adaptors.quickbooks_online.oauth_client_secret

            oauth_params = {
              site: 'https://appcenter.intuit.com/connect/oauth2',
              authorize_url: 'https://appcenter.intuit.com/connect/oauth2',
              token_url: 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer'
            }
            OAuth2::Client.new(client_id, client_secret, oauth_params)
          end
        end
      end

      class << self
        def included(base)
          base.extend ClassMethods # what would this be for?
        end
      end
    end

    include Helpers
  end
end