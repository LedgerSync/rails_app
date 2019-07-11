# frozen_string_literal: true

class HomeController < UIController
  def index
    redirect_to dashboard_path if current_user
  end
end
