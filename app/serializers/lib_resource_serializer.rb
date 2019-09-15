class LibResourceSerializer < ObjectSerializer
  set_id { |object| "#{object.class}/#{object.fingerprint}" }

  attributes :fingerprint, :ledger_id, :external_id

  attribute :attributes do |object|
    object.serialize_attributes
  end

  attribute :type do |object|
    LedgerSync.resources.key(object.class)
  end
end
