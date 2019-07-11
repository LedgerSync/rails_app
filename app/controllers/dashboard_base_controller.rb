# frozen_string_literal: true

class DashboardBaseController < UIController
  before_action :ensure_authorized_user
end
