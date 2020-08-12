Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'post#callback'
  root 'posts#index'
end
