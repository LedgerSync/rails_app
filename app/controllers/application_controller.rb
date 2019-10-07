class ApplicationController < ActionController::Base
  before_action :set_raven_context if Settings.dig(:add_ons, :sentry, :enabled) == true

  private

  def development_enabled?
    Util::DevelopmentHelper.development_enabled?
  end

  helper_method :development_enabled?

  def raise_404(message: nil)
    raise ActionController::RoutingError, (message || 'Not Found')
  end

  def raise_400(message: nil)
    raise ActionController::BadRequest, (message || 'Bad Request')
  end

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

  def theme
    @theme ||= Util::Theme.new
  end

  helper_method :theme
end
