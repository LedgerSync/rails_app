# frozen_string_literal: true

Rails.application.routes.draw do
  api_routes = proc do
    get '/' => 'errors#not_found'

    namespace :api, path: nil, defaults: { format: 'json' } do
      namespace :v1 do
        resources :users, only: %i[create update] do
          resources :auth_tokens, only: :create
        end

        resources :syncs, only: %i[create show], path: :sync
        resources :syncs, only: %i[create show] do
          member do
            post :retry
            post :skip
          end
        end
        resources :ledger_resources, only: %i[create destroy show update]
        resources :resources

        resources :organizations, only: %i[create show update] do
          member do
            post 'users/:user_id', action: :add_user
            delete 'users/:user_id', action: :remove_user
          end
        end
        resources :users, only: %i[create show update]
      end
    end
  end

  get '/404' => 'errors#not_found'
  get '/500' => 'errors#exception'
  get '/errors/404' => 'errors#not_found'
  get '/errors/500' => 'errors#exception'

  # http://stackoverflow.com/questions/5923882/subdomain-constraint-and-excluding-certain-subdomains
  constraints subdomain: /^(?!api|auth\Z)/ do
    scope :api, &api_routes

    require 'sidekiq/web'

    sidekiq_constraint = lambda do |request|
      return false unless request.session.key?('warden.user.user.key')
      user = User.find_by(id: request.session['warden.user.user.key'].last)
      return false if user.blank?

      user.is_admin?
    end

    constraints sidekiq_constraint do
      mount Sidekiq::Web => '/admin/sidekiq'
    end

    root to: 'home#index'
    get '/dashboard', to: 'dashboard#index'

    namespace :dev do
      get '/', to: 'home#index'
      resources :syncs, only: %i[create new]
    end

    resources :auth_tokens, only: %i[index show], path: :auth
    get :logout, action: :destroy, controller: :auth_tokens
    get :dev_login, action: :dev_login, controller: :auth_tokens

    resources :syncs, only: %i[index show] do
      resources :sync_ledgers, only: :create, path: :ledgers, as: :ledgers

      member do
        post :perform
      end
    end

    resources :ledger_resources, only: %i[show update] do
      resources :ledger_resource_assignments, as: :assignments, path: :assignments, only: %i[create index] do
        collection do
          get :search
        end
      end

      member do
        post :create
      end
    end
    resources :ledgers, only: %i[index show]

    namespace :ledgers do
      resources :quickbooks_onlines, path: :quickbooks_online, only: %i[destroy new show update], controller: :quickbooks_online do
        collection do
          get :callback
        end
        # get 'qbo', to: 'qbo#show'
        # get 'qbo/connect', to: 'qbo#connect'
        # get 'qbo/callback', to: 'qbo#callback'
        # get 'qbo/disconnect', to: 'qbo#disconnect'
        # get 'qbo/refresh', to: 'qbo#refresh'
      end
    end
  end

  constraints subdomain: 'api', &api_routes
end
