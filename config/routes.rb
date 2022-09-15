Rails.application.routes.draw do
  # get 'main_site/index'
  # get 'table/index'
  resources :collections
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "main_site#index"
  # get "/collections", to: "collections#index"
  get "/table", to: "table#index"
  get "/daily_sum", to: "daily_sum#index"
end
