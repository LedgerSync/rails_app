# frozen_string_literal: true

RSpec.configure do |config|
  %i[api feature].each do |type|
    config.include Warden::Test::Helpers, type: type
    config.after(type: type) { Warden.test_reset! }
  end
end
