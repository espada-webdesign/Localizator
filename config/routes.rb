Rails.application.routes.draw do
  get 'localizator/index'
  get 'map/index'

  resources :ps_stores

  root 'map#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
