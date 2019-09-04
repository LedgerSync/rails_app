# == Schema Information
#
# Table name: ledger_resources
#
#  id                 :string           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  approved_by_id     :string
#  ledger_id          :string
#  resource_id        :string
#  resource_ledger_id :string
#
# Indexes
#
#  index_ledger_resources_on_approved_by_id             (approved_by_id)
#  index_ledger_resources_on_ledger_id                  (ledger_id)
#  index_ledger_resources_on_resource_id                (resource_id)
#  index_ledger_resources_on_resource_id_and_ledger_id  (resource_id,ledger_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (approved_by_id => users.id)
#  fk_rails_...  (ledger_id => ledgers.id)
#  fk_rails_...  (resource_id => resources.id)
#

class LedgerResourceSerializer < APIObjectSerializer
  attributes :resource_ledger_id

  belongs_to :ledger
  belongs_to :resource
end
