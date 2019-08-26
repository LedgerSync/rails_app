# frozen_string_literal: true

module Eventable # :nodoc:
  extend ActiveSupport::Concern

  included do
    def log_event(object:, organization: nil, type:)
      registered_events = [
        'sync.created',
        'sync.deleted',
        'sync.failed',
        'sync.succeeded',
        'sync.updated'
      ]

      raise "Event type not recognized: #{type}" unless registered_events.include?(type)

      organization ||= object.organization

      raise "No organization for event: #{type}" if organization.blank?

      EventJobs::CreateAndEmit.perform_async(
        data: object.serialize,
        organization: organization.id,
        type: type
      )
    end
  end
end
