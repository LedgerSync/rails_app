# == Schema Information
#
# Table name: events
#
#  id                :string           not null, primary key
#  data              :text
#  event_object_type :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  event_object_id   :string
#  organization_id   :string
#
# Indexes
#
#  index_events_on_event_object_id_and_event_object_type  (event_object_id,event_object_type)
#  index_events_on_organization_id                        (organization_id)
#  index_events_on_type                                   (type)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class Event < ApplicationRecord
  include Identifiable
  include Serializable

  self.inheritance_column = nil # Disable STI using the type column

  API_OBJECT = 'event'.freeze
  ID_PREFIX = 'evnt'.freeze
  REGISTERED_TYPES = [
    'sync.blocked',
    'sync.created',
    'sync.failed',
    'sync.queued',
    'sync.succeeded'
  ].freeze

  belongs_to            :organization
  belongs_to            :event_object,
                        polymorphic: true

  validates_presence_of :data,
                        :event_object,
                        :event_object_id,
                        :event_object_type,
                        :organization,
                        :type
end
