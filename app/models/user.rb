# == Schema Information
#
# Table name: users
#
#  id              :string           not null, primary key
#  email           :string
#  is_admin        :boolean
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  external_id     :string
#  organization_id :string
#
# Indexes
#
#  index_users_on_external_id      (external_id) UNIQUE
#  index_users_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class User < ApplicationRecord
  include Serializable
  include ExternallyIdentifiable

  API_OBJECT = 'user'.freeze
  ID_PREFIX = 'usr'.freeze

  has_many  :auth_tokens,
            as: :resource
  has_many :organization_users
  has_many :organizations,
            through: :organization_users
  has_many :ledger_resources,
            through: :organizations
end
