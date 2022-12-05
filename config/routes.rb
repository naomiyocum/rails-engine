Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index]
      end
      resources :items, only: %i[index show create]
    end
  end
end
