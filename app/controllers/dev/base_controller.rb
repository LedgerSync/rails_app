# frozen_string_literal: true

module Dev
  class BaseController < UIController
    before_action :ensure_development

    private

    def ensure_development
      return if development_enabled?

      raise_404
    end
  end
end
