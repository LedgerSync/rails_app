# == Schema Information
#
# Table name: accounts
#
#  id          :string           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string
#
# Indexes
#
#  index_accounts_on_external_id  (external_id) UNIQUE
#

FactoryBot.define do
  factory :account do
    sequence(:external_id) { |n| "account_external_id_#{n}" }
    sequence(:name) { |n| "name-#{n}" }
  end
end
