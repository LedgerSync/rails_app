# frozen_string_literal: true

module Util
  class Router # :nodoc:
    include Rails.application.routes.url_helpers

    def login_url
      Settings.application.login_url
    end

    if Rails.env.test?
      instance_methods.map(&:to_s).each do |method|
        next unless method.ends_with?('_url')

        define_method(method) do
          raise "Method #{method} not available in test.  Please use *_path instead."
        end
      end
    end
  end
end
