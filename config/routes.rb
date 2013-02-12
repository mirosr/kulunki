Kulunki::Application.routes.draw do
  root to: 'dashboard#show'
  
  # Auth
  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'
  get 'signout' => 'sessions#destroy'

  # Password
  get 'password/reset' => 'password#reset'

  # Users
  resources :users

  # Dashboard
  get 'dashboard' => 'dashboard#show'
end
