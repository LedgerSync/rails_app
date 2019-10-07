# frozen_string_literal: true

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

class SyncLedger < ApplicationRecord
  include Identifiable

  API_OBJECT = 'sync_ledger'
  ID_PREFIX = 'sync_ldgr'

  enum status: {
    blocked: 0,
    queued: 1,
    succeeded: 2,
    failed: 3
  }

  belongs_to :sync
  belongs_to :ledger

  has_many :sync_resources,
           through: :sync
  has_many :resources,
           through: :sync_resources
  has_many :ledger_resources,
           through: :ledger

  scope :created_at_desc, -> { order(created_at: :desc) }
  scope :not_terminated, -> { where.not(status: SyncLedger.statuses.values_at(:succeeded, :failed)) }
  scope :not_succeeded, -> { where.not(status: SyncLedger.statuses.values_at(:succeeded)) }
  scope :not_failed, -> { where.not(status: SyncLedger.statuses.values_at(:failed)) }

  def adaptor
    Util::AdaptorBuilder.new(ledger: ledger).adaptor
  end

  def resources_data
    ret = {}

    sync_resources.find_each do |sync_resource|
      resource = sync_resource.resource
      ledger_resource = ledger_resources.find_by!(ledger: ledger, resource: resource)

      ret[resource.type] ||= {}
      ret[resource.type][resource.external_id] = {
        ledger_id: ledger_resource.resource_ledger_id,
        data: sync_resource.data
      }
    end

    ret
  end
end
