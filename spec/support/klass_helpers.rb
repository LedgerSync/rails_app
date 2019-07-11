# frozen_string_literal: true

module KlassHelpers
  def reload_klass(klass, path)
    Object.send(:remove_const, (klass.is_a?(String) ? klass : klass.name))
    load path
  end
end
