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

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
