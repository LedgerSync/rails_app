# frozen_string_literal: true

# == Schema Information
#
# Table name: ledgers
#
#  id              :string           not null, primary key
#  access_token    :string
#  connected_by    :string
#  data            :jsonb
#  disconnected_at :datetime
#  disconnected_by :string
#  expires_at      :datetime
#  kind            :string
#  refresh_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :string
#
# Indexes
#
#  index_ledgers_on_account_id       (account_id)
#  index_ledgers_on_connected_by     (connected_by)
#  index_ledgers_on_disconnected_at  (disconnected_at)
#  index_ledgers_on_disconnected_by  (disconnected_by)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (connected_by => users.id)
#  fk_rails_...  (disconnected_by => users.id)
#

class Ledger < ApplicationRecord
  include Identifiable

  API_OBJECT = 'ledger'
  ID_PREFIX = 'ldgr'

  belongs_to :account

  has_many :sync_ledgers
  has_many :syncs,
           through: :sync_ledgers
  has_many :ledger_resources
  has_many :resources,
           through: :ledger_resources

  scope :connected, -> { where(disconnected_at: nil) }
  scope :disconnected, -> { where.not(disconnected_at: nil) }

  def connected?
    !disconnected?
  end

  def disconnected?
    disconnected_at.present?
  end
end
