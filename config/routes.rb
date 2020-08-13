Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'linebots#callback'
  get 'linebots#index'
end
