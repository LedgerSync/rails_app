# frozen_string_literal: true

module Renderable # :nodoc:
  extend ActiveSupport::Concern

  included do
    def redirect_to(*args, flash_danger: nil, flash_info: nil, flash_success: nil, **keywords)
      flash[:info] = flash_info if flash_info.present?
      flash[:danger] = flash_danger if flash_danger.present?
      flash[:success] = flash_success if flash_success.present?

      super(*args, **keywords)
    end

    def save_and_render_form(form:, on_failure: nil, on_success: nil)
      result = form.save

      if result.success?
        flash[:success] = form.translation_success if form.translation_success.present?
        on_success.call(result) if !block_given? || on_success.present?
      else
        flash[:danger] = result.error.message
        on_failure.call(result) if !block_given? || on_failure.present?
      end

      yield(result) if block_given?
    end
  end
end