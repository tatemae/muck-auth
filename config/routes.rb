Rails.application.routes.draw do
  resources :authentications, :controller => 'muck/authentications'
  match '/auth/:provider/callback' => 'muck/authentications#create', :controller => 'muck/authentications'
  match '/auth/failure' => 'muck/authentications#failure', :controller => 'muck/authentications'
end