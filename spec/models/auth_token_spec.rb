# == Schema Information
#
# Table name: auth_tokens
#
#  id            :string           not null, primary key
#  resource_type :string
#  used_at       :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :string
#
# Indexes
#
#  index_auth_tokens_on_resource_id                    (resource_id)
#  index_auth_tokens_on_resource_id_and_resource_type  (resource_id,resource_type)
#

require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
