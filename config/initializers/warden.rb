Warden::Strategies.add(:token) do
  def valid?
    result.success?
  end

  def authenticate!
    result.failure? ? fail!(I18n.t('authentication.invalid_token')) : success!(result.value.user)
  end

  private

  def result
    @result ||= Forms::AuthTokens::Use.new(
      token: params[:id]
    ).save
  end
end

Warden::Strategies.add(:developer) do
  def valid?
    raise 'Invalid strategy' unless Rails.env.development?

    true
  end

  def authenticate!
    success!(User.first || FactoryBot.create(:user, :admin))
  end
end

Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  # manager.failure_app = Proc.new { |_env|
  #   ['401', {'Content-Type' => 'application/json'}, { error: 'Unauthorized', code: 401 }]
  # }
  manager.failure_app = ->(env){ UnauthorizedController.action(:index).call(env) }

  manager.default_strategies :token
  # Optional Settings (see Warden wiki)
  manager.scope_defaults :user, strategies: [:token]
  manager.default_scope = :user
  # manager.intercept_401 = false # Warden will intercept 401 responses, which can cause conflicts
end