# frozen_string_literal: true

module Util
  class Router # :nodoc:
    include Rails.application.routes.url_helpers

    attr_reader :test

    def initialize(test: false)
      @test = test

      # Remove URL routes from router as they will not work in capybara.
      return unless test

      self.class.instance_methods.map(&:to_s).select { |e| e.ends_with?('_url') }.each do |method|
        self.instance_eval("undef #{method}")
      end
    end

    def login_url
      Settings.application.login_url
    end
  end
end
