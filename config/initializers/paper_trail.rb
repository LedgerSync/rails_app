PaperTrail::Rails::Engine.eager_load!

module PaperTrail
  class Version < ActiveRecord::Base
    def user
      return if self.whodunnit.nil?

      User.find(self.whodunnit)
    end
  end
end