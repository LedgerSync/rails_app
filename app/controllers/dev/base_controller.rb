# frozen_string_literal: true

module Dev
  class BaseController < UIController
    before_action :ensure_development

    private

    def ensure_development
      raise_404 unless Rails.env.development?
    end
  end
end