# frozen_string_literal: true

class UnauthorizedController < ApplicationController
  include Devable

  protect_from_forgery with: :null_session

  def index
    # render nothing: true, status: :unauthorized
    respond_to do |format|
      json = { error: 'unauthorized', status: 401}
      format.js { render json: json, status: :unauthorized }
      format.json { render json: json, status: :unauthorized }
      format.html { render :index, status: :unauthorized }
    end
  end
end
