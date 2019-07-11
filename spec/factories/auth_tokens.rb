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

FactoryBot.define do
  factory :auth_token do
    sequence(:id) { |n| "at_#{n}" }
    user { first_or_create(:user) }

    trait :used do
      used_at { Time.zone.now }
    end
  end
end
