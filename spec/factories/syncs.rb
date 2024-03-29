# == Schema Information
#
# Table name: syncs
#
#  id                          :string           not null, primary key
#  operation_method            :string
#  position                    :integer          not null
#  references                  :jsonb
#  resource_type               :string
#  status                      :integer          default("blocked"), not null
#  status_message              :text
#  without_create_confirmation :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  organization_id             :string
#  resource_external_id        :string
#  resource_id                 :string
#
# Indexes
#
#  index_syncs_on_organization_id  (organization_id)
#  index_syncs_on_resource_id      (resource_id)
#  index_syncs_on_status           (status)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (resource_id => resources.id)
#


FactoryBot.define do
  factory :sync do
    sequence(:id) { |n| "sync_#{n}" }
    organization { first_or_create(:organization) }
    sequence(:resource_external_id) { |n| "external_id_#{n}" }
    resource_type { 'customer' }
    operation_method { 'upsert' }
    references { Util::InputHelpers::Customer.new(external_id: resource_external_id).references }
    status { :blocked }
    status_message { nil }

    Sync.statuses.each do |use_status|
      trait use_status do
        status { use_status }
      end
    end

    trait :payment do
      resource_type { 'payment' }
    end

    trait :with_ledger do
      after(:create) do |instance|
        FactoryBot.create(:ledger, organization: instance.organization)
      end
    end
  end
end
