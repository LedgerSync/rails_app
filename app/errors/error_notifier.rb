module ErrorNotifier
  def self.notify(error, **params)
    # params = build_params(*args)
    notify_raw(error, parameters: params)
  end

  def self.notify_raw(error, never_raise: false, **params)
    if Rails.env.test? && error.is_a?(TestError)
      case error
      when TestErrorNoRaise
        return
      else
        raise error
      end
    elsif Rails.env.production? || Rails.env.staging? || never_raise
      # Raven.send_event(error, hash)
      Raven.capture_exception(error)
    else
      Rails.logger.debug "ErrorNotifier additional data: #{params}"
      raise error
    end
  end

  # def self.build_params(*args)
  #   params = {}
  #   args.each do |arg|
  #     if arg.respond_to?(:as_error_notifier_hash)
  #       params.merge!(arg.as_error_notifier_hash)
  #     elsif arg.is_a?(Hash)
  #       params.merge!(arg)
  #     else
  #       params[:objects] ||= []
  #       params[:objects] << arg
  #     end
  #   end
  #   params
  # end
end
