class ApplicationRecord < ActiveRecord::Base
  include ModelSettings

  self.abstract_class = true
end
