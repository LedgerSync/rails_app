# == Schema Information
#
# Table name: users
#
#  id          :string           not null, primary key
#  email       :string
#  is_admin    :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :string
#  external_id :string
#
# Indexes
#
#  index_users_on_account_id   (account_id)
#  index_users_on_external_id  (external_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

FactoryBot.define do
  factory :user do
    sequence(:id) { |n| "usr_#{n}" }
    sequence(:external_id) { |n| "user_external_id_#{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }

    after(:create) do |instance|
      instance.account_users << FactoryBot.create(:account_user, account: first_or_create(:account), user: instance) if instance.accounts.empty?
    end

    trait :admin do
      is_admin { true }
    end

    trait :without_account do
      after(:create) do |instance|
        instance.account_users.destroy_all
      end
    end
  end
end
