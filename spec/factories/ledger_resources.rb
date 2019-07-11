# == Schema Information
#
# Table name: ledger_resources
#
#  id                 :string           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  approved_by_id     :string
#  ledger_id          :string
#  resource_id        :string
#  resource_ledger_id :string
#
# Indexes
#
#  index_ledger_resources_on_approved_by_id             (approved_by_id)
#  index_ledger_resources_on_ledger_id                  (ledger_id)
#  index_ledger_resources_on_resource_id                (resource_id)
#  index_ledger_resources_on_resource_id_and_ledger_id  (resource_id,ledger_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (approved_by_id => users.id)
#  fk_rails_...  (ledger_id => ledgers.id)
#  fk_rails_...  (resource_id => resources.id)
#

FactoryBot.define do
  factory :ledger_resource do
    # sequence(:id) { |n| "ldgr_rsrc_#{n}" }
    ledger { first_or_create(:ledger) }
    resource { first_or_create(:resource) }

    trait :approved do
      approved_by { first_or_create(:user) }
    end

    trait :with_sync do
      after(:create) do |instance|
        FactoryBot.create(:sync_resource, resource: instance.resource)
      end
    end
  end
end
