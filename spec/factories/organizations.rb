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

FactoryBot.define do
  factory :organization do
    sequence(:external_id) { |n| "organization_external_id_#{n}" }
    sequence(:name) { |n| "name-#{n}" }
  end
end
