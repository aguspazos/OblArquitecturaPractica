
Rails.application.routes.draw do
  
  root 'sessions#new_user'
  resources :cadets
  
  get '/users/main',  to: 'users#main'
  get '/users/create-shipment',  to: 'users#create_shipment'
  resources :users
  resources :admins


  get    '/cadet-login',   to: 'sessions#new_cadet'
  post   '/cadet-login',   to: 'sessions#create_cadet'
  delete '/cadet-logout',  to: 'sessions#destroy_cadet'
  
  get    '/login',   to: 'sessions#new_user'
  post   '/login',   to: 'sessions#create_user'
  delete '/logout',  to: 'sessions#destroy_user'
  
  get    '/admin',         to: 'admins#index'
  get    '/admin-login',   to: 'sessions#new_admin'
  post   '/admin-login',   to: 'sessions#create_admin'
  delete '/admin-logout',  to: 'sessions#destroy_admin'
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]

  root to: "home#show"
  
  resources:stats


end

