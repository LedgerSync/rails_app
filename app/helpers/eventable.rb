# frozen_string_literal: true

module Eventable # :nodoc:
  extend ActiveSupport::Concern

  included do
    def log_event(object:, organization: nil, type:)
      raise "Event type not recognized: #{type}" unless Event::REGISTERED_TYPES.include?(type)

      organization ||= object.organization

      raise "No organization for event: #{type}" if organization.blank?

      EventJobs::CreateAndEmit.perform_async(
        object.serialize,
        object.class.name,
        object.id,
        organization.id,
        type
      )
    end
  end
end
