# frozen_string_literal: true

class DeveloperMailer < ApplicationMailer
  def webhook_failure(event_id)
    @event = Event.find(event_id)
    mail(
      subject: "Webhook failure at #{Time.zone.now}",
      to: Settings.application.developer_email
    )
  end
end
