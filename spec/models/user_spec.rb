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

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
