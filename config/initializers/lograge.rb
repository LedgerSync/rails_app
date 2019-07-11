Rails.application.configure do
  config.lograge.enabled = true

  # TODO: Enable when https://github.com/roidrage/lograge/issues/285 is resolved.
  # config.lograge.custom_payload do |controller|
  #   {
  #     user_id: controller.current_user.try(:id)
  #   }
  # end

  config.lograge.custom_options = lambda do |event|
    options = event.payload.slice(:request_id)
    options[:params] = event.payload[:params].except('controller', 'action')
    options[:user] = event.payload[:user_id] if event.payload[:user_id].present?
    options
  end
end