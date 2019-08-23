# frozen_string_literal: true

module Forms
  module Events
    class Notify
      include Formify::Form
      attr_accessor :event,
                    :url

      validates_presence_of :event,
                            :url

      initialize_with :event, :url

      def save
        validate_or_fail
          .and_then { notify }
          .and_then { success(event) }
      end

      private

      delegate  :data,
                to: :event

      def headers
        @headers ||= {
          'X-Signature' => signature,
          'Content-Type' => 'application/json',
          'X-Organization-ID' => event.organization.id,
          'X-Event-ID' => event.id
        }
      end

      def notify
        response = HTTP.headers(headers).post(url, body: body)
        status = response.status

        return failure(status.inspect) unless status.success?

        success(event)
      end

      def signature
        @signature ||= Util::WebhookSigner.new(data: data)
      end
    end
  end
end
