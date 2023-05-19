Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "inventory#index"
  get "/inventory", to: "inventory#index"
  post "/inventory", to: "inventory#add"
end
