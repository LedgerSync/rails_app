# == Schema Information
#
# Table name: sync_ledgers
#
#  id         :string           not null, primary key
#  status     :integer          default("blocked"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ledger_id  :string
#  sync_id    :string
#
# Indexes
#
#  index_sync_ledgers_on_ledger_id              (ledger_id)
#  index_sync_ledgers_on_status                 (status)
#  index_sync_ledgers_on_sync_id                (sync_id)
#  index_sync_ledgers_on_sync_id_and_ledger_id  (sync_id,ledger_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ledger_id => ledgers.id)
#  fk_rails_...  (sync_id => syncs.id)
#

FactoryBot.define do
  factory :sync_ledger do
    ledger { first_or_create(:ledger) }
    sync { first_or_create(:sync) }
  end
end
