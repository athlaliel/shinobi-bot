Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'linebot#callback'
  root 'posts#index'
end
