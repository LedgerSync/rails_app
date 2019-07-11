module FactoryBot
  class SyntaxRunner
    def first_or_create(type)
      if type.is_a?(ActiveRecord::Base)
        klass = type
        factory_string = type.name.underscore
      else
        factory_string = type
        klass = type.to_s.camelcase.constantize
      end

      klass.first || FactoryBot.create(factory_string)
    end
  end
end