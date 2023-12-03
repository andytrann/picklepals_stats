Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/about',   to: 'static_pages#about'
  get    '/signup',  to: 'players#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :players
  resources :player_activations, only: [:update]
  resources :password_resets,    only: [:new, :create, :edit, :update]
end
