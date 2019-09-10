module API
  module Idempotentable
    extend ActiveSupport::Concern

    included do
      around_action :idempotency_wrap
    end

    def idempotency_current_lock?
      IdempotencyKey.current_advisory_lock.nil?
    end

    def idempotency_key_header
      @idempotency_key_header ||= request.env.fetch('HTTP_IDEMPOTENCY_KEY', nil)
    end

    def idempotency_key
      @idempotency_key ||= begin
        result = Forms::IdempotencyKeys::FindActive
          .new(key: idempotency_key_header)
          .save

        (result.success? ? result.value : nil)
      end
    end

    def idempotency_key?
      idempotency_key.present?
    end

    def idempotency_record_request!
      return if [400, 401, 404].include?(response.status) # Do not record if invalid, unauthorized, not_found

      response_body = if response.body.is_a?(String)
                        JSON.parse(response.body)
                      else
                        response.body
                      end

      IdempotencyKey.create!(
        key: idempotency_key_header,
        request_id: request.uuid,
        request_body: request_body,
        response_body: response_body,
        response_status: response.status
      )
    end

    def idempotentable_request?
      request.post? || request.put?
    end

    def idempotency_wrap
      if idempotency_key_header.present?
        raise Idempotency::InvalidRequestMethodError unless idempotentable_request?
        raise Idempotency::DuplicateRequestError, idempotency_key_header if idempotency_key? && idempotency_key.request_body == request_body

        ActiveRecord::Base.transaction do
          IdempotencyKey.with_advisory_lock(idempotency_key_header, transaction: true) do
            if idempotency_key?
              render idempotency_key.response_data
            else
              yield
              idempotency_record_request!
            end
          end
        end
      else
        raise Idempotency::IdempotencyKeyRequiredError if idempotentable_request?
        yield
      end
    end

    def request_body
      @request_body ||= params.permit!.to_h.except(:action, :controller, :format)
    end
  end
end
