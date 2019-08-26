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

FactoryBot.define do
  factory :user do
    sequence(:id) { |n| "usr_#{n}" }
    sequence(:external_id) { |n| "user_external_id_#{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }

    after(:create) do |instance|
      instance.organization_users << FactoryBot.create(:organization_user, organization: first_or_create(:organization), user: instance) if instance.organizations.empty?
    end

    trait :admin do
      is_admin { true }
    end

    trait :without_organization do
      after(:create) do |instance|
        instance.organization_users.destroy_all
      end
    end
  end
end
