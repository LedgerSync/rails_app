# frozen_string_literal: true

module Forms
  module Events
    class ScheduleRetry
      include Formify::Form
      attr_accessor :event

      validates_presence_of :event

      def save
        with_advisory_lock_transaction(:events, event) do
          validate_or_fail
            .and_then { schedule_retry }
            .and_then { success(event) }
        end
      end

      private

      def notify_provider
        redis = Redis.new
        key = 'webhooks/provider_last_notified_at'

        provider_last_notified_at = redis.get(key)

        return if provider_last_notified_at.present? && (Time.zone.now - Time.parse(provider_last_notified_at)) < 24.hours

        redis.set(key, Time.zone.now.to_s)
        DeveloperMailer.webhook_failure(event.id).deliver_later
      end

      def retry_back_off_in_seconds
        @retry_back_off_in_seconds ||= Settings.application.webhooks.retry_back_off_in_seconds
      end

      def retry_limit
        @retry_limit ||= Settings.application.webhooks.retry_limit
      end

      def schedule_retry
        return success(event) if event.retries.present? && event.retries >= retry_limit

        notify_provider

        event.retries ||= 0
        event.retries += 1
        wait_in_seconds = retry_back_off_in_seconds**event.retries
        EventJobs::Emit.perform_in(wait_in_seconds.seconds, event.id)

        success(event)
      end
    end
  end
end
