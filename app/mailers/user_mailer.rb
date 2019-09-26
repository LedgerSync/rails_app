# frozen_string_literal: true

class UserMailer < ApplicationMailer
  private

  def mail(user:, **keywords)
    mail.perform_deliveries = false if Settings.mailer.disable_email_to_users
    super(
      **keywords.merge(
        to: user.email
      )
    )
  end
end
