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

  # Email
  get 'email/change/:token' => 'email#update', as: :change_email

  # Users
  resources :users

  # Profile
  get 'profile' => 'profile#show'
  get 'profile/edit' => 'profile#edit', as: :edit_profile
  put 'profile/edit' => 'profile#update', as: :edit_profile
  put 'profile/password/change' => 'profile#change_password',
    as: :profile_change_password
  put 'profile/email/change' => 'profile#change_email',
    as: :profile_change_email

  # Dashboard
  get 'dashboard' => 'dashboard#show'

  # Households
  resources :households, only: [:new, :create]
end
