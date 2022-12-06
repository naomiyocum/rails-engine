Rails.application.routes.draw do
  get '/api/v1/merchants/find', to: 'api/v1/merchants#find'
  get '/api/v1/items/:item_id/merchant', to: 'api/v1/merchants#show'

  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index]
      end
      resources :items, only: %i[index show create update destroy]
    end
  end
end
