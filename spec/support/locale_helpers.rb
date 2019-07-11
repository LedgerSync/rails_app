# frozen_string_literal: true

module LocaleHelpers
  extend ActiveSupport::Concern

  included do
    def t(*args, **keywords)
      I18n.t(*args, **keywords)
    end
  end
end
