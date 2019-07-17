# frozen_string_literal: true

class UIController < ApplicationController
  include Devable
  include CSSHelpers
  include Renderable

  before_action :set_paper_trail_whodunnit if Settings.add_ons.paper_trail.enabled

  private

  def current_account
    @current_account ||= current_user.try(:accounts).try(:first).try(:decorate)
  end

  helper_method :current_account

  def current_user
    @current_user ||= super.try(:decorate)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  helper_method :current_user

  def ensure_authorized_user
    return if current_user

    flash[:info] = t('authorization.log_in_required')
    redirect_to root_url
  end

  def prettify(val)
    JSON.parse(val)
    JSON.pretty_generate(val)
  rescue JSON::ParserError, TypeError
    val
  end

  helper_method :prettify

  def raise_404
    raise ActionController::RoutingError, 'Not Found'
  end

  def raise_400
    raise ActionController::BadRequest, 'Bad Request'
  end

  def router
    @router ||= Util::Router.new
  end
end
