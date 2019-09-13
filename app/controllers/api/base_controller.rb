module API
  class BaseController < ApplicationController
    include API::Errorable
    include API::Renderable
    include API::Authenticatable
    include API::Idempotentable
    include Rails::Pagination

    protect_from_forgery with: :null_session
  end
end
