Rails.application.routes.draw do
  resources :notes
  resource :users, only: [:create]
  get "users/:id", to: "users#show"
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  get "/present_user", to: "users#present_user"
end
