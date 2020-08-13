Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'linebots#callback'
  root 'posts#index'
  get "*path" => 'application#render_404'
end
