# frozen_string_literal: true

# == Schema Information
#
# Table name: syncs
#
#  id                          :string           not null, primary key
#  operation_method            :string
#  position                    :integer          not null
#  references                  :jsonb
#  resource_type               :string
#  status                      :integer          default("blocked"), not null
#  status_message              :text
#  without_create_confirmation :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  organization_id             :string
#  resource_external_id        :string
#  resource_id                 :string
#
# Indexes
#
#  index_syncs_on_organization_id  (organization_id)
#  index_syncs_on_resource_id      (resource_id)
#  index_syncs_on_status           (status)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (resource_id => resources.id)
#

class Sync < ApplicationRecord
  include Serializable
  include Identifiable

  API_OBJECT = 'sync'
  ID_PREFIX = 'sync'

  enum status: {
    blocked: 0,
    queued: 1,
    succeeded: 2,
    failed: 3,
    skipped: 4
  }

  belongs_to :organization
  belongs_to :resource,
              required: false

  has_many :sync_ledgers
  has_many :ledgers,
           through: :sync_ledgers
  has_many :sync_ledger_logs,
           through: :sync_ledgers
  has_many :sync_resources
  has_many  :resources,
            through: :sync_resources
  has_many :ledger_resources,
           through: :resources

  validates :references,
            presence: true
  validates :resource_type,
            presence: true
  validates :operation_method,
            presence: true

  scope :created_at_desc, -> { order(created_at: :desc) }
  scope :not_terminated, -> { where.not(status: Sync.statuses.values_at(:succeeded, :failed, :skipped)) }
  scope :not_succeeded, -> { where.not(status: Sync.statuses.values_at(:succeeded)) }
  scope :not_succeeded_or_skipped, -> { where.not(status: Sync.statuses.values_at(:succeeded, :skipped)) }
  scope :not_failed, -> { where.not(status: Sync.statuses.values_at(:failed)) }

  def next_sync
    organization.syncs.where('position > ?', position).order(position: :asc).first
  end

  def parents
    organization
      .syncs
      .where('position < ?', position)
  end

  def parent_blocker
    parents.not_succeeded_or_skipped.order(position: :asc).first
  end

  def requires_create_confirmation?
    !without_create_confirmation && unapproved_creates?
  end

  def self_reference
    references.fetch(resource_type, {}).fetch(resource_external_id, nil)
  end

  def terminated?
    succeeded? || failed? || skipped?
  end

  def unterminated_upstream_syncs
    parents.not_terminated
  end

  def unterminated_upstream_syncs?
    unterminated_upstream_syncs.any?
  end

  def unapproved_creates
    ledger_resources.creates.not_approved
  end

  def unapproved_creates?
    unapproved_creates.any?
  end
end
