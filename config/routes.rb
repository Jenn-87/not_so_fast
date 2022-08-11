Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :sites
  resources :notifications, only: [:index, :show] do
    resources :sites
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :notifications, only: %i[index update create]
    end
  end
end
