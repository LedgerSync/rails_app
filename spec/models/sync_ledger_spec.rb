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

require 'rails_helper'

RSpec.describe SyncLedger, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
