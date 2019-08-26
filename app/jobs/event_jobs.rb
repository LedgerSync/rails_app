# frozen_string_literal: true

module EventJobs
  class CreateAndEmit < ApplicationJob
    def perform(data, event_object_type, event_object_id, organization_id, type)
      form = Forms::Events::Create.new(
        data: data,
        event_object: event_object_type.constantize.find(event_object_id),
        organization: Organization.find(organization_id),
        type: type
      )

      form.save
          .and_then { |event| EventJobs::Emit.perform_asycn(event.id) }
          .raise_if_error
    end
  end

  class Emit < ApplicationJob
    def perform(event_id)
      Forms::Event::Emit.new(
        event: Event.find(event_id)
      ).save.raise_if_error
    end
  end
end
