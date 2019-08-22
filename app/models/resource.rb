# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id              :string           not null, primary key
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  external_id     :string
#  organization_id :string
#
# Indexes
#
#  index_resources_on_external_id_and_type  (external_id,type) UNIQUE
#  index_resources_on_organization_id       (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class Resource < ApplicationRecord
  include Identifiable

  API_OBJECT = 'resource'
  ID_PREFIX = 'rsrc'

  belongs_to :organization

  has_many :ledger_resources
  has_many :ledgers,
           through: :ledger_resources
  has_many :sync_resources
  has_many :syncs,
           through: :sync_resources

  def self.inheritance_column
    nil
  end
end
