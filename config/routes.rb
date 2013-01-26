Kulunki::Application.routes.draw do
  root to: 'dashboard#show'
  
  # Dashboard
  get 'dashboard' => 'dashboard#show'
end
