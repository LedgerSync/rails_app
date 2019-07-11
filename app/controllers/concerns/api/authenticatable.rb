# frozen_string_literal: true

module API
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      before_action :restrict_access
    end

    def bearer_token
      pattern = /^Bearer /
      header = request.env['HTTP_AUTHORIZATION'] # <= env
      header.gsub(pattern, '') if header&.match(pattern)
    end

    def api_token
      @api_token ||= bearer_token

      return @api_token if @api_token.present?

      # We assume user name is the token and password is empty.
      authenticate_with_http_basic do |token, _not_used|
        @api_token = token
        @api_token.present?
      end

      @api_token
    end

    def restrict_access
      raise UnauthorizedRequestError if api_token.blank?
      raise UnauthorizedRequestError unless api_token == Settings.api.root_secret_key
    end
  end
end
