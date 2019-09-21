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

class SyncSerializer < APIObjectSerializer
  attributes  :operation_method,
              :references,
              :resource_external_id,
              :resource_type,
              :status_message,
              :status

  belongs_to :organization
end
