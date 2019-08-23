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
#  organization_id   :bigint(8)
#
# Indexes
#
#  index_events_on_event_object_id_and_event_object_type  (event_object_id,event_object_type)
#  index_events_on_organization_id                        (organization_id)
#  index_events_on_type                                   (type)
#

FactoryBot.define do
  factory :event do
    data { { foo: :bar } }
    event_object { first_or_create(:sync) }
    organization { first_or_create(:organization) }
    type { 'sync.succeeded' }
  end
end
