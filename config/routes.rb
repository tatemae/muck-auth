Rails.application.routes.draw do
  match '/auth/:service/callback' => 'auth#callback', :controller => 'muck/auth'
end