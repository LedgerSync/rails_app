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

    redirect_to Settings.application.login_url || root_url
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

  def redirect?(key: :redirect)
    params.key?(key) || session.key?(key)
  end

  def redirect_or_to(url, key: :redirect, query: {})
    to_url = if redirect?(key: key)
               pop_redirect_url(key: key)
             else
               url
             end

    redirect_to Util::URLHelper.new(to_url).merge_query(query).to_s
  end

  def router
    @router ||= Util::Router.new
  end

  def store_redirect(key: :redirect)
    session[key] = params[key]
  end
end
