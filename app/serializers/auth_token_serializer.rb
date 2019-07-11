# frozen_string_literal: true

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

class AuthTokenSerializer < APIObjectSerializer
  belongs_to :user
  attribute :url do |object|
    Util::Router.new.auth_token_url(object)
  end
  attribute :token, &:id
end
