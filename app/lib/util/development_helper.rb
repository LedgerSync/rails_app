# frozen_string_literal: true

module Util
  module DevelopmentHelper
    def self.development_enabled?
      Rails.env.development? || (Rails.env.test? && ENV['DEVELOPMENT'] == 'true')
    end
  end
end
