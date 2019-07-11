# == Schema Information
#
# Table name: resources
#
#  id          :string           not null, primary key
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :string
#  external_id :string
#
# Indexes
#
#  index_resources_on_account_id            (account_id)
#  index_resources_on_external_id_and_type  (external_id,type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#

FactoryBot.define do
  factory :resource do
    account { first_or_create(:account) }
    sequence(:external_id) { |n| "external_id_#{n}" }
    type { :customer }
  end
end
