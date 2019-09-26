# frozen_string_literal: true

class UserMailer < ApplicationMailer
  after_action { do_not_deliver unless deliver? }

  private

  def deliver?
    return false if Settings.mailer.disable_email_to_users

    defined?(@deliver) ? @deliver : true
  end

  def do_deliver
    mail.perform_deliveries = true
    @deliver = true
  end

  def do_not_deliver
    mail.perform_deliveries = false
    @deliver = false
  end
end
