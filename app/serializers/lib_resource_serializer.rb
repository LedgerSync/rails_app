# frozen_string_literal: true

class LibResourceSerializer < ObjectSerializer
  set_id { |object| "#{object.class}/#{object.fingerprint}" }

  attributes :fingerprint, :ledger_id, :external_id

  attribute :attributes, &:serialize_attributes

  attribute :type do |object|
    LedgerSync.resources.key(object.class)
  end
end
