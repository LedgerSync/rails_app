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

class SyncSerializer < APIObjectSerializer
  attributes  :operation_method,
              :references,
              :resource_external_id,
              :resource_type,
              :status_message,
              :status

  belongs_to :account
end
