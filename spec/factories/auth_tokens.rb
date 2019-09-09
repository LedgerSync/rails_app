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

FactoryBot.define do
  factory :auth_token do
    sequence(:id) { |n| "at_#{n}" }
    resource { first_or_create(:user) }

    trait :used do
      used_at { Time.zone.now }
    end
  end
end
