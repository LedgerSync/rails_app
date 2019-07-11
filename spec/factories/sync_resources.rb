# == Schema Information
#
# Table name: sync_resources
#
#  id          :string           not null, primary key
#  data        :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  resource_id :string
#  sync_id     :string
#
# Indexes
#
#  index_sync_resources_on_resource_id              (resource_id)
#  index_sync_resources_on_sync_id                  (sync_id)
#  index_sync_resources_on_sync_id_and_resource_id  (sync_id,resource_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (resource_id => resources.id)
#  fk_rails_...  (sync_id => syncs.id)
#


FactoryBot.define do
  factory :sync_resource do
    data { Util::InputHelpers::Customer.new.data }
    sync { first_or_create(:sync) }
    resource { first_or_create(:resource) }
  end
end
