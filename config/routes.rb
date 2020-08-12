Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'posts#callback'
  root 'posts#index'
end
