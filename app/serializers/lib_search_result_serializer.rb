# frozen_string_literal: true

class LibSearchResultSerializer < ObjectSerializer
  set_id { |object| Fingerprintable::Fingerprinter.new(object: object).fingerprint }

  attributes :pagination, :query

  attribute :ledger do |_object, params|
    params[:ledger].id
  end

  attribute :next_page_pagination do |object|
    object.next_searcher.try(:pagination)
  end

  attribute :previous_page_pagination do |object|
    object.previous_searcher.try(:pagination)
  end

  attribute :resources do |object|
    LibResourceSerializer.new(object.resources).serializable_hash
  end
end
