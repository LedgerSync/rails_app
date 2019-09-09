# frozen_string_literal: true

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

class AuthTokenSerializer < APIObjectSerializer
  belongs_to :resource
  attribute :resource_type
  attribute :url do |object|
    Util::Router.new.auth_token_url(object)
  end
  attribute :token, &:id
end
