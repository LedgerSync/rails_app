# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id          :string           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string
#
# Indexes
#
#  index_organizations_on_external_id  (external_id) UNIQUE
#

class Organization < ApplicationRecord
  include ExternallyIdentifiable
  include Serializable

  API_OBJECT = 'organization'
  ID_PREFIX = 'acct'

  has_many :ledgers
  has_many :users
  has_many :syncs
  has_many :resources
  has_many :sync_resources,
           through: :syncs
  has_many :ledger_resources,
           through: :ledgers

  has_many :organization_users
  has_many :users,
            through: :organization_users
end
