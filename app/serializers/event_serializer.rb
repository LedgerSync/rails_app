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

class EventSerializer < APIObjectSerializer
  attributes :data, :type

  belongs_to :organization

  def data
    event_object.serialize
  end
end
