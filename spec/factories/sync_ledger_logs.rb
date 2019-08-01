# == Schema Information
#
# Table name: sync_ledger_logs
#
#  id             :string           not null, primary key
#  action         :string           not null
#  data           :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sync_ledger_id :string
#
# Indexes
#
#  index_sync_ledger_logs_on_sync_ledger_id  (sync_ledger_id)
#
# Foreign Keys
#
#  fk_rails_...  (sync_ledger_id => sync_ledgers.id)
#

FactoryBot.define do
  factory :sync_ledger_log do
    sync_ledger { nil }
    data { "" }
  end
end
