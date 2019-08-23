# frozen_string_literal: true

module Util
  class WebhookSigner
    attr_reader :data

    def initialize(data:)
      raise 'Missing Settings.application.webhooks.key' unless key.present?
      raise 'data must be a string' unless data.is_a?(String)

      @data = data
    end

    def key
      @key ||= Settings.application.webhooks.key
    end

    def signature
      @signature ||= OpenSSL::HMAC.hexdigest('SHA256', key, data)
    end
  end
end
