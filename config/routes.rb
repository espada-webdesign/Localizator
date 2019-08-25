Rails.application.routes.draw do
  get 'localizator/index'
  get 'map/index'

  resources :map
  resources :search

  root 'map#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
