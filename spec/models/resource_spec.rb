# == Schema Information
#
# Table name: resources
#
#  id          :string           not null, primary key
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :string
#  external_id :string
#
# Indexes
#
#  index_resources_on_account_id            (account_id)
#  index_resources_on_external_id_and_type  (external_id,type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

require 'rails_helper'

RSpec.describe Resource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
