# == Schema Information
#
# Table name: auth_tokens
#
#  id         :string           not null, primary key
#  used_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string
#
# Indexes
#
#  index_auth_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
