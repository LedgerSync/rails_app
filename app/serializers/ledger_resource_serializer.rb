class LedgerResourceSerializer < APIObjectSerializer
  attributes :resource_ledger_id

  belongs_to :ledger
  belongs_to :resource
end
