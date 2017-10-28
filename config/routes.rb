
Rails.application.routes.draw do
  
  root 'sessions#new_user'
  
  get '/shipments/create-shipment',  to: 'shipments#create_shipment'
  
  resources :shipments
  resources :cadets
  
  get '/users/main',  to: 'users#main'
  get '/users/create-shipment',  to: 'users#create_shipment'


  get '/users/invite', to:'users#invite'
  post '/users/send_invite', to:'users#send_invite'
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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
    get 'auth/:provider/callback', to: 'sessions#create'
    get 'auth/failure', to: redirect('/')
    get 'signout', to: 'sessions#destroy', as: 'signout'

    resources :sessions, only: [:create, :destroy]
    resource :home, only: [:show]

    root to: "home#show"
  
end

