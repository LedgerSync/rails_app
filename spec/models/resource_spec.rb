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

require 'rails_helper'

RSpec.describe Resource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
