# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator # :nodoc:
  delegate_all

  def t(*args)
    I18n.t(*args)
  end
end
