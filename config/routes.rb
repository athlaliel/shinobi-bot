Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'linebots#callback'
  root 'linebots#index'
end
