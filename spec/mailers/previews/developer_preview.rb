# Preview all emails at http://localhost:3000/rails/mailers/developer
class DeveloperPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/developer/webhook_failure
  def webhook_failure
    DeveloperMailer.webhook_failure
  end

end
