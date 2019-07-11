# == Schema Information
#
# Table name: users
#
#  id          :string           not null, primary key
#  email       :string
#  is_admin    :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :string
#  external_id :string
#
# Indexes
#
#  index_users_on_account_id   (account_id)
#  index_users_on_external_id  (external_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

class User < ApplicationRecord
  include Serializable
  include ExternallyIdentifiable

  API_OBJECT = 'user'.freeze
  ID_PREFIX = 'usr'.freeze

  has_many :auth_tokens
  has_many :account_users
  has_many :accounts,
            through: :account_users
  has_many :ledger_resources,
            through: :accounts
end
