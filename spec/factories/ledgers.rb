# == Schema Information
#
# Table name: ledgers
#
#  id              :string           not null, primary key
#  access_token    :string
#  connected_by    :string
#  data            :jsonb
#  disconnected_at :datetime
#  disconnected_by :string
#  expires_at      :datetime
#  kind            :string
#  refresh_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :string
#
# Indexes
#
#  index_ledgers_on_connected_by     (connected_by)
#  index_ledgers_on_disconnected_at  (disconnected_at)
#  index_ledgers_on_disconnected_by  (disconnected_by)
#  index_ledgers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (connected_by => users.id)
#  fk_rails_...  (disconnected_by => users.id)
#  fk_rails_...  (organization_id => organizations.id)
#

FactoryBot.define do
  factory :ledger do
    sequence(:id) { |n| "ldgr_#{n}" }
    kind { :test }
    organization { first_or_create(:organization) }
    access_token { :access_token }
    refresh_token { :refresh_token }
    expires_at { Time.zone.now + 1.week }
    data { {} }

    trait :quickbooks_online do
      kind { :quickbooks_online }
    end

    trait :test do
      kind { :test }
    end
  end
end
