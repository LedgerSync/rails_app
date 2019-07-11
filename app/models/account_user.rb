# == Schema Information
#
# Table name: account_users
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :string
#  user_id    :string
#
# Indexes
#
#  index_account_users_on_account_id              (account_id)
#  index_account_users_on_user_id                 (user_id)
#  index_account_users_on_user_id_and_account_id  (user_id,account_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

class AccountUser < ApplicationRecord
  include Serializable

  API_OBJECT = 'account_user'.freeze
  ID_PREFIX = 'acct_usr'.freeze

  belongs_to :account
  belongs_to :user

  validates :user,
            uniqueness: {
              scope: :account_id
            }
end
