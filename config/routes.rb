Kulunki::Application.routes.draw do
  root to: 'dashboard#show'
  
  # Auth
  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  get 'signout' => 'sessions#destroy'

  # Password
  get 'password/reset' => 'password#new', as: :reset_password
  post 'password/reset' => 'password#create', as: :reset_password
  get 'password/change/:token' => 'password#edit', as: :change_password
  put 'password/change/:token' => 'password#update', as: :change_password

  # Users
  resources :users

  # Dashboard
  get 'dashboard' => 'dashboard#show'
end
