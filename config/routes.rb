Rails.application.routes.draw do
  match '/auth/:provider/callback' => 'muck/authentications#create', :controller => 'muck/auth'
end