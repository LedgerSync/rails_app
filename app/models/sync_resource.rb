# frozen_string_literal: true

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

class SyncResource < ApplicationRecord
  include Identifiable

  API_OBJECT = 'sync_resource'
  ID_PREFIX = 'sync_rsrc'

  belongs_to :sync
  belongs_to :resource

  validates :data, presence: true

  scope :created_at_desc, -> { order(created_at: :desc) }
  scope :recent, ->(n = 5) { created_at_desc.limit(n) }
end
