# frozen_string_literal: true

class UIController < ApplicationController
  include Devable
  include CSSHelpers
  include Renderable

  before_action :set_paper_trail_whodunnit if Settings.add_ons.paper_trail.enabled

  private

  def current_organization
    @current_organization ||= current_user.try(:organizations).try(:first).try(:decorate)
  end

  helper_method :current_organization

  def current_user
    @current_user ||= super.try(:decorate)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  helper_method :current_user

  def ensure_authorized_user
    return if current_user

    redirect_to Settings.application.login_url
  end

  def pop_redirect_url(key: :redirect)
    return session.delete(key) if session.key?(key)

    params[key]
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

  def redirect?(key: :redirect)
    params.key?(key) || session.key?(key)
  end

  def redirect_or_to(*args, key: :redirect, **keywords)
    redirect_to pop_redirect_url(key: key) if redirect?(key: key)
    redirect_to(*args, **keywords)
  end

  def router
    @router ||= Util::Router.new
  end

  def store_redirect(key: :redirect)
    session[key] = params[key]
  end
end
