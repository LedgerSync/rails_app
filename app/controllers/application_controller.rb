class ApplicationController < ActionController::Base
  before_action :set_raven_context if Settings.dig(:add_ons, :sentry, :enabled) == true

  private

  if Settings.dig(:add_ons, :sentry, :enabled) == true
    def set_raven_context
      Raven.user_context(
        email: current_user.try(:email),
        id: current_user.try(:id),
        ip_address: request.ip
      )

      extra_context = {
        params: params.to_unsafe_h,
        url: request.url
      }
      Raven.extra_context(**extra_context)
    end
  end
end
