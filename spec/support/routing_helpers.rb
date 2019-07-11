# frozen_string_literal: true

module RoutingHelpers
  extend ActiveSupport::Concern

  included do
    def r
      @r ||= Util::Router.new(test: true)
    end
  end
end
