# frozen_string_literal: true

# CSS Helpers for Views
module CSSHelpers
  extend ActiveSupport::Concern

  included do
    def css_class_string(*args)
      Util::CSS.class_string(*args)
    end

    helper_method :css_class_string
  end
end