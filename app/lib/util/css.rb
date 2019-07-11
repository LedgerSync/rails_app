# frozen_string_literal: true

# CSS Helpers
module Util
  class CSS
    def self.class_string(*css_klasses, **conditional_css_klasses)
      conditional_css_klasses.each do |klass, conditional|
        (true_klass, false_klass) = klass.to_s.split(/[:\|]/)
        css_klasses << (conditional ? true_klass : false_klass)
      end

      css_klasses.compact.map(&:to_s).join(' ').strip
    end
  end
end
