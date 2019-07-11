# frozen_string_literal: true

module AuthenticationHelpers
  def login(user = nil, **keywords)
    user = user || keywords[:user] || User.first || FactoryBot.create(:user)
    login_as(user)
  end

  def logout
    logout
  end
end
