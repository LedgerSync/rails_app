# frozen_string_literal: true

module Forms
  module Ledgers
    module QuickBooksOnline
      class RefreshToken
        include Formify::Form

        attr_accessor :ledger

        delegate_accessor :access_token,
                          :expires_at,
                          :refresh_token,
                          to: :ledger

        validates_presence_of :access_token,
                              :expires_at,
                              :ledger,
                              :refresh_token

        initialize_with :ledger

        def save
          with_advisory_lock_transaction(:ledgers, ledger) do
            validate_or_fail
              .and_then { refresh_ledger_token }
              .and_then { success(ledger) }
          end
        end

        private

        def adaptor
          @adaptor ||= Util::AdaptorBuilder.new(ledger: ledger).adaptor
        end

        def refresh_ledger_token
          ledger.update!(adaptor.refresh!.ledger_attributes_to_save)

          success(ledger)
        end
      end
    end
  end
end
