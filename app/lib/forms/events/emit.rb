# frozen_string_literal: true

module Forms
  module Events
    class Emit
      include Formify::Form
      attr_accessor :event

      validates_presence_of :event

      initialize_with :event

      def save
        validate_or_fail
          .and_then { emit }
          .and_then { success(event) }
      end

      private

      delegate  :data,
                :id,
                :organization,
                to: :event

      def headers
        @headers ||= {
          'X-Signature' => signature,
          'Content-Type' => 'application/json',
          'X-Organization-ID' => organization.id,
          'X-Event-ID' => id
        }
      end

      def emit
        return success(event) unless url.present?

        response = HTTP.headers(headers).post(url, body: serialized_event_json_string)
        status = response.status

        return failure(status.inspect) unless status.success?

        success(event)
      end

      def serialized_event_json_string
        @serialized_event_json_string ||= event.serialize.to_json
      end

      def signature
        @signature ||= Util::WebhookSigner.new(data: serialized_event_json_string).signature
      end

      def url
        @url ||= Settings.application.webhooks.url
      end
    end
  end
end
