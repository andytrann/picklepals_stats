Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/about',   to: 'static_pages#about'
  get    '/signup',  to: 'players#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/submit',  to: 'match_submissions#new'
  resources :players,             except: :index
  resources :player_activations,  only: [:update]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :matches,             only: [:index, :show, :destroy]
  resources :match_submissions,   only: [:index, :new, :create]
end
