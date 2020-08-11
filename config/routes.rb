Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'linebots#callback'
  rroot 'posts#index'
end
