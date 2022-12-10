# frozen_string_literal: true

Rails.application.routes.draw do
  get '/api/v1/merchants/find_all', to: 'api/v1/merchants/search#index'
  get '/api/v1/merchants/find', to: 'api/v1/merchants/search#show'

  get '/api/v1/items/find', to: 'api/v1/items/search#show'
  get '/api/v1/items/find_all', to: 'api/v1/items/search#index'

  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index]
      end
      resources :items do
        resource :merchant, only: %i[show]
      end
    end
  end
end
