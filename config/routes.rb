Rails.application.routes.draw do
  get 'table/index'
  resources :collections
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "collection#index"
  # Defines the root path route ("/")
  # root "articles#index"
  get "/table", to: "table#index"
end
