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

class SyncLedgerLog < ApplicationRecord
  include Identifiable

  API_OBJECT = 'sync_ledger_log'.freeze
  ID_PREFIX = 'sync_ldgr_log'.freeze

  belongs_to :sync_ledger
end
