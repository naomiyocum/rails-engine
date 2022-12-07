Rails.application.routes.draw do
  get '/api/v1/merchants/find', to: 'api/v1/merchants#find'
  get '/api/v1/merchants/find_all', to: 'api/v1/merchants#find_all'

  get '/api/v1/items/find_all', to: 'api/v1/items#find_all'

  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index]
      end
      resources :items, only: %i[index show create update destroy] do
        resource :merchant, only: %i[show]
      end
    end
  end
end
