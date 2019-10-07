class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.from_email
  layout 'mailer'
end
