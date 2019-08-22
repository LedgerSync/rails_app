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

require 'rails_helper'

RSpec.describe Organization, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
