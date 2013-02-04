Kulunki::Application.routes.draw do
  root to: 'dashboard#show'
  
  # Auth
  get 'signup' => 'users#new'

  # Users
  resources :users

  # Dashboard
  get 'dashboard' => 'dashboard#show'
end
