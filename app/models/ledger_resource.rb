# frozen_string_literal: true

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

class LedgerResource < ApplicationRecord
  include Serializable
  include Identifiable

  API_OBJECT = 'ledger_resource'
  ID_PREFIX = 'ldgr_rsrc'

  belongs_to :ledger
  belongs_to :resource
  belongs_to :approved_by,
             class_name: 'User',
             required: false

  has_one :account,
          through: :ledger

  has_many :sync_resources,
           through: :resource
  has_many :syncs,
           through: :sync_resources
  has_many :sync_ledgers,
            through: :syncs

  scope :creates, -> { where(resource_ledger_id: nil).or(where(resource_ledger_id: '')) }
  scope :approved, -> { where.not(approved_by_id: nil) }
  scope :not_approved, -> { where(approved_by_id: nil) }
  scope :todo, -> { creates.not_approved }

  def approved?
    approved_by.present?
  end

  def exists_in_ledger?
    resource_ledger_id.present?
  end

  def todo?
    !approved? && !exists_in_ledger?
  end
end
