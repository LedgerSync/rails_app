# frozen_string_literal: true

module Forms
  module Ledgers
    module QuickBooksOnline
      class Create
        include Formify::Form

        attr_accessor :ledger

        delegate_accessor :account,
                          :access_token,
                          :expires_at,
                          :refresh_token,
                          to: :ledger

        before_validation :set_kind

        validates_presence_of :access_token,
                              :account,
                              :code,
                              :expires_at,
                              :kind,
                              :realm_id,
                              :refresh_token,
                              :response,
                              :state

        validate :validate_kind

        initialize_with :ledger do |_attributes|
          self.ledger ||= Ledger.new(kind: :quickbooks_online)
          self.ledger.data ||= {}
        end

        def save
          with_advisory_lock_transaction(:accounts, account, :ledgers) do
            validate_or_fail
              .and_then { create_ledger }
              .and_then { success(ledger) }
          end
        end

        def code
          ledger.data['code']
        end

        def code=(val)
          ledger.data['code'] = val
        end

        def realm_id
          ledger.data['realm_id']
        end

        def realm_id=(val)
          ledger.data['realm_id'] = val
        end

        def response
          ledger.data['response']
        end

        def response=(val)
          ledger.data['response'] = val
        end

        def state
          ledger.data['state']
        end

        def state=(val)
          ledger.data['state'] = val
        end

        private

        delegate_accessor :kind,
                          to: :ledger

        def create_ledger
          ledger.save!

          success(ledger)
        end

        def set_kind
          self.kind = :quickbooks_online
        end

        def validate_kind
          return if kind.try(:to_sym) == :quickbooks_online

          raise 'This ledger must be quickbooks_online'
        end
      end
    end
  end
end