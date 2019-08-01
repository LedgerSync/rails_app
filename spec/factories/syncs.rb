# == Schema Information
#
# Table name: syncs
#
#  id                   :string           not null, primary key
#  operation_method     :string
#  position             :integer          not null
#  references           :jsonb
#  resource_type        :string
#  status               :integer          default("blocked"), not null
#  status_message       :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :string
#  resource_external_id :string
#  resource_id          :string
#
# Indexes
#
#  index_syncs_on_account_id   (account_id)
#  index_syncs_on_resource_id  (resource_id)
#  index_syncs_on_status       (status)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (resource_id => resources.id)
#


FactoryBot.define do
  factory :sync do
    sequence(:id) { |n| "sync_#{n}" }
    account { first_or_create(:account) }
    sequence(:resource_external_id) { |n| "external_id_#{n}" }
    resource_type { 'customer' }
    operation_method { 'upsert' }
    references { Util::InputHelpers::Customer.new(external_id: resource_external_id).references }
    status { 0 }
    status_message { nil }

    trait :payment do
      resource_type { 'payment' }
    end

    trait :with_ledger do
      after(:create) do |instance|
        FactoryBot.create(:ledger, account: instance.account)
      end
    end
  end
end
