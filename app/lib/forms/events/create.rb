# frozen_string_literal: true

module Forms
  module Events
    class Create
      include Formify::Form

      attr_accessor :event

      delegate_accessor :type,
                        :organization,
                        :event_object,
                        to: :event

      before_validation :set_data

      validates_presence_of :event_object,
                            :event,
                            :type,
                            :organization,
                            :data

      validate :validate_type

      initialize_with :event do
        self.event ||= Event.new
      end

      def save
        with_advisory_lock_transaction(:events, :create) do
          validate_or_fail
            .and_then { create_event }
            .and_then { success(event) }
        end
      end

      private

      delegate_accessor :data, to: :event

      def create_event
        event.retries = 0
        event.save!
        success(event)
      end

      def set_data
        self.data = event_object.try(:serialize).try(:to_json)
      end

      def validate_type
        return if Event::REGISTERED_TYPES.include?(type)

        errors.add(:type, 'is not a registered event type.')
      end
    end
  end
end
