# frozen_string_literal: true

module Devable
  extend ActiveSupport::Concern

  included do
    def dev_offline_optional
      return if Rails.env.development? && Settings.dev.offline

      yield
    end

    helper_method :dev_offline_optional
  end
end