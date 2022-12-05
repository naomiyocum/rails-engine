Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index]
      end
      resources :items, only: %i[index show create update destroy]
    end
  end

  get '/api/v1/items/:item_id/merchant', to: 'api/v1/merchants#show'
end
