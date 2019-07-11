module API
  module Errorable
    def self.included(klass)
      klass.class_eval do
        rescue_from Exception, with: :rescue_exception
        rescue_from APIError, with: :rescue_api_error
        rescue_from ActiveRecord::RecordNotFound, with: :rescue_exception_record_not_found
        rescue_from Formify::Errors::ValidationError, with: :rescue_exception_form_validation_error
      end
    end

    private

    def no_such_record(record_type, param = 'id')
      raise NoSuchRecordError.new(record_type, param)
    end

    def rescue_exception(error = nil)
      ErrorNotifier.notify(error)
      rescue_api_error(APIError.new)
    end

    def rescue_api_error(error, status: nil)
      render json: error.message, status: status || error.status
    end

    def rescue_exception_form_validation_error(e)
      form = e.form
      param = form.errors.details.keys.first
      translation_key = form.errors.details[param].first[:error]
      # error_key = form.class.t_error_key(param, translation_key)
      api_error_key = form.class.t_error_key(param, "api_#{translation_key}")

      rescue_api_error(
        ParamValueError.new(
          param,
          message: t(
            api_error_key,
            default: form.errors.full_messages_for(param).first
          )
        )
      )
    end

    def rescue_exception_record_not_found(e)
      rescue_api_error(e, status: 404)
    end
  end
end
